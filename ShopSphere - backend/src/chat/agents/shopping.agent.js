const { assistantSystemPrompt, runChatCompletion } = require('../services/ai.service');
const { searchProductsToolDef, searchProductsTool } = require('../tools/searchProducts.tool');
const { getProductByIdToolDef, getProductByIdTool } = require('../tools/getProduct.tool');
const { getCartToolDef, getCartTool, addToCartToolDef, addToCartTool } = require('../tools/cart.tool');
const logger = require('../utils/logger');

const tools = [searchProductsToolDef, getProductByIdToolDef, getCartToolDef, addToCartToolDef];
const handlers = { searchProductsTool, getProductByIdTool, getCartTool, addToCartTool };

async function runShoppingAgent({ history, userMessage, context }) {
  const messages = [
    { role: 'system', content: assistantSystemPrompt },
    ...history.map((m) => ({ role: m.role, content: m.content })),
    { role: 'user', content: userMessage },
  ];

  const firstPass = await runChatCompletion(messages, tools);
  const choice = firstPass?.choices?.[0]?.message;
  if (!choice) return 'Sorry, I could not process that request right now.';
  if (!choice.tool_calls?.length) return choice.content || 'Can you share more details?';

  const toolMessages = [];
  for (const toolCall of choice.tool_calls) {
    const name = toolCall.function.name;
    const handler = handlers[name];
    if (!handler) continue;

    try {
      const args = JSON.parse(toolCall.function.arguments || '{}');
      const result = await handler(args, context);
      toolMessages.push({ role: 'tool', tool_call_id: toolCall.id, content: JSON.stringify(result) });
    } catch (error) {
      logger.error('Tool execution failed', name, error.message);
      toolMessages.push({
        role: 'tool',
        tool_call_id: toolCall.id,
        content: JSON.stringify({ error: 'Tool failed to execute gracefully.' }),
      });
    }
  }

  const secondPass = await runChatCompletion([...messages, choice, ...toolMessages], tools);
  return secondPass?.choices?.[0]?.message?.content || 'I hit a snag, please try again in a moment.';
}

module.exports = { runShoppingAgent };
