const paymentService = require("../services/payment.service");
const { ok, created, fail } = require("../utils/responseFormatter");

async function createOrder(req, res) {
  try {
    const data = await paymentService.createPaymentOrder(req.body);
    return created(res, data, "payment_order_created");
  } catch (err) {
    return fail(res, 501, err.message);
  }
}

async function webhook(req, res) {
  try {
    const data = await paymentService.verifyWebhook(req.body, req.headers["x-razorpay-signature"]);
    return ok(res, data, "webhook_verified");
  } catch (err) {
    return fail(res, 501, err.message);
  }
}

module.exports = { createOrder, webhook };
