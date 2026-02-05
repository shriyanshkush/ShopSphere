const express = require('express');
const reviewController = require('../controllers/reviewController');
const auth = require('../middlewares/auth');
const pagination = require('../middlewares/pagination');

const reviewRouter = express.Router();

reviewRouter.post('/api/reviews', auth, reviewController.addReview);
reviewRouter.get('/api/reviews/:productId', pagination, reviewController.getProductReviews);
reviewRouter.delete('/api/reviews/:reviewId', auth, reviewController.deleteReview);

module.exports = reviewRouter;