const express = require('express');
const userController = require('../controllers/userController');
const auth = require('../middlewares/auth');
const pagination = require('../middlewares/pagination');

const userRouter = express.Router();

// Cart Management
userRouter.post('/api/add-to-cart', auth, userController.addToCart);
userRouter.get('/api/cart', auth, userController.getCart);
userRouter.delete('/api/remove-from-cart/:id', auth, userController.removeFromCart);

// Legacy single address
userRouter.post('/api/save-user-address', auth, userController.saveAddress);

// Address book (new)
userRouter.get('/api/user/addresses', auth, userController.getAddresses);
userRouter.post('/api/user/addresses', auth, userController.addAddress);
userRouter.put('/api/user/addresses/:addressId', auth, userController.updateAddress);
userRouter.patch('/api/user/addresses/:addressId/select', auth, userController.selectAddress);

// Orders
userRouter.post('/api/order', auth, userController.placeOrder);
userRouter.get('/api/orders/me', auth, pagination, userController.getMyOrders);
userRouter.get('/api/orders/recent', auth, userController.getRecentOrders);
userRouter.get('/api/orders/:orderId', auth, userController.getOrderDetails);

module.exports = userRouter;
