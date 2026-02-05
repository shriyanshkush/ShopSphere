module.exports = {
    USER_ROLES: {
        USER: 'user',
        SELLER: 'seller',
        ADMIN: 'admin'
    },
    ORDER_STATUS: {
        PENDING: 0,
        CONFIRMED: 1,
        PACKED: 2,
        SHIPPED: 3,
        DELIVERED: 4,
        CANCELLED: 5
    },
    CATEGORIES: [
        'Mobiles',
        'Essentials',
        'Appliances',
        'Books',
        'Fashion',
        'Electronics',
        'Home & Kitchen',
        'Sports'
    ],
    SORT_OPTIONS: {
        PRICE_LOW_HIGH: 'price_asc',
        PRICE_HIGH_LOW: 'price_desc',
        RATING_HIGH_LOW: 'rating_desc',
        NEWEST_FIRST: 'newest',
        POPULARITY: 'popular'
    }
};