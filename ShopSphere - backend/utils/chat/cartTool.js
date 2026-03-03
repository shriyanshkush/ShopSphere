const { getCart, addToCart } = require('./productService');

const getCartToolDef = {
  type: 'function',
  function: {
    name: 'getCartTool',
    description: 'Fetch current user cart',
    parameters: {
      type: 'object',
      properties: { userId: { type: 'string' } },
      required: ['userId'],
    },
  },
};

const addToCartToolDef = {
  type: 'function',
  function: {
    name: 'addToCartTool',
    description: 'Add product to cart',
    parameters: {
      type: 'object',
      properties: {
        productId: { type: 'string' },
        quantity: { type: 'number', minimum: 1 },
      },
      required: ['productId', 'quantity'],
    },
  },
};

const getCartTool = (args, context) => getCart(args.userId, context.authToken);
const addToCartTool = (args, context) => addToCart(args.productId, args.quantity, context.authToken);

module.exports = { getCartToolDef, addToCartToolDef, getCartTool, addToCartTool };
