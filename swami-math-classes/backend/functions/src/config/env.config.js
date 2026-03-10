require("dotenv").config();

function getEnv(name, fallback = "") {
  return process.env[name] ?? fallback;
}

module.exports = {
  environment: getEnv("ENVIRONMENT", "dev"),
  jwtSecret: getEnv("JWT_SECRET", "replace_me"),
  firebaseProjectId: getEnv("FIREBASE_PROJECT_ID", "swami-dev"),
  razorpayKeyId: getEnv("RAZORPAY_KEY_ID"),
  razorpayKeySecret: getEnv("RAZORPAY_SECRET"),
  razorpayWebhookSecret: getEnv("RAZORPAY_WEBHOOK_SECRET"),
  bunnyLibraryId: getEnv("BUNNY_LIBRARY_ID"),
  bunnyApiKey: getEnv("BUNNY_API_KEY"),
  bunnyPullZoneUrl: getEnv("BUNNY_PULL_ZONE_URL")
};
