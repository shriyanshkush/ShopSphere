const jwt = require("jsonwebtoken");

const auth = async (req, res, next) => {
    try {
        const token = req.header('x-auth-token');
        
        if (!token) {
            return res.status(401).json({ msg: "No authentication token, access denied!" });
        }
        
        const decodedToken = jwt.verify(token, process.env.JWT_ACCESS_SECRET);
        if (!decodedToken) {
            return res.status(401).json({ msg: "Token verification failed, authentication denied!" });
        }

        req.user = decodedToken.id;
        req.token = token;
        
        next();
    } catch (e) {
        if (e.name === 'TokenExpiredError') {
            return res.status(401).json({ msg: "Token expired, please refresh your token", expired: true });
        }
        res.status(401).json({ error: e.message });
    }
};

module.exports = auth;