const pagination = (req, res, next) => {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || parseInt(process.env.ITEMS_PER_PAGE) || 20;
    const skip = (page - 1) * limit;

    req.pagination = {
        page,
        limit,
        skip
    };

    next();
};

module.exports = pagination;