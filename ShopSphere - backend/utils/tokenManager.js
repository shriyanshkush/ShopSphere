const jwt = require('jsonwebtoken');
const RefreshToken = require('../models/refreshToken');

class TokenManager {
    generateAccessToken(userId) {
        return jwt.sign(
            { id: userId },
            process.env.JWT_ACCESS_SECRET,
            { expiresIn: process.env.JWT_ACCESS_EXPIRY || '15m' }
        );
    }

    generateRefreshToken(userId) {
        return jwt.sign(
            { id: userId },
            process.env.JWT_REFRESH_SECRET,
            { expiresIn: process.env.JWT_REFRESH_EXPIRY || '7d' }
        );
    }

    async saveRefreshToken(userId, token) {
        const expiresAt = new Date();
        expiresAt.setDate(expiresAt.getDate() + 7); // 7 days

        await RefreshToken.create({
            userId,
            token,
            expiresAt
        });
    }

    async verifyRefreshToken(token) {
        try {
            const decoded = jwt.verify(token, process.env.JWT_REFRESH_SECRET);
            const tokenDoc = await RefreshToken.findOne({ token, userId: decoded.id });
            
            if (!tokenDoc) {
                throw new Error('Invalid refresh token');
            }

            return decoded;
        } catch (error) {
            throw new Error('Invalid or expired refresh token');
        }
    }

    async deleteRefreshToken(token) {
        await RefreshToken.deleteOne({ token });
    }

    async deleteAllUserTokens(userId) {
        await RefreshToken.deleteMany({ userId });
    }
}

module.exports = new TokenManager();