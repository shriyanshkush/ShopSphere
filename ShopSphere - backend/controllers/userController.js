const User = require("../models/user");
const { Product } = require("../models/product");
const Order = require("../models/order");

const ORDER_STATUS = {
  0: 'Pending',
  1: 'Confirmed',
  2: 'Packed',
  3: 'Shipped',
  4: 'Delivered',
  5: 'Cancelled'
};

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


    async getCart(req, res) {
      try {
        const user = await User.findById(req.user).select('cart');
        if (!user) {
          return res.status(404).json({ msg: 'User not found' });
        }

        const items = (user.cart || []).map((item) => ({
          product: item.product,
          quantity: item.quantity,
        }));

        const totalAmount = items.reduce((sum, item) => sum + ((item.product?.price || 0) * item.quantity), 0);
        res.json({ items, totalAmount });
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

    async getAddresses(req, res) {
      try {
        const user = await User.findById(req.user).select('addresses selectedAddressId address name');
        if (!user) {
          return res.status(404).json({ msg: 'User not found' });
        }

        let addresses = user.addresses || [];

        if (addresses.length === 0 && user.address) {
          // Backward compatibility with legacy single-string address
          addresses = [
            {
              _id: undefined,
              label: 'Home',
              fullName: user.name,
              line1: user.address,
              city: '',
              state: '',
              zipCode: '',
              phone: '',
              isDefault: true,
            }
          ];
        }

        res.json({
          addresses,
          selectedAddressId: user.selectedAddressId || addresses.find(a => a.isDefault)?._id || null,
        });
      } catch (e) {
        res.status(500).json({ error: e.message });
      }
    }

    async addAddress(req, res) {
      try {
        const { label, fullName, line1, city, state, zipCode, phone } = req.body;

        if (!fullName || !line1 || !city || !state || !zipCode || !phone) {
          return res.status(400).json({ msg: 'All address fields are required' });
        }

        const user = await User.findById(req.user);
        if (!user) return res.status(404).json({ msg: 'User not found' });

        if ((user.addresses || []).length === 0) {
          user.address = line1;
        }

        const nextAddress = {
          label: label || 'Home',
          fullName,
          line1,
          city,
          state,
          zipCode,
          phone,
          isDefault: (user.addresses || []).length === 0,
        };

        user.addresses.push(nextAddress);

        if (!user.selectedAddressId) {
          user.selectedAddressId = user.addresses[user.addresses.length - 1]._id;
        }

        await user.save();
        res.status(201).json({ addresses: user.addresses, selectedAddressId: user.selectedAddressId });
      } catch (e) {
        res.status(500).json({ error: e.message });
      }
    }

    async updateAddress(req, res) {
      try {
        const { addressId } = req.params;
        const payload = req.body;

        const user = await User.findById(req.user);
        if (!user) return res.status(404).json({ msg: 'User not found' });

        const addr = user.addresses.id(addressId);
        if (!addr) return res.status(404).json({ msg: 'Address not found' });

        const editable = ['label', 'fullName', 'line1', 'city', 'state', 'zipCode', 'phone'];
        editable.forEach((key) => {
          if (payload[key] !== undefined) {
            addr[key] = payload[key];
          }
        });

        await user.save();
        res.json({ addresses: user.addresses, selectedAddressId: user.selectedAddressId });
      } catch (e) {
        res.status(500).json({ error: e.message });
      }
    }

    async selectAddress(req, res) {
      try {
        const { addressId } = req.params;

        const user = await User.findById(req.user);
        if (!user) return res.status(404).json({ msg: 'User not found' });

        const addr = user.addresses.id(addressId);
        if (!addr) return res.status(404).json({ msg: 'Address not found' });

        user.addresses.forEach((item) => {
          item.isDefault = item._id.toString() === addressId;
        });

        user.selectedAddressId = addr._id;
        user.address = addr.line1;

        await user.save();
        res.json({ addresses: user.addresses, selectedAddressId: user.selectedAddressId });
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

    async getRecentOrders(req, res) {
      try {
        const orders = await Order.find({ userId: req.user }).sort({ orderedAt: -1 }).limit(3);

        const normalized = orders.map((order) => {
          const topItem = order.products?.[0];
          const product = topItem?.product || {};
          const statusName = ORDER_STATUS[order.status] || 'Pending';
          const isDelivered = order.status === 4;

          return {
            _id: order._id,
            productId: product._id || null,
            title: product.name || 'Order item',
            image: product.images?.[0] || '',
            status: isDelivered ? `Delivered ${new Date(order.orderedAt).toLocaleDateString()}` : `${statusName}`,
            canTrack: order.status > 0 && order.status < 4,
            canReview: isDelivered,
          };
        });

        res.json({ orders: normalized });
      } catch (e) {
        res.status(500).json({ error: e.message });
      }
    }
}

module.exports = new UserController();
