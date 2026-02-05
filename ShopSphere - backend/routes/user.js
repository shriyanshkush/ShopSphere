const express = require('express');
const userController = require('../controllers/userController');
const auth = require('../middlewares/auth');
const pagination = require('../middlewares/pagination');

const userRouter = express.Router();

// Cart Management
userRouter.post('/api/add-to-cart', auth, userController.addToCart);
userRouter.delete('/api/remove-from-cart/:id', auth, userController.removeFromCart);

// Address
userRouter.post("/api/save-user-address", auth, userController.saveAddress);

// Orders
userRouter.post("/api/order", auth, userController.placeOrder);
userRouter.get("/api/orders/me", auth, pagination, userController.getMyOrders);
userRouter.get("/api/orders/:orderId", auth, userController.getOrderDetails);

module.exports = userRouter;