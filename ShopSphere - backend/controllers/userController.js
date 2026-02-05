const User = require("../models/user");
const { Product } = require("../models/product");
const Order = require("../models/order");

class UserController {
    async addToCart(req, res) {
        try {
            const { id } = req.body;
            
            const product = await Product.findById(id);
            if (!product) {
                return res.status(404).json({ msg: "Product not found" });
            }

            let user = await User.findById(req.user);
            
            const existingItem = user.cart.find(
                item => item.product._id.toString() === product._id.toString()
            );

            if (existingItem) {
                existingItem.quantity += 1;
            } else {
                user.cart.push({ product, quantity: 1 });
            }

            user = await user.save();
            res.json(user);
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }

    async removeFromCart(req, res) {
        try {
            const { id } = req.params;
            
            let user = await User.findById(req.user);
            
            const itemIndex = user.cart.findIndex(
                item => item.product._id.toString() === id
            );

            if (itemIndex !== -1) {
                if (user.cart[itemIndex].quantity > 1) {
                    user.cart[itemIndex].quantity -= 1;
                } else {
                    user.cart.splice(itemIndex, 1);
                }
            }

            user = await user.save();
            res.json(user);
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }

    async saveAddress(req, res) {
        try {
            const { address } = req.body;
            
            let user = await User.findById(req.user);
            user.address = address;
            user = await user.save();
            
            res.json(user);
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }

    async placeOrder(req, res) {
        try {
            const { cart, totalPrice, address } = req.body;
            let products = [];

            for (let item of cart) {
                let product = await Product.findById(item.product._id);
                
                if (!product) {
                    return res.status(404).json({ msg: `Product ${item.product.name} not found` });
                }

                if (product.quantity < item.quantity) {
                    return res.status(400).json({ msg: `${product.name} - Only ${product.quantity} items in stock` });
                }

                product.quantity -= item.quantity;
                product.soldCount += item.quantity;
                await product.save();

                products.push({ product, quantity: item.quantity });
            }

            let user = await User.findById(req.user);
            user.cart = [];
            await user.save();

            let order = new Order({
                products,
                totalPrice,
                address,
                userId: req.user,
                orderedAt: new Date().getTime(),
                statusHistory: [{
                    status: 0,
                    statusName: 'Pending',
                    timestamp: new Date()
                }]
            });

            order = await order.save();
            res.status(201).json(order);
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }

    async getMyOrders(req, res) {
        try {
            const { page, limit, skip } = req.pagination;

            const orders = await Order.find({ userId: req.user })
                .sort({ orderedAt: -1 })
                .skip(skip)
                .limit(limit);

            const total = await Order.countDocuments({ userId: req.user });

            res.json({
                orders,
                pagination: {
                    page,
                    limit,
                    total,
                    pages: Math.ceil(total / limit)
                }
            });
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }

    async getOrderDetails(req, res) {
        try {
            const { orderId } = req.params;

            const order = await Order.findOne({
                _id: orderId,
                userId: req.user
            });

            if (!order) {
                return res.status(404).json({ msg: "Order not found" });
            }

            res.json(order);
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }
}

module.exports = new UserController();