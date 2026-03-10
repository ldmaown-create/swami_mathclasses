const { verifyToken } = require("../utils/jwt");

function authMiddleware(req, res, next) {
  const authHeader = req.headers.authorization || "";
  const token = authHeader.startsWith("Bearer ") ? authHeader.slice(7) : null;

  if (!token) {
    return res.status(401).json({ success: false, message: "missing_token" });
  }

  try {
    req.user = verifyToken(token);
    return next();
  } catch (err) {
    return res.status(401).json({ success: false, message: "invalid_token" });
  }
}

module.exports = { authMiddleware };
