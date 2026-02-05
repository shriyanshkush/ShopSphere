const { Product } = require("../models/product");
const Order = require("../models/order");
const User = require("../models/user");

/* =========================
   HELPER FUNCTIONS
========================= */

async function fetchCategoryEarnings(category) {
    let earnings = 0;

    const orders = await Order.find({
        'products.product.category': category
    });

    for (const order of orders) {
        for (const item of order.products) {
            if (item.product?.category === category) {
                earnings += item.quantity * item.product.price;
            }
        }
    }

    return earnings;
}

async function getRevenueByMonth() {
    const sixMonthsAgo = new Date();
    sixMonthsAgo.setMonth(sixMonthsAgo.getMonth() - 6);

    const orders = await Order.find({
        orderedAt: { $gte: sixMonthsAgo.getTime() }
    });

    const monthlyRevenue = {};

    for (const order of orders) {
        const date = new Date(order.orderedAt);
        const key = `${date.getFullYear()}-${String(
            date.getMonth() + 1
        ).padStart(2, "0")}`;

        monthlyRevenue[key] ??= 0;

        for (const item of order.products) {
            monthlyRevenue[key] += item.quantity * item.product.price;
        }
    }

    return Object.entries(monthlyRevenue).map(([month, revenue]) => ({
        month,
        revenue
    }));
}

/* =========================
   CONTROLLER
========================= */

class AdminController {

    async addProduct(req, res) {
        try {
            const { name, description, images, quantity, price, category } = req.body;

            let product = new Product({
                name,
                description,
                images,
                quantity,
                price,
                category,
            });

            product = await product.save();
            res.status(201).json(product);
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }

    async getProducts(req, res) {
        try {
            const { page, limit, skip } = req.pagination;
            const { category, sort } = req.query;

            const query = {};
            if (category) query.category = category;

            let sortOption = { createdAt: -1 };
            if (sort === "stock_low") sortOption = { quantity: 1 };
            if (sort === "price_high") sortOption = { price: -1 };

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

    async updateProduct(req, res) {
    try {
        const { id } = req.params;
        const { quantity } = req.body;

        // inventory-safe validation
        if (quantity == null || quantity < 0) {
            return res.status(400).json({
                msg: "Quantity must be a non-negative number"
            });
        }

        const product = await Product.findById(id);

        if (!product) {
            return res.status(404).json({ msg: "Product not found" });
        }

        // update ONLY quantity
        product.quantity = quantity;
        await product.save();

        // recompute stock
        const stockLevel = Math.min(
            Math.round((product.quantity / 200) * 100),
            100
        );

        let stockStatus = "Good";
        if (stockLevel < 20) stockStatus = "Low";
        else if (stockLevel < 50) stockStatus = "Medium";

        res.json({
            id: product._id,
            name: product.name,
            sku: product.sku,
            category: product.category,
            image: product.images?.[0],
            quantity: product.quantity,
            stockLevel,
            stockStatus
        });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
}

    async deleteProduct(req, res) {
        try {
            const { id } = req.params;

            const product = await Product.findByIdAndDelete(id);

            if (!product) {
                return res.status(404).json({ msg: "Product not found" });
            }

            res.json({ msg: "Product deleted successfully", product });
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }

    async getOrders(req, res) {
        try {
            const { page, limit, skip } = req.pagination;
            const { status } = req.query;

            const query = {};
            if (status !== undefined) query.status = Number(status);

            const orders = await Order.find(query)
                .sort({ orderedAt: -1 })
                .skip(skip)
                .limit(limit);

            const total = await Order.countDocuments(query);

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

    async changeOrderStatus(req, res) {
        try {
            const { id, status } = req.body;

            const statusNames = {
                0: "Pending",
                1: "Confirmed",
                2: "Packed",
                3: "Shipped",
                4: "Delivered",
                5: "Cancelled"
            };

            const order = await Order.findById(id);

            if (!order) {
                return res.status(404).json({ msg: "Order not found" });
            }

            order.status = status;
            order.statusHistory.push({
                status,
                statusName: statusNames[status],
                timestamp: new Date()
            });

            await order.save();
            res.json(order);
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }

    async getAnalytics(req, res) {
        try {
            const orders = await Order.find({});
            let totalEarnings = 0;

            for (const order of orders) {
                for (const item of order.products) {
                    totalEarnings += item.quantity * item.product.price;
                }
            }

            const [
                mobileEarnings,
                essentialEarnings,
                applianceEarnings,
                booksEarnings,
                fashionEarnings,
                totalProducts,
                totalUsers,
                pendingOrders,
                topProducts,
                lowStockProducts,
                revenueByMonth
            ] = await Promise.all([
                fetchCategoryEarnings("Mobiles"),
                fetchCategoryEarnings("Essentials"),
                fetchCategoryEarnings("Appliances"),
                fetchCategoryEarnings("Books"),
                fetchCategoryEarnings("Fashion"),
                Product.countDocuments(),
                User.countDocuments(),
                Order.countDocuments({ status: { $lt: 4 } }),
                Product.find({})
                    .sort({ soldCount: -1 })
                    .limit(5)
                    .select("name soldCount price averageRating"),
                Product.find({ quantity: { $lt: 10 } })
                    .sort({ quantity: 1 })
                    .limit(10)
                    .select("name quantity price"),
                getRevenueByMonth()
            ]);

            res.json({
                overview: {
                    totalEarnings,
                    totalProducts,
                    totalUsers,
                    totalOrders: orders.length,
                    pendingOrders
                },
                categoryEarnings: {
                    Mobiles: mobileEarnings,
                    Essentials: essentialEarnings,
                    Appliances: applianceEarnings,
                    Books: booksEarnings,
                    Fashion: fashionEarnings
                },
                topProducts,
                lowStockProducts,
                revenueByMonth
            });
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }

    async getInventoryReport(req, res) {
        try {
            const lowStock = await Product.countDocuments({ quantity: { $lt: 10 } });
            const outOfStock = await Product.countDocuments({ quantity: 0 });
            const inStock = await Product.countDocuments({ quantity: { $gte: 10 } });

            const categoryInventory = await Product.aggregate([
                {
                    $group: {
                        _id: "$category",
                        totalProducts: { $sum: 1 },
                        totalQuantity: { $sum: "$quantity" },
                        avgPrice: { $avg: "$price" }
                    }
                }
            ]);

            res.json({
                summary: { lowStock, outOfStock, inStock },
                categoryInventory
            });
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }

    async getInventory(req, res) {
  try {
    const { status, category, search } = req.query;

    const query = {};

    // category filter
    if (category && category !== "all") {
      query.category = category;
    }

    // search by name or SKU
    if (search) {
      query.$or = [
        { name: { $regex: search, $options: "i" } },
        { sku: { $regex: search, $options: "i" } }
      ];
    }

    // stock status filter
    if (status === "low") query.quantity = { $lt: 10 };
    if (status === "medium") query.quantity = { $gte: 10, $lt: 50 };
    if (status === "good") query.quantity = { $gte: 50 };

    const products = await Product.find(query)
      .select("name sku category images quantity");

    const inventory = products.map(p => {
      const stockLevel = Math.min(
        Math.round((p.quantity / 200) * 100),
        100
      );

      let stockStatus = "Good";
      if (stockLevel < 20) stockStatus = "Low";
      else if (stockLevel < 50) stockStatus = "Medium";

      return {
        id: p._id,
        name: p.name,
        sku: p.sku,
        category: p.category,
        image: p.images?.[0],
        quantity: p.quantity,
        stockLevel,
        stockStatus
      };
    });

    res.json(inventory);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
}


}

module.exports = new AdminController();
