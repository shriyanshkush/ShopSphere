const { assistantSystemPrompt, runChatCompletion } = require('./aiService');
const { searchProductsToolDef, searchProductsTool } = require('./searchProductsTool');
const { getProductByIdToolDef, getProductByIdTool } = require('./getProductTool');
const { getCartToolDef, getCartTool, addToCartToolDef, addToCartTool } = require('./cartTool');
const logger = require('../chatLogger');

const tools = [searchProductsToolDef, getProductByIdToolDef, getCartToolDef, addToCartToolDef];
const handlers = { searchProductsTool, getProductByIdTool, getCartTool, addToCartTool };

async function runShoppingAgent({ history, userMessage, context }) {
  const messages = [
    { role: 'system', content: assistantSystemPrompt },
    ...history.map((m) => ({ role: m.role, content: m.content })),
    { role: 'user', content: userMessage },
  ];

  let firstPass;
  try {
    firstPass = await runChatCompletion(messages, tools);
  } catch (error) {
    logger.error('LLM first pass failed', error.message);
    return 'I am having trouble reaching the AI service right now. Please verify AI configuration and try again.';
  }

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

  try {
    const secondPass = await runChatCompletion([...messages, choice, ...toolMessages], tools);
    return secondPass?.choices?.[0]?.message?.content || 'I hit a snag, please try again in a moment.';
  } catch (error) {
    logger.error('LLM second pass failed', error.message);
    return 'I found matching data but could not finalize the response. Please try once more.';
  }
}

module.exports = { runShoppingAgent };
