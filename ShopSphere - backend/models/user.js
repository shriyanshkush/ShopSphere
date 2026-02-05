const mongoose = require("mongoose");
const { productSchema } = require("./product");

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