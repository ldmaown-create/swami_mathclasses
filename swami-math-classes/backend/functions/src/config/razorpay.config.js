const env = require("./env.config");

module.exports = {
  keyId: env.razorpayKeyId,
  keySecret: env.razorpayKeySecret,
  webhookSecret: env.razorpayWebhookSecret
};
