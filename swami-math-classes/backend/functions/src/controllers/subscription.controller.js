const subscriptionService = require("../services/subscription.service");
const { ok, fail } = require("../utils/responseFormatter");

async function getActive(req, res) {
  try {
    const data = await subscriptionService.getActiveSubscription(req.user.uid);
    return ok(res, data, "subscription_status");
  } catch (err) {
    return fail(res, 501, err.message);
  }
}

module.exports = { getActive };
