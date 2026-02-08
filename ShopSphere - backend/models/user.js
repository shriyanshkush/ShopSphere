const mongoose = require("mongoose");
const { productSchema } = require("./product");

const addressSchema = mongoose.Schema(
  {
    label: { type: String, default: 'Home', trim: true },
    fullName: { type: String, required: true, trim: true },
    line1: { type: String, required: true, trim: true },
    city: { type: String, required: true, trim: true },
    state: { type: String, required: true, trim: true },
    zipCode: { type: String, required: true, trim: true },
    phone: { type: String, required: true, trim: true },
    isDefault: { type: Boolean, default: false }
  },
  { _id: true }
);

const userSchema = mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true,
    },
    email: {
        type: String,
        required: true,
        unique: true,
        trim: true,
        lowercase: true,
        validate: {
            validator: (value) => {
                const re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@(([^<>()[\]\\.,;:\s@"]+\.)+[^<>()[\]\\.,;:\s@"]{2,})$/i;
                return re.test(value);
            },
            message: 'Please enter a valid email'
        }
    },
    password: {
        required: true,
        type: String,
        minlength: 8,
    },
    address: {
        type: String,
        default: '',
    },
    addresses: {
        type: [addressSchema],
        default: [],
    },
    selectedAddressId: {
      type: mongoose.Schema.Types.ObjectId,
      default: null,
    },
    type: {
        type: String,
        default: 'user',
        enum: ['user', 'seller', 'admin']
    },
    cart: [
        {
            product: productSchema,
            quantity: {
                type: Number,
                required: true,
                min: 1
            }
        }
    ],
    recentlyViewed: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Product'
    }]
}, {
    timestamps: true,
    versionKey: false
});

// Index for faster queries
userSchema.index({ email: 1 });
userSchema.index({ type: 1 });

const User = mongoose.model("User", userSchema);

module.exports = User;
