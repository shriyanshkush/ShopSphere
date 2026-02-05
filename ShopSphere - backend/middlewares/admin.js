const jwt = require("jsonwebtoken");
const User = require("../models/user");

const admin = async (req, res, next) => {
    try {
        const token = req.header('x-auth-token');
        
        if (!token) {
            return res.status(401).json({ msg: "No authentication token, access denied!" });
        }
        
        const decodedToken = jwt.verify(token, process.env.JWT_ACCESS_SECRET);
        if (!decodedToken) {
            return res.status(401).json({ msg: "Token verification failed, authentication denied!" });
        }

        const user = await User.findById(decodedToken.id);

        if (!user || (user.type !== 'admin' && user.type !== 'seller')) {
            return res.status(403).json({ msg: "Access denied. Admin privileges required." });
        }

        req.user = decodedToken.id;
        req.userType = user.type;
        req.token = token;
        next();

    } catch (e) {
        if (e.name === 'TokenExpiredError') {
            return res.status(401).json({ msg: "Token expired", expired: true });
        }
        res.status(500).json({ error: e.message });
    }
};

module.exports = admin;