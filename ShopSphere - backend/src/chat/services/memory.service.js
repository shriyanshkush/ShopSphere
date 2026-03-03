const crypto = require('crypto');
const Thread = require('../models/thread.model');

async function getOrCreateThread(userId, threadId) {
  const resolvedThreadId = threadId || crypto.randomUUID();
  let thread = await Thread.findOne({ threadId: resolvedThreadId, userId });

  if (!thread) {
    thread = await Thread.create({ threadId: resolvedThreadId, userId, messages: [] });
  }

  return thread;
}

async function appendMessage({ userId, threadId, role, content }) {
  const thread = await getOrCreateThread(userId, threadId);
  thread.messages.push({ role, content, timestamp: new Date() });
  await thread.save();
  return thread;
}

async function getHistory(userId, threadId) {
  const thread = await Thread.findOne({ userId, threadId }).lean();
  return thread?.messages || [];
}

async function getThreadById(threadId) {
  return Thread.findOne({ threadId }).lean();
}

module.exports = { getOrCreateThread, appendMessage, getHistory, getThreadById };
