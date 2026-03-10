# Swami Math Classes

# Edge Case & Failure Handling Matrix v1.0

# Production Stability Specification

This document defines ALL known failure scenarios and the exact system
response. It must align with:

-   5-Layer Architecture
-   6 Business Services
-   9-Step VideoAccessPolicy
-   6-State Payment State Machine
-   One-Device Policy
-   Firestore Transaction Model

Core Rule: Every failure must result in a deterministic, logged,
recoverable system state.

============================================================ SECTION 1
--- AUTHENTICATION EDGE CASES
============================================================

1.  OTP Not Delivered Cause:

-   SMS provider delay

Handling: - Allow resend after 60 seconds - Max 3 attempts per 5
minutes - Log to auditLogs as OTP_RETRY

------------------------------------------------------------------------

2.  OTP Verified But App Closed Before JWT Return

Cause: - App crash or force close

Handling: - On next login attempt → treat as Case B (same device) -
Issue fresh JWT - Do NOT create duplicate deviceSession

------------------------------------------------------------------------

3.  Simultaneous Login On Two Devices

Cause: - User shares OTP

Handling: - New login (Case C) revokes old session - Old JWT becomes
invalid - Log event: DEVICE_REVOKED - Old device API calls return 401

------------------------------------------------------------------------

4.  Device Fingerprint Spoof Attempt

Cause: - Manual tampering

Handling: - Compare fingerprint with stored deviceSession - If mismatch
→ force OTP revalidation - Log IP + fingerprint to auditLogs - Flag
account if repeated

============================================================ SECTION 2
--- PAYMENT EDGE CASES
============================================================

1.  Payment Successful But Webhook Delayed

Cause: - Razorpay delay

Handling: - App shows "Processing Payment" - Backend waits for webhook -
Auto-expire INITIATED state after 30 min - Retry verification endpoint
allowed

------------------------------------------------------------------------

2.  Duplicate Webhook Received

Cause: - Razorpay retries

Handling: - Check razorpayOrderId - If state == SUCCESS → ignore - Log
DUPLICATE_WEBHOOK

------------------------------------------------------------------------

3.  Payment Success But App Closed

Cause: - User exits before callback

Handling: - Webhook activates subscription - On next login →
subscription fetched from backend - Never rely on frontend success
callback

------------------------------------------------------------------------

4.  User Clicks Pay Twice Quickly

Cause: - Double tap

Handling: - Create only one order per course per user - If CREATED state
exists → reuse same orderId

------------------------------------------------------------------------

5.  Refund After Activation

Cause: - Manual refund

Handling: - Webhook sets state = REFUNDED - Subscription status set to
expired - Revoke access immediately - Notify student + admin

------------------------------------------------------------------------

6.  Payment State Stuck In INITIATED

Cause: - No webhook

Handling: - Scheduled Cloud Function every 15 min - Mark INITIATED \> 30
min as EXPIRED

============================================================ SECTION 3
--- VIDEO ACCESS EDGE CASES
============================================================

1.  Signed URL Expires Mid-Stream

Cause: - 5-minute expiry

Handling: - App auto-requests new signed URL before expiry - Backend
re-runs 9 checks

------------------------------------------------------------------------

2.  Internet Disconnect Mid-Video

Handling: - Player pauses - Resume triggers new stream request -
Progress saved every 10 seconds

------------------------------------------------------------------------

3.  90% Threshold Rounding Issue

Handling: - Use floor(watchedSeconds / totalSeconds) \>= 0.90 - Avoid
floating point precision issues

------------------------------------------------------------------------

4.  Batch End Date During Streaming

Handling: - If already streaming → allow until URL expires - Next
request fails with BATCH_EXPIRED

------------------------------------------------------------------------

5.  User Tries Direct Bunny URL Sharing

Handling: - URL expires in 5 minutes - Domain restriction + signed token
required - Watermark identifies user

============================================================ SECTION 4
--- SUBSCRIPTION EDGE CASES
============================================================

1.  Overlapping Subscriptions

Handling: - If user purchases again before expiry: - Extend
batchEndDate - Do not create duplicate active subscription

------------------------------------------------------------------------

2.  Admin Manually Expires Subscription

Handling: - Set status = expired - Next video request fails - Push
notification sent

------------------------------------------------------------------------

3.  Coupon Race Condition

Cause: - Two users use last available coupon simultaneously

Handling: - Firestore transaction: - Check usedCount \< maxUses -
Increment atomically - If fails → reject coupon

============================================================ SECTION 5
--- DEVICE SESSION EDGE CASES
============================================================

1.  Old Session Not Revoked

Handling: - Always use Firestore transaction when revoking - Ensure only
one deviceSession where isActive == true

------------------------------------------------------------------------

2.  Rapid Login Attempts From Different Regions

Handling: - Detect IP anomaly (2 countries in 1 hour) - Flag account -
Require OTP revalidation

============================================================ SECTION 6
--- NOTIFICATION EDGE CASES
============================================================

1.  FCM Token Expired

Handling: - Remove token on send failure - Request new token on next app
open

------------------------------------------------------------------------

2.  Duplicate Notifications

Handling: - Store notificationId - Prevent re-sending same ID

============================================================ SECTION 7
--- DATABASE & CONCURRENCY
============================================================

1.  Firestore Transaction Conflict

Handling: - Retry up to 3 times - If still fails → return 503
RETRY_LATER

------------------------------------------------------------------------

2.  Cloud Function Timeout

Handling: - Use async background job for heavy tasks - Keep API response
under 5 seconds

------------------------------------------------------------------------

3.  Partial Write Failure

Handling: - All critical operations wrapped in transaction - Never write
subscription without payment SUCCESS

============================================================ SECTION 8
--- SYSTEM-WIDE SAFETY RULES
============================================================

-   No subscription activated without verified webhook
-   No video URL without full 9 checks
-   No deviceSession without revoking old session
-   No coupon applied without atomic validation
-   All sensitive actions logged in auditLogs

============================================================ FINAL PRINCIPLE========================================================

If unexpected state detected: 1. Deny access 2. Log event 3. Preserve
data integrity 4. Never guess success

Revenue Protection \> User Convenience

END OF DOCUMENT
