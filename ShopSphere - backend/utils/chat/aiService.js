const assistantSystemPrompt = `You are a smart, friendly AI shopping assistant.
Help users find products, compare items, answer questions, and manage cart.
Always call tools when product data or cart data is needed.
Never hallucinate product information.
Be concise and persuasive.
Use markdown formatting.`;

const OPENAI_BASE_URL = (process.env.OPENAI_BASE_URL || 'https://generativelanguage.googleapis.com/v1beta/openai').replace(/\/$/, '');
const LLM_MODEL = process.env.LLM_MODEL || 'gemini-2.0-flash';
const CHAT_API_KEY = process.env.Gemini_API_KEY || process.env.OPENAI_API_KEY || '';

function getAuthHeaders() {
  if (!CHAT_API_KEY) {
    throw new Error('Missing AI API key. Set Gemini_API_KEY (or OPENAI_API_KEY).');
  }

  return {
    'Content-Type': 'application/json',
    Authorization: `Bearer ${CHAT_API_KEY}`,
  };
}

async function parseErrorResponse(response, prefix) {
  const text = await response.text();
  throw new Error(`${prefix} failed with status ${response.status}: ${text.slice(0, 500)}`);
}

async function runChatCompletion(messages, tools) {
  const response = await fetch(`${OPENAI_BASE_URL}/chat/completions`, {
    method: 'POST',
    headers: getAuthHeaders(),
    body: JSON.stringify({
      model: LLM_MODEL,
      temperature: 0.4,
      tool_choice: 'auto',
      messages,
      tools,
    }),
    signal: AbortSignal.timeout(30000),
  });

  if (!response.ok) {
    await parseErrorResponse(response, 'LLM request');
  }

  return response.json();
}

async function createEmbedding(input) {
  const response = await fetch(`${OPENAI_BASE_URL}/embeddings`, {
    method: 'POST',
    headers: getAuthHeaders(),
    body: JSON.stringify({ model: 'text-embedding-3-small', input }),
    signal: AbortSignal.timeout(30000),
  });

  if (!response.ok) {
    await parseErrorResponse(response, 'Embedding request');
  }

  const data = await response.json();
  return data.data?.[0]?.embedding || [];
}

module.exports = { assistantSystemPrompt, runChatCompletion, createEmbedding };
