const { searchProducts } = require('./productService');

const searchProductsToolDef = {
  type: 'function',
  function: {
    name: 'searchProductsTool',
    description: 'Search products semantically and return top matching items',
    parameters: {
      type: 'object',
      properties: { query: { type: 'string', description: 'Natural language query' } },
      required: ['query'],
    },
  },
};

async function searchProductsTool(args, context) {
  return searchProducts(args.query, context.authToken);
}

module.exports = { searchProductsToolDef, searchProductsTool };
