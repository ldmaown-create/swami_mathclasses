const jwt = require("jsonwebtoken");
const env = require("../config/env.config");

function verifyToken(token) {
  return jwt.verify(token, env.jwtSecret);
}

module.exports = { verifyToken };
