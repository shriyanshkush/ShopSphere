const express = require('express');
const { postChat, getChatThread } = require('../controllers/chat.controller');

const router = express.Router();

router.post('/chat', postChat);
router.get('/chat/:threadId', getChatThread);

module.exports = router;
