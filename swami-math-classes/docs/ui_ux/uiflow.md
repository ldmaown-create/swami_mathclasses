# Swami Math Classes

# Final Screen Flow Blueprint v2.0 (Architecture-Aligned)

Status: OFFICIALLY FINALIZED — FLOW LOCK v2.0
Approved For:

* UI/UX Final Design

* Backend Implementation

* QA Test Case Design

* Firebase Environment Setup
  Aligned With:

* PRD v1.0

* SRS v1.0

* Architecture v2.0

* Unified API Contract v2.0

* Edge Case Matrix v1.0

Purpose:
This document defines COMPLETE logical screen structure, navigation flow, state transitions, and API mapping for:

1. Student Android App (Flutter)
2. Admin Windows Application (Flutter)

This is NOT visual design.
This is SYSTEM FLOW ARCHITECTURE.

This document must be understandable by:

* Developers
* QA
* Product team
* Any LLM consuming system design

No backend beyond Auth should be finalized until this is approved.

====================================================================
PART A — STUDENT ANDROID APP FLOW ARCHITECTURE
==============================================

---

## A1. GLOBAL APP STATES (SYSTEM LEVEL)

The app always exists in one of these system states:

STATE 1 — Unauthenticated
STATE 2 — Authenticated but Profile Incomplete
STATE 3 — Fully Authenticated (Active User)
STATE 4 — Device Blocked
STATE 5 — Account Paused
STATE 6 — Subscription Expired (per course)

All screens must respect these states.

---

## A2. APP ENTRY FLOW (BOOTSTRAP FLOW)

1. Splash Screen
2. Device Validation
3. Route Decision Engine

---

## A2.1 Splash Screen

Purpose:

* Load local storage
* Retrieve stored JWT
* Retrieve device fingerprint

No UI interaction.

---

## A2.2 Device Validation

API:
POST /api/auth/check-device

Inputs:

* JWT (if exists)
* deviceFingerprint

Possible Outcomes:

1. VALID_SESSION
   → Go to Home (STATE 3)

2. NO_JWT
   → Go to Login Screen (STATE 1)

3. DEVICE_MISMATCH
   → Go to Device Block Screen (STATE 4)

4. ACCOUNT_PAUSED
   → Go to Account Paused Screen (STATE 5)

5. JWT_EXPIRED
   → Attempt silent refresh

   * If refresh success → Home
   * If fail → Login

---

## A3. AUTHENTICATION FLOW

---

## A3.1 Login Screen

Fields:

* Mobile Number
* Continue Button

API:
POST /api/auth/send-otp

States:

* Loading
* OTP Sent
* Rate Limited
* Invalid Number

Next:
→ OTP Screen

---

## A3.2 OTP Screen

Fields:

* 6-digit OTP
* Resend OTP (60 sec timer)

API:
POST /api/auth/verify-otp

Possible Outcomes:

1. SUCCESS

   * profileDone = false → Profile Setup Flow (STATE 2)
   * profileDone = true → Home (STATE 3)

2. INVALID_OTP

3. ACCOUNT_PAUSED → Account Paused Screen

4. DEVICE_MISMATCH → Device Block Screen

---

## A4. DEVICE BLOCK FLOW

Screen: Device Blocked

Message:
"This account is linked to another device. Contact support."

Actions:

* WhatsApp Support
* Call Support
* Logout

No backend interaction.

---

## A5. ACCOUNT PAUSED FLOW

Screen: Account Paused

Message:
"Your account has been paused. Contact Swami Math Classes."

Actions:

* Contact Support
* Logout

All APIs must return 403 in this state.

---

## A6. PROFILE COMPLETION FLOW (MANDATORY GATE)

Multi-step form:

1. Basic Info
2. Academic Info
3. Parent Info
4. Address

API:
POST /api/profile/update

Rules:

* All required fields validated client-side
* Backend validates required schema
* profileDone must become true

On Completion:
→ Navigate to Home

User cannot access any other screen until profileDone = true.

====================================================================
A7. MAIN APPLICATION STRUCTURE (POST AUTH)
==========================================

Bottom Navigation Tabs:

1. Home
2. My Courses
3. Store
4. Profile

All tabs require JWT.

---

## A8. HOME SCREEN FLOW

Components:

1. Announcement Banner
   API: GET /api/announcement/active

2. Active Courses (isActive = true)
   API: GET /api/course/list

3. Exam Countdown (if subscribed)

4. Featured Section (optional future)

Home must not expose inactive courses.

---

## A9. STORE FLOW

Store Screen:
Displays all active purchasable courses.

API:
GET /api/course/list

