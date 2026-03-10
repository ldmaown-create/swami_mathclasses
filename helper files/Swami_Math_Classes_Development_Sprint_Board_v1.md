
# Swami Math Classes
# Development Sprint Board v1.0

Status: EXECUTION ROADMAP
Purpose: Convert all finalized architecture, SRS, API contracts, and flow documents into a structured development plan.

This document assumes the following documents are finalized and locked:
- PRD
- SRS
- Architecture v2
- Database Design
- Unified API Contract
- Edge Case Matrix
- Firestore Security Rules
- Environment Strategy
- Screen Flow Blueprint

------------------------------------------------------------
PROJECT OVERVIEW
------------------------------------------------------------

Product:
Swami Math Classes Online Learning Platform

Components:
1. Student Mobile App (Flutter)
2. Admin Windows Application (Flutter)
3. Backend APIs (Firebase Cloud Functions)
4. Firestore Database
5. Bunny.net Video Streaming
6. Razorpay Payments
7. Firebase FCM Notifications

Development Philosophy:
Backend-first architecture.

Reason:
Client apps must never access Firestore directly. All data operations go through Cloud Functions.

------------------------------------------------------------
GLOBAL DEVELOPMENT RULES
------------------------------------------------------------

1. All database writes go through backend APIs.
2. No UI development before backend endpoints exist.
3. Every module must include:
   - API implementation
   - security validation
   - error handling
   - logging to auditLogs
4. Every sprint ends with integration testing.
5. No production deployment without staging validation.

------------------------------------------------------------
SPRINT STRUCTURE
------------------------------------------------------------

Total Estimated Sprints: 8
Sprint Length: 1 week (recommended)

Phase Order:
1. Infrastructure
2. Authentication
3. Core Data Services
4. Video Access Engine
5. Payment System
6. Student App
7. Admin Panel
8. QA & Hardening

------------------------------------------------------------
SPRINT 1 — INFRASTRUCTURE SETUP
------------------------------------------------------------

Goal:
Establish development environment and core project structure.

Tasks:

1. Create Git Repository
   - backend folder
   - student_app folder
   - admin_panel folder

2. Setup Firebase Projects
   - swami-dev
   - swami-staging
   - swami-prod

3. Enable Firebase Services
   - Firestore
   - Auth
   - Functions
   - Storage
   - Hosting
   - FCM

4. Setup Firestore Collections

Collections:
users
courses
modules
videos
subscriptions
progress
deviceSessions
paymentTransactions
auditLogs
announcements
coupons

5. Setup Environment Variables

Variables:
RAZORPAY_KEY_ID
RAZORPAY_SECRET
BUNNY_API_KEY
BUNNY_LIBRARY_ID
JWT_SECRET
ENVIRONMENT

6. Setup Firebase Functions Project

Initialize:
firebase init functions

Runtime:
Node.js

Install libraries:
express
jsonwebtoken
axios
firebase-admin

7. Setup Base API Server

Create base route:

/api/*

Middleware:
- JWT validation
- Error handler
- Response formatter

Deliverables:
✔ Firebase environments ready
✔ Base backend API running
✔ Database collections created

------------------------------------------------------------
SPRINT 2 — AUTHENTICATION SYSTEM
------------------------------------------------------------

Goal:
Implement OTP login and device binding.

Endpoints:

POST /api/auth/send-otp
POST /api/auth/verify-otp
POST /api/auth/check-device
POST /api/auth/refresh

Tasks:

1. Integrate Firebase Phone Authentication
2. Implement OTP sending endpoint
3. Implement OTP verification endpoint
4. Generate JWT tokens
5. Store deviceFingerprint in users collection
6. Enforce one-device-per-account rule
7. Implement deviceSessions tracking
8. Log login events in auditLogs

Edge Cases:
- OTP retry limit
- invalid OTP
- device mismatch
- paused account

Deliverables:
✔ Login flow functional
✔ Device restriction enforced
✔ JWT authentication working

------------------------------------------------------------
SPRINT 3 — COURSE & SUBSCRIPTION SERVICES
------------------------------------------------------------

Goal:
Create backend logic for courses and subscriptions.

Endpoints:

GET /api/course/list
GET /api/subscription/my
POST /api/admin/course/create
POST /api/admin/course/update

Tasks:

1. Course listing API
2. Subscription retrieval API
3. Admin course creation
4. Admin course update
5. BatchEndDate handling
6. Subscription schema implementation

Deliverables:
✔ Course listing working
✔ Subscription system functional

------------------------------------------------------------
SPRINT 4 — VIDEO ACCESS ENGINE
------------------------------------------------------------

Goal:
Implement secure video streaming logic.

Endpoints:

GET /api/video/list
POST /api/video/stream
POST /api/video/progress

Tasks:

1. Implement VideoAccessPolicy engine
2. Validate:
   - JWT
   - active account
   - subscription
   - batch expiry
   - sequential unlock
3. Integrate Bunny.net signed URL generation
4. Implement progress tracking
5. Unlock next lecture at 90% threshold

Deliverables:
✔ Video streaming functional
✔ Sequential unlock working

------------------------------------------------------------
SPRINT 5 — PAYMENT SYSTEM
------------------------------------------------------------

Goal:
Implement Razorpay payment integration.

Endpoints:

POST /api/payment/create-order
POST /api/payment/webhook

Tasks:

1. Create Razorpay order API
2. PaymentTransactions state machine
3. Webhook verification
4. Subscription activation on success
5. Duplicate webhook protection
6. Payment failure handling

Deliverables:
✔ Payment processing working
✔ Automatic subscription activation

------------------------------------------------------------
SPRINT 6 — STUDENT APP DEVELOPMENT
------------------------------------------------------------

Goal:
Build Flutter student application.

Screens:

Splash
Login
OTP
Profile Setup
Home
Store
My Courses
Course Detail
Video Player
Profile

Tasks:

1. Implement authentication UI
2. API integration with backend
3. Course listing UI
4. Video player integration (HLS)
5. Progress tracking calls
6. Razorpay checkout integration

Deliverables:
✔ Student app functional

------------------------------------------------------------
SPRINT 7 — ADMIN PANEL
------------------------------------------------------------

Goal:
Build Flutter Windows admin application.

Modules:

Dashboard
Course Management
Video Management
Student Management
Notifications
Reports

Tasks:

1. Admin authentication
2. Dashboard analytics
3. Course CRUD
4. Video upload to Bunny
5. Student search
6. Device reset
7. Manual course assignment

Deliverables:
✔ Admin panel operational

------------------------------------------------------------
SPRINT 8 — QA & HARDENING
------------------------------------------------------------

Goal:
System testing and stabilization.

Tasks:

1. Execute acceptance test cases
2. Validate edge cases
3. Test payment flows
4. Test video access policies
5. Verify security rules
6. Load testing
7. Bug fixing

Deliverables:
✔ Production-ready system

------------------------------------------------------------
DEPLOYMENT FLOW
------------------------------------------------------------

1. Develop in DEV
2. QA in STAGING
3. Deploy to PRODUCTION

Deployment command:

firebase deploy --project <environment>

------------------------------------------------------------
FINAL RELEASE CHECKLIST
------------------------------------------------------------

[ ] Authentication tested
[ ] Device restriction verified
[ ] Payment success tested
[ ] Video playback verified
[ ] Sequential unlock tested
[ ] Admin actions validated
[ ] Security rules enforced
[ ] Edge cases validated

Once all checks pass → Production deployment allowed.

END OF DOCUMENT
