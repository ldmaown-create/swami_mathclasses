const authService = require("../services/auth.service");
const { ok, fail } = require("../utils/responseFormatter");

async function sendOtp(req, res) {
  try {
    const data = await authService.requestOtp(req.body);
    return ok(res, data, "otp_sent");
  } catch (err) {
    return fail(res, 501, err.message);
  }
}

async function verifyOtp(req, res) {
  try {
    const data = await authService.verifyOtp(req.body);
    return ok(res, data, "otp_verified");
  } catch (err) {
    return fail(res, 501, err.message);
  }
}

module.exports = { sendOtp, verifyOtp };
