const Review = require("../models/review");
const { Product } = require("../models/product");
const User = require("../models/user");

async function updateProductRating(productId) {
    const reviews = await Review.find({ productId });

    if (reviews.length === 0) {
        await Product.findByIdAndUpdate(productId, {
            averageRating: 0,
            totalReviews: 0,
        });
        return;
    }

    const totalRating = reviews.reduce((sum, r) => sum + r.rating, 0);
    const averageRating = totalRating / reviews.length;

    await Product.findByIdAndUpdate(productId, {
        averageRating: Number(averageRating.toFixed(2)),
        totalReviews: reviews.length,
    });
}

class ReviewController {
    async addReview(req, res) {
        try {
            const { productId, rating, comment } = req.body;

            const user = await User.findById(req.user);
            if (!user) {
                return res.status(404).json({ msg: "User not found" });
            }

            const product = await Product.findById(productId);
            if (!product) {
                return res.status(404).json({ msg: "Product not found" });
            }

            let review = await Review.findOne({
                userId: req.user,
                productId,
            });

            if (review) {
                review.rating = rating;
                review.comment = comment;
                await review.save();
            } else {
                review = new Review({
                    userId: req.user,
                    productId,
                    rating,
                    comment,
                    userName: user.name,
                });
                await review.save();
            }

            // ✅ NO `this`, NO `static`, NO class reference
            await updateProductRating(productId);

            res.json(review);
        } catch (e) {
            console.error("❌ addReview error:", e);
            res.status(500).json({ error: e.message });
        }
    }

    async deleteReview(req, res) {
        try {
            const { reviewId } = req.params;

            const review = await Review.findById(reviewId);
            if (!review) {
                return res.status(404).json({ msg: "Review not found" });
            }

            if (review.userId.toString() !== req.user) {
                return res.status(403).json({ msg: "Not authorized" });
            }

            await Review.findByIdAndDelete(reviewId);
            await updateProductRating(review.productId);

            res.json({ msg: "Review deleted successfully" });
        } catch (e) {
            console.error("❌ deleteReview error:", e);
            res.status(500).json({ error: e.message });
        }
    }

    async getProductReviews(req, res) {
        try {
            const { productId } = req.params;
            const { page, limit, skip } = req.pagination;

            const reviews = await Review.find({ productId })
                .sort({ createdAt: -1 })
                .skip(skip)
                .limit(limit);

            const total = await Review.countDocuments({ productId });

            res.json({
                reviews,
                pagination: {
                    page,
                    limit,
                    total,
                    pages: Math.ceil(total / limit),
                },
            });
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }
}

module.exports = new ReviewController();
