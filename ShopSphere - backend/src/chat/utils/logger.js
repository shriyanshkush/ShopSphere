const logger = {
  info: (...args) => console.log('[chat]', ...args),
  error: (...args) => console.error('[chat]', ...args),
};

module.exports = logger;
