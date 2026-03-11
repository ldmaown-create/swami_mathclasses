# Swami Math Classes

# Dev / Staging / Production Environment Strategy v1.0

# Deployment & Infrastructure Governance Specification

This document defines strict environment separation rules. NO
development should proceed without following this structure.

Architecture Alignment: - Firebase (Firestore + Auth + Functions +
Hosting) - Razorpay (Test + Live) - Bunny.net Stream - FCM - 5-Layer
Architecture Model

============================================================ SECTION 1
--- ENVIRONMENT SEPARATION MODEL
============================================================

You MUST maintain three completely separate environments:

1.  DEVELOPMENT (DEV)
2.  STAGING (PRE-PRODUCTION)
3.  PRODUCTION (LIVE USERS)

NEVER mix credentials between environments.

  ---------------------
  Environment Mapping
  ---------------------

DEV: - Firebase Project: swami-dev - Razorpay: Test Mode Keys - Bunny
Library: Test Library - Firestore DB: Dev DB - FCM: Dev Project

STAGING: - Firebase Project: swami-staging - Razorpay: Test Mode Keys -
Bunny Library: Staging Library - Used for internal beta testing

PRODUCTION: - Firebase Project: swami-prod - Razorpay: Live Keys - Bunny
Library: Production Library - Real students & payments

============================================================ SECTION 2
--- FIREBASE STRUCTURE
============================================================

Each environment must have:

-   Separate Firestore database
-   Separate Cloud Functions
-   Separate Auth users
-   Separate FCM tokens
-   Separate Hosting

Never deploy dev functions to production project.

Use Firebase project aliases:

firebase use --add

============================================================ SECTION 3
--- ENVIRONMENT VARIABLES STRATEGY
============================================================

All secrets must be stored as environment variables.

Use Firebase config or .env files.

Example Variables:

RAZORPAY_KEY_ID RAZORPAY_SECRET BUNNY_LIBRARY_ID BUNNY_API_KEY
WEBHOOK_SECRET JWT_SECRET ENVIRONMENT=dev \| staging \| production

Never hardcode secrets inside code.

============================================================ SECTION 4
--- RAZORPAY STRATEGY
============================================================

DEV & STAGING: - Use Test Mode - Test UPI IDs - Simulated webhooks

PRODUCTION: - Live Keys only - Webhook endpoint:
https://`<prod-api>`{=html}/api/payment/webhook

Never test payments in production.

============================================================ SECTION 5
--- BUNNY.NET STRATEGY
============================================================

Use separate video libraries:

DEV: - Low-quality test videos

STAGING: - Near-production content

PRODUCTION: - Final encoded lectures - Mumbai CDN region - Signed URL
enabled - Domain restriction enabled

============================================================ SECTION 6
--- DEPLOYMENT FLOW
============================================================

Proper Deployment Order:

1.  Develop in DEV
2.  QA in STAGING
3.  Deploy to PRODUCTION

Never deploy directly from local machine to production.

Recommended CI/CD:

-   GitHub Repository
-   Branch Strategy: main → production staging → staging env dev → dev
    env

Use: firebase deploy --project `<env>`{=html}

============================================================ SECTION 7
--- ROLLBACK STRATEGY
============================================================

If production bug occurs:

1.  Rollback to previous Git commit
2.  Redeploy previous stable version
3.  Never patch directly on live console

Maintain version tagging: v1.0.0 v1.0.1 v1.1.0

============================================================ SECTION 8
--- BACKUP & DATA SAFETY
============================================================

Production Firestore must have:

-   Daily automated export
-   BigQuery export enabled (optional analytics)
-   Retain auditLogs permanently

Never delete production collections manually.

============================================================ SECTION 9
--- MONITORING & ALERTS
============================================================

Production must enable:

-   Firebase Crashlytics
-   Cloud Function error alerts
-   Webhook failure alerts
-   Payment failure rate monitoring

If error rate \> 5%: Investigate immediately.

============================================================ SECTION 10
--- RELEASE SAFETY CHECKLIST
============================================================

Before production deployment:

\[ \] Firestore rules verified \[ \] Razorpay webhook tested \[ \] Bunny
signed URL tested \[ \] Payment success tested \[ \] Refund flow tested
\[ \] Device revocation tested \[ \] 9-check engine verified \[ \]
Environment variables verified

No deployment without checklist approval.

============================================================ FINAL RULE
============================================================

If uncertain: Deploy to staging first.

Production is sacred. Revenue and reputation depend on discipline.

END OF DOCUMENT
