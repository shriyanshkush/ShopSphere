const express = require('express');
const productController = require('../controllers/productController');
const auth = require('../middlewares/auth');
const pagination = require('../middlewares/pagination');
const { searchLimiter } = require('../middlewares/rateLimiter');

const productRouter = express.Router();

productRouter.get('/api/products', auth, pagination, productController.getProducts);
productRouter.get('/api/products/categories', auth, productController.getCategories);
productRouter.get('/api/products/category/:category', auth, pagination, productController.getProductsByCategory);
productRouter.get('/api/products/search/:name', auth, pagination, productController.searchProducts);
productRouter.get('/api/products/suggestions', auth, searchLimiter, productController.getSearchSuggestions);
productRouter.get('/api/deal-of-day', auth, productController.getDealOfDay);
productRouter.post('/api/products/:id/view', auth, productController.trackProductView);
productRouter.get('/api/products/recently-viewed', auth, productController.getRecentlyViewed);
productRouter.get(
  '/api/products/:id/detail',
  auth,
  productController.getProductDetailWithReviews
);

module.exports = productRouter;