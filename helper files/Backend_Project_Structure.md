# Swami Math Classes

# Backend Project Structure Specification v1.0

Status: DEVELOPMENT ARCHITECTURE GUIDE

Purpose:
Define the exact folder structure and code architecture for the Firebase Cloud Functions backend.

This document ensures:

* clean modular code
* scalable backend
* easy debugging
* maintainable services
* alignment with Architecture v2

---

# 1. Backend Technology Stack

Backend Runtime:

Node.js (Firebase Cloud Functions)

Framework:

Express.js

Libraries:

* firebase-admin
* express
* jsonwebtoken
* axios
* cors
* dotenv

---

# 2. Backend Root Structure

```
backend/

functions/
│
├── src/
│
│   ├── config/
│   │   ├── firebase.js
│   │   ├── razorpay.js
│   │   ├── bunny.js
│   │   └── env.js
│
│   ├── routes/
│   │   ├── auth.routes.js
│   │   ├── video.routes.js
│   │   ├── payment.routes.js
│   │   ├── subscription.routes.js
│   │   ├── course.routes.js
│   │   └── admin.routes.js
│
│   ├── controllers/
│   │   ├── auth.controller.js
│   │   ├── video.controller.js
│   │   ├── payment.controller.js
│   │   ├── subscription.controller.js
│   │   ├── course.controller.js
│   │   └── admin.controller.js
│
│   ├── services/
│   │   ├── auth.service.js
│   │   ├── video.service.js
│   │   ├── payment.service.js
│   │   ├── subscription.service.js
│   │   ├── device.service.js
│   │   └── notification.service.js
│
│   ├── middleware/
│   │   ├── auth.middleware.js
│   │   ├── admin.middleware.js
│   │   ├── error.middleware.js
│   │   └── rateLimit.middleware.js
│
│   ├── policies/
│   │   └── videoAccessPolicy.js
│
│   ├── utils/
│   │   ├── jwt.js
│   │   ├── logger.js
│   │   ├── responseFormatter.js
│   │   └── validators.js
│
│   └── index.js
│
├── package.json
└── firebase.json
```

---

# 3. Folder Responsibilities

## config/

External service configuration.

Examples:

* Firebase admin initialization
* Razorpay keys
* Bunny.net API
* Environment variables

---

## routes/

Defines API endpoints.

Example:

```
router.post("/auth/send-otp", sendOtpController)
```

Routes do not contain logic.

They only map endpoint → controller.

---

## controllers/

Controllers receive request and call services.

Example:

```
sendOtpController(req, res)
```

Responsibilities:

* parse request
* call service
* return formatted response

Controllers contain minimal logic.

---

## services/

Core business logic layer.

Examples:

* create Razorpay order
* generate signed Bunny URL
* check subscription
* update progress

Services interact with:

* Firestore
* external APIs
* transactions

---

## middleware/

Reusable request filters.

Examples:

JWT validation

```
authMiddleware
```

Admin permission check

```
adminMiddleware
```

Rate limiting

```
rateLimitMiddleware
```

---

## policies/

System rule engines.

Example:

```
VideoAccessPolicy
```

Handles checks:

1 JWT valid
2 user active
3 subscription active
4 batch not expired
5 sequential unlock rule

---

## utils/

Utility helpers.

Examples:

JWT generation

```
generateToken()
```

Response formatting

```
successResponse()
errorResponse()
```

Logging

```
logEvent()
```

---

# 4. API Routing Layer

Main router entry:

```
/api/*
```

Routes map to services:

| Endpoint      | Service             |
| ------------- | ------------------- |
| /auth         | AuthService         |
| /video        | VideoService        |
| /payment      | PaymentService      |
| /subscription | SubscriptionService |
| /admin        | AdminService        |

---

# 5. Logging Policy

All sensitive actions must write to:

```
auditLogs collection
```

Events logged:

* login attempts
* device changes
* video stream requests
* payments
* admin actions

---

# 6. Error Handling

All errors must return standard format:

```
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable message"
  }
}
```

Never return raw strings.

---

# 7. Transaction Safety

Operations that must use Firestore transactions:

* payment activation
* device session replacement
* coupon usage
* sequential unlock updates

---

# 8. Code Ownership Model

Modules mapped to services:

| Service             | Responsibility    |
| ------------------- | ----------------- |
| AuthService         | login, OTP, JWT   |
| VideoService        | streaming access  |
| PaymentService      | Razorpay          |
| SubscriptionService | course enrollment |
| DeviceService       | device policy     |
| NotificationService | FCM               |

---

# FINAL RULE

Routes → Controllers → Services → Firestore

Never skip layers.

END OF DOCUMENT
