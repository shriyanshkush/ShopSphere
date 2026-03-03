const { getProductById } = require('../services/product.service');

const getProductByIdToolDef = {
  type: 'function',
  function: {
    name: 'getProductByIdTool',
    description: 'Get product by id',
    parameters: {
      type: 'object',
      properties: { productId: { type: 'string' } },
      required: ['productId'],
    },
  },
};

async function getProductByIdTool(args, context) {
  return getProductById(args.productId, context.authToken);
}

module.exports = { getProductByIdToolDef, getProductByIdTool };
