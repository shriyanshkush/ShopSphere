const express = require('express');
const wishlistController = require('../controllers/wishlistController');
const auth = require('../middlewares/auth');

const wishlistRouter = express.Router();

wishlistRouter.post('/api/wishlist/add', auth, wishlistController.addToWishlist);
wishlistRouter.delete('/api/wishlist/remove/:productId', auth, wishlistController.removeFromWishlist);
wishlistRouter.get('/api/wishlist', auth, wishlistController.getWishlist);
wishlistRouter.post('/api/wishlist/move-to-cart', auth, wishlistController.moveToCart);

module.exports = wishlistRouter;