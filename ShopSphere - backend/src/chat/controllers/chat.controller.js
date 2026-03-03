const { runShoppingAgent } = require('../agents/shopping.agent');
const { appendMessage, getHistory, getOrCreateThread, getThreadById } = require('../services/memory.service');
const logger = require('../utils/logger');

function validate(body = {}) {
  if (!body.userId || !body.message) return 'userId and message are required';
  return null;
}

async function postChat(req, res) {
  try {
    const error = validate(req.body);
    if (error) return res.status(400).json({ message: error });

    const { userId, message, threadId } = req.body;
    const thread = await getOrCreateThread(userId, threadId);

    await appendMessage({ userId, threadId: thread.threadId, role: 'user', content: message });

    const history = await getHistory(userId, thread.threadId);
    const reply = await runShoppingAgent({
      history,
      userMessage: message,
      context: { userId, authToken: req.headers.authorization },
    });

    await appendMessage({ userId, threadId: thread.threadId, role: 'assistant', content: reply });

    return res.json({ reply, threadId: thread.threadId });
  } catch (err) {
    logger.error('Chat request failed', err.message);

    if (err.message?.includes('Missing AI API key')) {
      return res.status(503).json({ message: err.message });
    }

    return res.status(500).json({ message: 'Unable to process chat right now. Please retry.' });
  }
}

async function getChatThread(req, res) {
  try {
    const thread = await getThreadById(req.params.threadId);
    if (!thread) return res.status(404).json({ message: 'Thread not found' });
    return res.json(thread);
  } catch (err) {
    logger.error('getChatThread failed', err.message);
    return res.status(500).json({ message: 'Unable to fetch thread' });
  }
}

module.exports = { postChat, getChatThread };
