const express = require('express');
const authController = require('../controllers/authController');
const auth = require('../middlewares/auth');
const { authLimiter } = require('../middlewares/rateLimiter');

const authRouter = express.Router();

authRouter.post("/api/signup", authLimiter, authController.signup);
authRouter.post("/api/signin", authLimiter, authController.signin);
authRouter.post("/api/refresh-token", authController.refreshToken);
authRouter.post("/api/logout", auth, authController.logout);
authRouter.get('/api/user', auth, authController.getUserData);

module.exports = authRouter;