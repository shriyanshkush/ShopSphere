require('dotenv').config();
const express = require("express");
const helmet = require('helmet');
const cors = require('cors');
const compression = require('compression');
const morgan = require('morgan');

const connectDB = require('./src/config/database');
const errorHandler = require('./middlewares/errorHandler');
const { apiLimiter } = require('./middlewares/rateLimiter');

// Import Routes
const authRouter = require('./routes/auth');
const adminRouter = require('./routes/admin');
const homeRoutes = require("./routes/home");
const productRouter = require('./routes/product');
const userRouter = require('./routes/user');
const reviewRouter = require('./routes/review');
const wishlistRouter = require('./routes/wishlist');

// Initialize Express
const app = express();
const PORT = process.env.PORT || 3000;

// Security & Performance Middleware
app.use(helmet());
app.use(cors());
app.use(compression());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Logging
if (process.env.NODE_ENV === 'development') {
    app.use(morgan('dev'));
}

// Rate Limiting
app.use('/api/', apiLimiter);

// Health Check
app.get('/health', (req, res) => {
    res.json({ 
        status: 'OK', 
        timestamp: new Date().toISOString(),
        uptime: process.uptime()
    });
});

// Routes
app.use(authRouter);
app.use(adminRouter);
app.use("/", homeRoutes);
app.use(productRouter);
app.use(userRouter);
app.use(reviewRouter);
app.use(wishlistRouter);

// Error Handler (must be last)
app.use(errorHandler);

// 404 Handler
app.use((req, res) => {
    res.status(404).json({ msg: 'Route not found' });
});

// Connect to Database and Start Server
connectDB().then(() => {
    app.listen(PORT, '0.0.0.0', () => {
        console.log(`
╔════════════════════════════════════════╗
║   🚀 E-Commerce Server Running         ║
║   📡 Port: ${PORT}                     ║
║   🌍 Environment: ${process.env.NODE_ENV || 'development'}      ║
║   ✅ Database: Connected               ║
╚════════════════════════════════════════╝
        `);
    });
});

// Graceful Shutdown
process.on('SIGTERM', () => {
    console.log('SIGTERM received, shutting down gracefully');
    process.exit(0);
});

module.exports = app;