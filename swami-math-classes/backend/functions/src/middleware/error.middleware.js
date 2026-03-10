const { error: logError } = require("../utils/logger");

function errorMiddleware(err, _req, res, _next) {
  logError("unhandled_error", { message: err.message, stack: err.stack });
  return res.status(500).json({ success: false, message: "internal_server_error" });
}

module.exports = { errorMiddleware };
