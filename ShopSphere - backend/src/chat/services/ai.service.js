const assistantSystemPrompt = `You are a smart, friendly AI shopping assistant.
Help users find products, compare items, answer questions, and manage cart.
Always call tools when product data or cart data is needed.
Never hallucinate product information.
Be concise and persuasive.
Use markdown formatting.`;

const OPENAI_BASE_URL = process.env.OPENAI_BASE_URL || 'https://generativelanguage.googleapis.com/v1beta/openai';
const LLM_MODEL = process.env.LLM_MODEL || 'gemini-2.0-flash';
const MAX_RETRIES = Number(process.env.LLM_MAX_RETRIES || 2);

class LlmRequestError extends Error {
  constructor(message, status) {
    super(message);
    this.name = 'LlmRequestError';
    this.status = status;
  }
}

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

async function parseErrorMessage(response) {
  try {
    const payload = await response.json();
    return payload?.error?.message || payload?.message || `status ${response.status}`;
  } catch {
    return `status ${response.status}`;
  }
}

function getApiKey() {
  return process.env.GEMINI_API_KEY || process.env.Gemini_API_KEY || process.env.OPENAI_API_KEY;
}

async function runChatCompletion(messages, tools) {
  const apiKey = getApiKey();
  if (!apiKey) {
    throw new Error('Missing AI API key. Set GEMINI_API_KEY (or OPENAI_API_KEY).');
  }
  for (let attempt = 0; attempt <= MAX_RETRIES; attempt += 1) {
    const response = await fetch(`${OPENAI_BASE_URL}/chat/completions`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${apiKey}`,
      },
      body: JSON.stringify({ model: LLM_MODEL, temperature: 0.4, messages, tools }),
    });

    if (response.ok) {
      return response.json();
    }

    const details = await parseErrorMessage(response);
    const retryable = response.status === 429 || response.status >= 500;
    const canRetry = retryable && attempt < MAX_RETRIES;

    if (canRetry) {
      await sleep((attempt + 1) * 500);
      continue;
    }

    throw new LlmRequestError(`LLM request failed (${response.status}): ${details}`, response.status);
  }

  throw new LlmRequestError('LLM request failed unexpectedly', 500);
}

async function createEmbedding(input) {
  const apiKey = getApiKey();
  if (!apiKey) {
    throw new Error('Missing AI API key. Set GEMINI_API_KEY (or OPENAI_API_KEY).');
  }
  const response = await fetch(`${OPENAI_BASE_URL}/embeddings`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${apiKey}`,
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
