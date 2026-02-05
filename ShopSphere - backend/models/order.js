const mongoose = require('mongoose');
const { productSchema } = require("./product");

const orderSchema = mongoose.Schema({
    products: [{
        product: productSchema,
        quantity: {
            type: Number,
            required: true,
            min: 1
        },
    }],
    totalPrice: {
        type: Number,
        required: true,
        min: 0
    },
    address: {
        type: String,
        required: true,
    },
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    orderedAt: {
        type: Number,
        required: true,
    },
    status: {
        type: Number,
        default: 0,
        min: 0,
        max: 5
    },
    statusHistory: [{
        status: {
            type: Number,
            required: true
        },
        statusName: {
            type: String,
            required: true
        },
        timestamp: {
            type: Date,
            default: Date.now
        }
    }]
}, { 
    timestamps: true 
});

// Indexes
orderSchema.index({ userId: 1, createdAt: -1 });
orderSchema.index({ status: 1 });
orderSchema.index({ orderedAt: -1 });

const Order = mongoose.model('Order', orderSchema);

module.exports = Order;