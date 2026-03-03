const assistantSystemPrompt = `You are a smart, friendly AI shopping assistant.
Help users find products, compare items, answer questions, and manage cart.
Always call tools when product data or cart data is needed.
Never hallucinate product information.
Be concise and persuasive.
Use markdown formatting.`;

const OPENAI_BASE_URL = process.env.OPENAI_BASE_URL || 'https://generativelanguage.googleapis.com/v1beta/openai';
const LLM_MODEL = process.env.LLM_MODEL || 'gemini-2.0-flash';

async function runChatCompletion(messages, tools) {
  const response = await fetch(`${OPENAI_BASE_URL}/chat/completions`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${process.env.Gemini_API_KEY}`,
    },
    body: JSON.stringify({ model: LLM_MODEL, temperature: 0.4, messages, tools }),
  });

  if (!response.ok) {
    throw new Error(`LLM request failed with status ${response.status}`);
  }

  return response.json();
}

async function createEmbedding(input) {
  const response = await fetch(`${OPENAI_BASE_URL}/embeddings`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${process.env.Gemini_API_KEY}`,
    },
    body: JSON.stringify({ model: 'text-embedding-3-small', input }),
  });

  if (!response.ok) {
    throw new Error(`Embedding request failed with status ${response.status}`);
  }

  const data = await response.json();
  return data.data?.[0]?.embedding || [];
}

module.exports = { assistantSystemPrompt, runChatCompletion, createEmbedding };
