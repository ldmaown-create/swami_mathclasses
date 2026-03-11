# Swami Math Classes

# Unified API Contract Specification v2.0

Status: DEVELOPMENT READY

Aligned With: - Architecture v2.0 - Backend Master Context v2.0 - SRS
v1.0 - PRD v1.0

This document is the SINGLE SOURCE OF TRUTH for all frontend ↔ backend
communication.

No deviation allowed in: - Endpoint naming - Request structure -
Response structure - Error format - Authentication rules - State machine
transitions

------------------------------------------------------------------------

## BASE URL

Production: https://asia-south1-swamimathclasses.cloudfunctions.net/api

All endpoints begin with: /api/\*

------------------------------------------------------------------------

## GLOBAL RULES

All protected routes require headers:

Authorization: Bearer `<JWT_TOKEN>`{=html}\
Content-Type: application/json

JWT Payload: { userId: string, deviceId: string, role: "student" \|
"admin", iat: timestamp, exp: timestamp }

JWT Expiry: 7 days

Invalid or expired JWT → HTTP 401

------------------------------------------------------------------------

## STANDARD SUCCESS RESPONSE

{ "success": true, "data": { } }

------------------------------------------------------------------------

## STANDARD ERROR RESPONSE (MANDATORY)

{ "success": false, "error": { "code": "ERROR_CODE", "message": "Human
readable message" } }

Never return raw strings.

------------------------------------------------------------------------

## RATE LIMITS

-   send-otp → 3 per 5 minutes
-   login attempts → 5 per 10 minutes
-   video stream → 10 per minute
-   progress update → 1 per 10 seconds

------------------------------------------------------------------------

# AUTH SERVICE

## POST /api/auth/send-otp

Request: { "mobile": "9876543210", "deviceFingerprint":
"hashed_device_string" }

Response: { "success": true, "data": { "verificationId":
"firebase_verification_id" } }

------------------------------------------------------------------------

## POST /api/auth/verify-otp

Request: { "mobile": "9876543210", "otp": "123456", "deviceFingerprint":
"hashed_device_string" }

Response: { "success": true, "data": { "jwt": "token", "user": {
"userId": "abc123", "name": "Rahul", "isActive": true, "profileDone":
false } } }

Errors: - 401 INVALID_OTP - 403 ACCOUNT_PAUSED - 423 DEVICE_MISMATCH

------------------------------------------------------------------------

## POST /api/auth/refresh

Response: { "success": true, "data": { "jwt": "new_token" } }

------------------------------------------------------------------------

# VIDEO SERVICE

## POST /api/video/stream

Request: { "videoId": "vid_001" }

Success Response: { "success": true, "data": { "streamUrl":
"signed_hls_url", "expiresIn": 300 } }

Possible Errors: - 402 PAYMENT_REQUIRED - 403 BATCH_EXPIRED - 403
ACCOUNT_PAUSED - 423 VIDEO_LOCKED - 401 UNAUTHORIZED

------------------------------------------------------------------------

## POST /api/video/progress

Request: { "videoId": "vid_001", "watchedSeconds": 540 }

Response: { "success": true, "data": {} }

Rule: Unlock next video when watchedPercent \>= 90

------------------------------------------------------------------------

## GET /api/video/list?courseId=ssc_10_math

Response: { "success": true, "data": { "videos": \[ { "videoId":
"vid_001", "title": "Lecture 1", "duration": 1800, "orderNumber": 1,
"isLocked": false, "watchedPercent": 100 } \] } }

------------------------------------------------------------------------

# PAYMENT SERVICE

## POST /api/payment/create-order

Request: { "courseId": "ssc_10_math", "couponCode": "NEW100" }

Response: { "success": true, "data": { "orderId": "order_xxx", "amount":
1249900, "currency": "INR" } }

------------------------------------------------------------------------

## POST /api/payment/webhook

Header Required: X-Razorpay-Signature

States: - CREATED - INITIATED - SUCCESS - FAILED - REFUNDED - EXPIRED

Invalid Signature → HTTP 400

Idempotency: razorpayOrderId is primary key.\
Duplicate SUCCESS webhook ignored.

------------------------------------------------------------------------

# SUBSCRIPTION SERVICE

## GET /api/subscription/my

Response: { "success": true, "data": { "subscriptions": \[ { "courseId":
"ssc_10_math", "status": "active", "batchEndDate": "2026-03-15" } \] } }

------------------------------------------------------------------------

# ADMIN SERVICE (role = admin)

Session timeout: 2 hours inactivity

Available Endpoints: - POST /api/admin/course/create - POST
/api/admin/course/update - POST /api/admin/video/upload - POST
/api/admin/subscription/assign - POST
/api/admin/subscription/reset-device - POST /api/admin/user/toggle -
POST /api/admin/announcement/create - POST
/api/admin/notification/send - GET /api/admin/reports/payments - GET
/api/admin/reports/students

Standard Response: { "success": true, "data": {} }

------------------------------------------------------------------------

# DEVICE POLICY RULES

-   One active device per user
-   New device login revokes previous session atomically
-   All deviceSession writes wrapped in Firestore transaction

------------------------------------------------------------------------

# SECURITY ENFORCEMENT

-   All Firestore writes backend-only
-   All signed URLs expire in 5 minutes
-   All sensitive actions logged to auditLogs
-   Webhook signature verified before processing
-   Payment + device logic wrapped in transaction

------------------------------------------------------------------------

# FINAL RULE

If any conflict exists between frontend and backend: This document wins.

No deployment without aligning with this contract.

END OF DOCUMENT
