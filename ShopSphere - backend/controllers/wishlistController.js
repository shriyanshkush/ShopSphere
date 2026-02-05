const Wishlist = require("../models/wishlist");
const { Product } = require("../models/product");

class WishlistController {
    async addToWishlist(req, res) {
        try {
            const { productId } = req.body;

            const product = await Product.findById(productId);
            if (!product) {
                return res.status(404).json({ msg: "Product not found" });
            }

            let wishlist = await Wishlist.findOne({ userId: req.user });

            if (!wishlist) {
                wishlist = new Wishlist({
                    userId: req.user,
                    products: [{ productId }]
                });
            } else {
                const exists = wishlist.products.some(
                    p => p.productId.toString() === productId
                );

                if (exists) {
                    return res.status(400).json({ msg: "Product already in wishlist" });
                }

                wishlist.products.push({ productId });
            }

            await wishlist.save();
            await wishlist.populate('products.productId');

            res.json(wishlist);
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }

    async removeFromWishlist(req, res) {
        try {
            const { productId } = req.params;

            const wishlist = await Wishlist.findOne({ userId: req.user });
            if (!wishlist) {
                return res.status(404).json({ msg: "Wishlist not found" });
            }

            wishlist.products = wishlist.products.filter(
                p => p.productId.toString() !== productId
            );

            await wishlist.save();
            await wishlist.populate('products.productId');

            res.json(wishlist);
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }

    async getWishlist(req, res) {
        try {
            let wishlist = await Wishlist.findOne({ userId: req.user })
                .populate('products.productId');

            if (!wishlist) {
                wishlist = { products: [] };
            }

            res.json(wishlist);
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }

    async moveToCart(req, res) {
        try {
            const { productId } = req.body;
            const User = require("../models/user");

            const wishlist = await Wishlist.findOne({ userId: req.user });
            if (!wishlist) {
                return res.status(404).json({ msg: "Wishlist not found" });
            }

            const product = await Product.findById(productId);
            if (!product) {
                return res.status(404).json({ msg: "Product not found" });
            }

            const user = await User.findById(req.user);
            
            const cartItem = user.cart.find(
                item => item.product._id.toString() === productId
            );

            if (cartItem) {
                cartItem.quantity += 1;
            } else {
                user.cart.push({ product, quantity: 1 });
            }

            wishlist.products = wishlist.products.filter(
                p => p.productId.toString() !== productId
            );

            await user.save();
            await wishlist.save();

            res.json({ msg: "Moved to cart successfully", user, wishlist });
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }
}

module.exports = new WishlistController();