async function createPaymentOrder(_payload) {
  throw new Error("Razorpay integration not implemented yet");
}

async function verifyWebhook(_payload, _signature) {
  throw new Error("Razorpay webhook verification not implemented yet");
}

module.exports = { createPaymentOrder, verifyWebhook };
