const express = require('express');
const { postChat, getChatThread } = require('../controllers/chatController');

const router = express.Router();

router.post('/chat', postChat);
router.get('/chat/:threadId', getChatThread);

module.exports = router;
