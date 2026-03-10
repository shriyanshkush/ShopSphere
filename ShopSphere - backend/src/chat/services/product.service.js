const { createEmbedding } = require('./ai.service');

function getApiBaseUrl() {
  const configuredBaseUrl = process.env.EXISTING_API_BASE_URL;
  if (configuredBaseUrl) return configuredBaseUrl;

  const port = process.env.PORT || 3000;
  return `http://127.0.0.1:${port}`;
}


function resolveAccessToken(authToken) {
  if (!authToken || typeof authToken !== 'string') return null;
  return authToken.replace(/^Bearer\s+/i, '').trim();
}

function cosineSimilarity(a = [], b = []) {
  if (!a.length || !b.length || a.length !== b.length) return 0;
  let dot = 0;
  let normA = 0;
  let normB = 0;

  for (let i = 0; i < a.length; i += 1) {
    dot += a[i] * b[i];
    normA += a[i] ** 2;
    normB += b[i] ** 2;
  }

  return dot / (Math.sqrt(normA) * Math.sqrt(normB) || 1);
}

async function apiFetch(path, { method = 'GET', authToken, body, query } = {}) {
  const baseUrl = getApiBaseUrl();
  let url;

  try {
    url = new URL(path, baseUrl);
  } catch (error) {
    throw new Error(`Invalid EXISTING_API_BASE_URL configuration: ${baseUrl}`);
  }

  if (query) {
    Object.keys(query).forEach((key) => url.searchParams.set(key, query[key]));
  }

  const token = resolveAccessToken(authToken);

  const response = await fetch(url, {
    method,
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { 'x-auth-token': token } : {}),
      ...(authToken ? { Authorization: authToken.startsWith('Bearer ') ? authToken : `Bearer ${token}` } : {}),
    },
    ...(body ? { body: JSON.stringify(body) } : {}),
  });

  if (!response.ok) {
    throw new Error(`API ${path} failed with status ${response.status}`);
  }

  return response.json();
}

async function searchProducts(query, authToken) {
  const data = await apiFetch('/api/products', { query: { search: query }, authToken });
  const products = Array.isArray(data) ? data : data.products || [];
  if (!products.length) return [];

  const queryEmbedding = await createEmbedding(query);
  const ranked = await Promise.all(
    products.slice(0, 20).map(async (product) => {
      const text = `${product.name || ''} ${product.description || ''}`.trim();
      const emb = await createEmbedding(text);
      return { ...product, score: cosineSimilarity(queryEmbedding, emb) };
    })
  );

  return ranked.sort((a, b) => b.score - a.score).slice(0, 5);
}

const getProductById = (productId, authToken) => apiFetch(`/api/products/${productId}/detail`, { authToken });
const getCart = (userId, authToken) => apiFetch('/api/cart', { authToken, query: { userId } });
const addToCart = (productId, quantity, authToken) =>
  apiFetch('/api/add-to-cart', { method: 'POST', authToken, body: { product: productId, quantity } });

module.exports = { searchProducts, getProductById, getCart, addToCart };
