const express = require('express');
const adminController = require('../controllers/adminController');
const admin = require('../middlewares/admin');
const pagination = require('../middlewares/pagination');

const adminRouter = express.Router();

// Product Management
adminRouter.post('/admin/add-product', admin, adminController.addProduct);
adminRouter.get('/admin/get-products', admin, pagination, adminController.getProducts);
adminRouter.put('/admin/update-product/:id', admin, adminController.updateProduct);
adminRouter.delete('/admin/delete-product/:id', admin, adminController.deleteProduct);

// Order Management
adminRouter.get('/admin/get-orders', admin, pagination, adminController.getOrders);
adminRouter.post('/admin/change-order-status', admin, adminController.changeOrderStatus);

// Analytics & Reports
adminRouter.get('/admin/analytics', admin, adminController.getAnalytics);
adminRouter.get('/admin/inventory-report', admin, adminController.getInventoryReport);
adminRouter.get('/admin/inventory', admin, adminController.getInventory);
adminRouter.get('/admin/best-selling-products', admin, adminController.getBestSellingProducts);
adminRouter.get('/admin/low-inventory-alerts', admin, adminController.getLowInventoryAlerts);

module.exports = adminRouter;