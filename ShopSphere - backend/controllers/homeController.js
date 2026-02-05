const { Product } = require("../models/product");

class HomeController {
  async getHome(req, res) {
    try {
      // 1️⃣ Categories (static or from DB)
      const categories = [
        { _id: "mobile", name: "Mobile" },
        { _id: "laptops", name: "Laptops" },
        { _id: "audio", name: "Audio" },
        { _id: "watches", name: "Watches" },
      ];

      // 2️⃣ Curated products (for grid)
      const products = await Product.find({})
        .sort({ averageRating: -1, soldCount: -1 })
        .limit(8)
        .select("name price images averageRating totalReviews createdAt soldCount");

      // 3️⃣ Add badge logic (UI NEEDS THIS)
      const curated = products.map(p => ({
        _id: p._id,
        name: p.name,
        price: p.price,
        rating: p.averageRating,
        reviews: p.totalReviews,
        images: p.images,
        badge:
          p.averageRating >= 4.8
            ? "TOP RATED"
            : p.createdAt > Date.now() - 7 * 24 * 60 * 60 * 1000
            ? "NEW ARRIVAL"
            : p.soldCount > 100
            ? "BEST VALUE"
            : "",
      }));

      res.json({
        categories,
        products: curated,
      });
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  }
}

module.exports = new HomeController();