On Buy Now:
→ Payment Flow

---

## A9.1 Payment State Flow

1. Create Order
   POST /api/payment/create-order

2. Open Razorpay Checkout

3. Payment Result:

   * SUCCESS (handled by webhook)
   * FAILED
   * CANCELLED

4. Processing Screen

   * Poll GET /api/subscription/my
   * Or use real-time listener

Edge Cases Covered:

* Duplicate webhook
* Payment stuck in INITIATED
* Webhook delay
* Refund later

On SUCCESS:
→ My Courses updated automatically

---

## A10. MY COURSES FLOW

API:
GET /api/subscription/my

Displays:

* Course Name
* Progress %
* Days Remaining
* Expiry Date

Tap Course → Course Detail Screen

---

## A10.1 Course Detail Screen

For Dual Folder (SSC 9 & 10):
Tabs:

* Math-I
* Math-II

For Single Folder:
Flat List

API:
GET /api/video/list?courseId=XXX

Each Lecture Displays:

* Title
* Duration
* Watched %
* Locked/Unlocked

Lock Conditions:

* No subscription
* Expired batch
* Sequential rule (90%)

---

## A11. VIDEO PLAYER FLOW (9-CHECK ENGINE ENTRY)

On Lecture Tap:

API:
POST /api/video/stream

Backend Runs:

1. JWT Validation
2. Account Active
3. Active Subscription
4. Batch Not Expired
5. Sequential Unlock Valid
6. Demo Access Check
7. Generate Bunny Signed URL
8. Log audit event
9. Return stream URL

If Success:

* Load HLS Player
* Apply FLAG_SECURE
* Render Dynamic Watermark
* Start 10-second progress sync

Progress API:
POST /api/video/progress

Unlock Rule:
If watchedPercent >= 90
→ Backend increments lastUnlockedIndex
→ UI auto-updates

Error Handling:

* PAYMENT_REQUIRED
* BATCH_EXPIRED
* VIDEO_LOCKED
* ACCOUNT_PAUSED
* UNAUTHORIZED

---

## A12. PROFILE SCREEN FLOW

Sections:

1. Personal Info (Editable)
2. Subscription Details
3. Payment History
4. Logout

APIs:
GET /api/user/me
GET /api/subscription/my
GET /api/payment/history

Logout:

* Clears local JWT
* Does NOT unlink device

====================================================================
PART B � ADMIN WINDOWS APPLICATION FLOW (DETAILED STATE & NAVIGATION ARCHITECTURE)
========================================================================

Admin Windows application is NOT just screens.
It operates as a guarded role-based state machine.

---

## B0. ADMIN SYSTEM STATES

ADMIN_STATE 1 — Unauthenticated
ADMIN_STATE 2 — Authenticated
ADMIN_STATE 3 — Session Expired
ADMIN_STATE 4 — Unauthorized Role

Every admin route must validate:

* Valid Admin JWT
* role = admin
* Session not expired (2 hours inactivity)

If JWT invalid → Redirect to Login
If Session expired → Force logout → Login

---

## B1. ADMIN ENTRY FLOW

1. Admin Login Screen
2. Credential Validation
3. Role Check
4. Dashboard Load

---

## B1.1 Admin Login Screen

Fields:

* Email
* Password
* Login Button

Auth Method:
Firebase Email + Password

On Submit:
→ Firebase Auth validates
→ Backend verifies role = admin

Outcomes:

1. SUCCESS → Dashboard (ADMIN_STATE 2)
2. INVALID_CREDENTIALS → Show error
3. NOT_ADMIN_ROLE → Show "Unauthorized"

Session timer starts after successful login.

---

## B2. DASHBOARD FLOW

Entry Point After Login.

API:
GET /api/admin/reports/summary

Dashboard States:

* Loading
* Data Loaded
* API Error

Displayed Widgets:

* Total Students
* Active Subscriptions
* Revenue This Month
* New Subscriptions Today
* Revenue Chart
* Course Enrollment Chart
* Recent Activity Feed

Navigation Options From Dashboard:
→ Course Management
→ Video Management
→ Student Management
→ Notifications
→ Reports
→ Logout

---

## B3. COURSE MANAGEMENT FLOW

Navigation:
Dashboard → Courses

Screen Structure:

* Course List Table
* Create Course Button
* Edit Action per Course
* Activate/Deactivate Toggle

---

## B3.1 Create Course Flow

1. Click "Create Course"
2. Open Create Course Form

Fields:

* Name
* Board
* Class
* Description
* Thumbnail Upload
* Price
* batchEndDate
* folderStructure (single/dual)
* isActive

