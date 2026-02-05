const User = require("../models/user");
const bcrypt = require("bcryptjs");
const tokenManager = require("../utils/tokenManager");

class AuthController {
    async signup(req, res) {
        try {
            const { name, email, password } = req.body;

            const existingUser = await User.findOne({ email });
            if (existingUser) {
                return res.status(400).json({ msg: "User with this email already exists!" });
            }

            const hashPassword = await bcrypt.hash(password, 10);

            let user = new User({
                name,
                email,
                password: hashPassword,
            });

            user = await user.save();

            const accessToken = tokenManager.generateAccessToken(user._id);
            const refreshToken = tokenManager.generateRefreshToken(user._id);

            await tokenManager.saveRefreshToken(user._id, refreshToken);

            res.status(201).json({
                accessToken,
                refreshToken,
                user: {
                    id: user._id,
                    name: user.name,
                    email: user.email,
                    type: user.type
                }
            });
        } catch (error) {
            res.status(500).json({ msg: "Server error", error: error.message });
        }
    }

    async signin(req, res) {
        try {
            const { email, password } = req.body;
            
            const user = await User.findOne({ email });
            if (!user) {
                return res.status(400).json({ msg: "Invalid credentials" });
            }

            const isMatch = await bcrypt.compare(password, user.password);
            if (!isMatch) {
                return res.status(400).json({ msg: "Invalid credentials" });
            }

            const accessToken = tokenManager.generateAccessToken(user._id);
            const refreshToken = tokenManager.generateRefreshToken(user._id);

            await tokenManager.saveRefreshToken(user._id, refreshToken);

            res.json({
                accessToken,
                refreshToken,
                user: {
                    id: user._id,
                    name: user.name,
                    email: user.email,
                    type: user.type,
                    address: user.address
                }
            });
        } catch (e) {
            res.status(500).json({ error: e.message });
        }
    }

    async refreshToken(req, res) {
        try {
            const { refreshToken } = req.body;

            if (!refreshToken) {
                return res.status(401).json({ msg: "Refresh token required" });
            }

            const decoded = await tokenManager.verifyRefreshToken(refreshToken);
            
            const newAccessToken = tokenManager.generateAccessToken(decoded.id);

            res.json({ accessToken: newAccessToken });
        } catch (error) {
            res.status(401).json({ msg: error.message });
        }
    }

    async logout(req, res) {
        try {
            const { refreshToken } = req.body;
            
            if (refreshToken) {
                await tokenManager.deleteRefreshToken(refreshToken);
            }

            res.json({ msg: "Logged out successfully" });
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }

    async getUserData(req, res) {
        try {
            const user = await User.findById(req.user).select('-password');
            res.json({ ...user._doc, token: req.token });
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }
}

module.exports = new AuthController();