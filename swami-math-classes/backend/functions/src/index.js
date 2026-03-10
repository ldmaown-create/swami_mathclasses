const functions = require("firebase-functions");
const express = require("express");
const cors = require("cors");

const { initializeFirebase } = require("./config/firebase.config");
const { authMiddleware } = require("./middleware/auth.middleware");
const { adminMiddleware } = require("./middleware/admin.middleware");
const { rateLimitMiddleware } = require("./middleware/rateLimit.middleware");
const { errorMiddleware } = require("./middleware/error.middleware");

const authRoutes = require("./routes/auth.routes");
const videoRoutes = require("./routes/video.routes");
const paymentRoutes = require("./routes/payment.routes");
const subscriptionRoutes = require("./routes/subscription.routes");
const courseRoutes = require("./routes/course.routes");
const adminRoutes = require("./routes/admin.routes");

initializeFirebase();

const app = express();
app.use(cors({ origin: true }));
app.use(express.json());
app.use(rateLimitMiddleware);

app.get("/health", (_req, res) => res.status(200).json({ success: true, service: "swami-math-classes-api" }));

app.use("/api/auth", authRoutes);
app.use("/api/videos", authMiddleware, videoRoutes);
app.use("/api/payments", paymentRoutes);
app.use("/api/subscriptions", authMiddleware, subscriptionRoutes);
app.use("/api/courses", authMiddleware, courseRoutes);
app.use("/api/admin", authMiddleware, adminMiddleware, adminRoutes);

app.use(errorMiddleware);

exports.api = functions.https.onRequest(app);
