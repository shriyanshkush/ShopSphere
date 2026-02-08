const { Product } = require("../models/product");
const User = require("../models/user");
const { SORT_OPTIONS } = require("../src/config/constants");
const Review = require("../models/review");

class ProductController {
    async getCategories(req, res) {
        try {
            const categories = await Product.distinct('category');
            res.json({ categories: categories.filter(Boolean) });
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }

    async getProductsByCategory(req, res) {
        try {
            const { category } = req.params;
            const { page, limit, skip } = req.pagination;
            const query = { category };

            const products = await Product.find(query)
                .sort({ createdAt: -1 })
                .skip(skip)
                .limit(limit);

            const total = await Product.countDocuments(query);

            res.json({
                category,
                products,
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

    async getProducts(req, res) {
        try {
            const { category, minPrice, maxPrice, minRating, sort } = req.query;
            const { page, limit, skip } = req.pagination;

            let query = {};
            
            if (category) query.category = category;
            if (minPrice || maxPrice) {
                query.price = {};
                if (minPrice) query.price.$gte = parseFloat(minPrice);
                if (maxPrice) query.price.$lte = parseFloat(maxPrice);
            }
            if (minRating) {
                query.averageRating = { $gte: parseFloat(minRating) };
            }

            let sortOption = {};
            switch (sort) {
                case SORT_OPTIONS.PRICE_LOW_HIGH:
                    sortOption = { price: 1 };
                    break;
                case SORT_OPTIONS.PRICE_HIGH_LOW:
                    sortOption = { price: -1 };
                    break;
                case SORT_OPTIONS.RATING_HIGH_LOW:
                    sortOption = { averageRating: -1, totalReviews: -1 };
                    break;
                case SORT_OPTIONS.NEWEST_FIRST:
                    sortOption = { createdAt: -1 };
                    break;
                case SORT_OPTIONS.POPULARITY:
                    sortOption = { soldCount: -1, viewCount: -1 };
                    break;
                default:
                    sortOption = { createdAt: -1 };
            }

            const products = await Product.find(query)
                .sort(sortOption)
                .skip(skip)
                .limit(limit);

            const total = await Product.countDocuments(query);

            res.json({
                products,
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

    async searchProducts(req, res) {
        try {
            const { name } = req.params;
            const { page, limit, skip } = req.pagination;
            const { sort, minPrice, maxPrice, category } = req.query;

            let query = {
                $or: [
                    { name: { $regex: name, $options: 'i' } },
                    { description: { $regex: name, $options: 'i' } }
                ]
            };

            if (category) query.category = category;
            if (minPrice || maxPrice) {
                query.price = {};
                if (minPrice) query.price.$gte = parseFloat(minPrice);
                if (maxPrice) query.price.$lte = parseFloat(maxPrice);
            }

            let sortOption = { averageRating: -1 };
            if (sort === 'price_asc') sortOption = { price: 1 };
            if (sort === 'price_desc') sortOption = { price: -1 };

            const products = await Product.find(query)
                .sort(sortOption)
                .skip(skip)
                .limit(limit);

            const total = await Product.countDocuments(query);

            res.json({
                products,
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

    async getSearchSuggestions(req, res) {
        try {
            const { query } = req.query;

            if (!query || query.length < 2) {
                return res.json({ suggestions: [] });
            }

            const suggestions = await Product.find({
                name: { $regex: query, $options: 'i' }
            })
            .select('name category')
            .limit(10);

            res.json({
                suggestions: suggestions.map(p => ({
                    name: p.name,
                    category: p.category
                }))
            });
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }

    async getDealOfDay(req, res) {
        try {
            const products = await Product.find({})
                .sort({ averageRating: -1, totalReviews: -1 })
                .limit(1);

            res.json(products[0] || null);
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }

    async trackProductView(req, res) {
        try {
            const { id } = req.params;
            
            const product = await Product.findByIdAndUpdate(
                id,
                { $inc: { viewCount: 1 } },
                { new: true }
            );

            if (!product) {
                return res.status(404).json({ msg: "Product not found" });
            }

            const user = await User.findById(req.user);
            
            user.recentlyViewed = user.recentlyViewed.filter(
                pid => pid.toString() !== id
            );
            user.recentlyViewed.unshift(id);
            
            const maxRecent = parseInt(process.env.MAX_RECENTLY_VIEWED) || 10;
            if (user.recentlyViewed.length > maxRecent) {
                user.recentlyViewed = user.recentlyViewed.slice(0, maxRecent);
            }
            
            await user.save();

            res.json(product);
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }

    async getRecentlyViewed(req, res) {
        try {
            const user = await User.findById(req.user).populate('recentlyViewed');
            res.json({ products: user.recentlyViewed || [] });
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }

async getProductDetailWithReviews(req, res) {
  try {
    const { id } = req.params;

    const product = await Product.findById(id);
    if (!product) {
      return res.status(404).json({ msg: "Product not found" });
    }

    const reviews = await Review.find({ productId: id })
      .sort({ createdAt: -1 })
      .limit(10);

    res.json({
      product,
      reviews,
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
}

}

module.exports = new ProductController();