API:
POST /api/admin/course/create

States:

* Validating
* Creating
* Success
* Error

On Success:
→ Return to Course List
→ Show success toast

---

## B3.2 Edit Course Flow

1. Click Edit
2. Open Edit Form (pre-filled)
3. Modify fields

API:
POST /api/admin/course/update

Special Logic:
If batchEndDate updated:
→ Must apply immediately to all subscriptions
→ Log audit event

---

## B4. VIDEO MANAGEMENT FLOW

Navigation:
Dashboard → Courses → Select Course → Manage Videos

Screen Sections:

* Video List (ordered)
* Upload Video Button
* Publish Toggle
* Reorder Controls
* Mark Demo Toggle

---

## B4.1 Upload Video Flow

1. Click Upload
2. Fill Metadata Form:

   * Title
   * Description
   * Thumbnail
   * Order Number
3. Backend requests Bunny Upload URL
4. Admin uploads video
5. Save video record

API:
POST /api/admin/video/upload

States:

* Uploading
* Processing
* Success
* Error

---

## B4.2 Reorder Flow

Action:
Drag & Drop or Up/Down

Backend:
Update orderNumber for affected videos

Must maintain sequential integrity.

---

## B5. STUDENT MANAGEMENT FLOW

Navigation:
Dashboard → Students

Student List Screen:

* Search bar
* Filter by course
* Status filter (Active/Paused)

API:
GET /api/admin/reports/students

Click Student → Student Detail Screen

---

## B5.1 Student Detail Screen

Displays:

* Full Profile
* Device ID
* Subscriptions
* Payment History
* Account Status

Available Actions:

1. Pause Account
2. Resume Account
3. Reset Device
4. Assign Course Manually
5. View Payment History

---

## B5.2 Pause / Resume Flow

API:
POST /api/admin/user/toggle

Effect:
users.isActive = false/true

System Reaction:
Paused user immediately blocked from video access.

---

## B5.3 Reset Device Flow

API:
POST /api/admin/subscription/reset-device

Effect:

* Clear deviceId
* Revoke active deviceSessions

User must re-login via OTP.

---

## B5.4 Manual Course Assignment Flow

1. Click "Assign Course"
2. Select Course
3. Confirm

API:
POST /api/admin/subscription/assign

Creates subscription with paymentMode = offline.

---

## B6. NOTIFICATION MANAGEMENT FLOW

Navigation:
Dashboard → Notifications

Screen Sections:

* Compose Message
* Select Target:
  a) All Students
  b) Specific Course
  c) Individual Student
* Schedule Option

API:
POST /api/admin/notification/send

States:

* Sending
* Success
* Error

If Course Target:
→ Must send only to active subscribers of that course.

---

## B7. REPORTS & EXPORT FLOW

Navigation:
Dashboard → Reports

Report Types:

* Revenue
* Subscriptions
* Students
* Offline Assignments

APIs:
GET /api/admin/reports/payments
GET /api/admin/reports/students

Export Flow:

1. Select Report Type
2. Select Date Range
3. Click Export
4. Choose Format (CSV / Excel / PDF)

Backend generates file and returns download link.

---

## B8. ADMIN GLOBAL GUARDS & ERROR HANDLING

All Admin Screens Must Handle:

* Loading State
* API Failure
* Session Expiry (redirect to login)
* Unauthorized Role (403)
* Network Retry

Critical Admin Actions Must:

* Log to auditLogs
* Be transaction-safe
* Display confirmation dialog before execution

====================================================================
PART C — GLOBAL ERROR & EDGE CASE HANDLING
==========================================

==========================================

All Screens Must Handle:

* Loading State
* Network Error
* 401 → Force Logout
* 403 → Show proper message
* Retry Mechanism

System-wide Edge Handling:

* Payment duplicate webhook ignored
* Subscription expiry mid-session
* Device session revocation
* Signed URL expiry mid-stream
* Coupon race condition

====================================================================
FLOW STATUS
===========

This document is now LOCKED as:
FINAL SCREEN FLOW BLUEPRINT v2.0

No structural changes allowed without formal change request.

Next Approved Phases:

1. UI/UX Visual Design (Figma)
2. Backend Middleware Implementation
3. Firebase Environment Setup (Dev → Staging → Production)
4. Auth Module Development
5. QA Test Case Mapping per Flow Section

Any new feature must:

* Map to an existing state
* Define new state explicitly
* Update API contract if required

This document is now the authoritative reference for:

* Navigation logic
* State transitions
* Role guards
* Screen responsibilities

END OF FINALIZED DOCUMENT


