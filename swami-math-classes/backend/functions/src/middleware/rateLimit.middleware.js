function rateLimitMiddleware(_req, _res, next) {
  // Placeholder. Replace with production-grade limiter for Cloud Functions.
  return next();
}

module.exports = { rateLimitMiddleware };
