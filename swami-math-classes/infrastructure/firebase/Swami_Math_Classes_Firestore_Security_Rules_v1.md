# Swami Math Classes

# Firestore Security Rules -- Production Specification v1.0

# (STRICT -- ZERO CLIENT WRITES POLICY)

This document defines the complete Firestore security enforcement
strategy. It MUST match Architecture v2.0 and Backend API Master Context
v2.

============================================================ CORE
PRINCIPLE ============================================================

1.  Clients (Flutter Student App & Flutter Windows Admin Application) MUST NOT directly
    write to Firestore.
2.  All writes happen via Firebase Cloud Functions using Admin SDK.
3.  Firestore Rules act as a FINAL SECURITY WALL.
4.  Even if frontend is hacked → database remains protected.

============================================================
AUTHENTICATION MODEL
============================================================

All access requires Firebase Authentication.

request.auth != null

JWT must exist and be valid.

Custom Claims Required: - role: "student" or "admin" - deviceId: string

============================================================ GLOBAL
DEFAULT RULE
============================================================

rules_version = '2'; service cloud.firestore { match
/databases/{database}/documents {

    // Default deny all
    match /{document=**} {
      allow read, write: if false;
    }

} }

All permissions are explicitly opened below.

============================================================ COLLECTION
RULES ============================================================

  -----------
  1\. users
  -----------

Students may read only their own document. No client writes allowed.

match /users/{userId} { allow read: if request.auth != null &&
request.auth.uid == userId;

allow write: if false; }

  -------------
  2\. courses
  -------------

Courses are public-readable (only active ones). No client writes.

match /courses/{courseId} { allow read: if request.auth != null &&
resource.data.isActive == true;

allow write: if false; }

  -------------
  3\. modules
  -------------

Readable only if course active.

match /modules/{moduleId} { allow read: if request.auth != null; allow
write: if false; }

  ------------
  4\. videos
  ------------

Students may read metadata only. Actual video access is via backend
signed URL.

match /videos/{videoId} { allow read: if request.auth != null &&
resource.data.isPublished == true;

allow write: if false; }

  -------------------
  5\. subscriptions
  -------------------

Students may read only their own subscriptions.

match /subscriptions/{subscriptionId} { allow read: if request.auth !=
null && request.auth.uid == resource.data.userId;

allow write: if false; }

  --------------
  6\. progress
  --------------

Students may read only their own progress. Writes disabled (progress
updates via backend only).

match /progress/{progressId} { allow read: if request.auth != null &&
request.auth.uid == resource.data.userId;

allow write: if false; }

  --------------------
  7\. deviceSessions
  --------------------

NO client read or write allowed.

match /deviceSessions/{sessionId} { allow read, write: if false; }

  -------------------------
  8\. paymentTransactions
  -------------------------

Students may read their own transactions. No writes allowed.

match /paymentTransactions/{transactionId} { allow read: if request.auth
!= null && request.auth.uid == resource.data.userId;

allow write: if false; }

  ---------------
  9\. auditLogs
  ---------------

Completely private. Only backend admin SDK can access.

match /auditLogs/{logId} { allow read, write: if false; }

  --------------------
  10\. announcements
  --------------------

Readable by authenticated users. No client writes.

match /announcements/{announcementId} { allow read: if request.auth !=
null && resource.data.isActive == true;

allow write: if false; }

  --------------
  11\. coupons
  --------------

Never directly readable by students. Validated via backend.

match /coupons/{couponId} { allow read, write: if false; }

============================================================ ADMIN
ACCESS STRATEGY
============================================================

Admin panel NEVER writes directly to Firestore.

Admin operations go through Cloud Functions.

Optional (if read access required):

match /{document=\*\*} { allow read: if request.auth != null &&
request.auth.token.role == "admin"; }

But even then: Writes remain false.

============================================================ ADDITIONAL
HARDENING ============================================================

1.  Prevent Query-Based Data Leaks: Always validate request.auth.uid
    matches resource.data.userId.

2.  No Wildcard Write Access Anywhere.

3.  Disable recursive writes completely.

4.  Avoid allow read, write: if request.auth != null; This is insecure.

============================================================ WHY THIS IS
SECURE ============================================================

-   Students cannot alter progress manually.
-   Cannot fake subscription.
-   Cannot activate own account.
-   Cannot modify deviceSessions.
-   Cannot access auditLogs.
-   Cannot redeem coupon directly.
-   Cannot insert paymentTransactions.

Even if mobile app APK is reverse engineered → data safe.

============================================================ DEPLOYMENT
COMMAND ============================================================

firebase deploy --only firestore:rules

============================================================ FINAL RULE
============================================================

If unsure: DENY ACCESS.

Security \> Convenience.

END OF DOCUMENT
