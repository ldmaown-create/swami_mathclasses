# PRODUCT REQUIREMENTS DOCUMENT
# Swami Math Classes
## Online Learning Mobile Application

---

> *Swami Math Classes — Product Requirements Document v1.0 | CONFIDENTIAL*

---

### Document Property Details

| Property | Details |
|---|---|
| **Document Title** | Swami Math Classes — Product Requirements Document |
| **Version** | 1.0 — Final (All decisions confirmed) |
| **Prepared By** | Latur Digital Marketing |
| **Prepared For** | Swami Sir / Arvind Sir — Swami Math Classes |
| **Date** | February 2026 |
| **Status** | **APPROVED — Ready for Development** |
| **Classification** | Confidential — Internal Use Only |

All product decisions in this document are final and confirmed by the client. This PRD reflects 22 confirmed decisions covering scope, pricing, authentication, subscription logic, content access, security, and technical stack. No open questions remain.

**Confidential — Not for distribution outside project team.**

---

## 1. Executive Summary

Swami Math Classes is a subscription-based online learning mobile application for Maharashtra mathematics students. The platform delivers secure, recorded video lectures to students preparing for SSC and CBSE board examinations, with full content protection against piracy, screen recording, and account sharing.

The application launches exclusively for SSC 10th Standard Mathematics students at Rs. 12,499 per annual subscription. The platform structure is built for all classes (SSC 8th, 9th, 10th and CBSE 9th, 10th) but only SSC 10th will be live and active at launch. Other classes will be activated in subsequent phases.

| Key Property | Value |
|---|---|
| **Product Name** | Swami Math Classes — Online Learning App |
| **Subject** | Mathematics only |
| **Launch Scope** | SSC 10th Standard — Active at launch |
| **Future Scope** | SSC 8th, 9th and CBSE 9th, 10th — Structure built, activated later |
| **Launch Price** | Rs. 12,499 per annual subscription (SSC 10th) |
| **Instructor** | Swami Sir (single instructor) |
| **Platform** | Android App + Windows Admin Application |
| **Video Hosting** | Bunny.net Stream (HLS, signed URLs) |
| **Payment Gateway** | Razorpay (UPI, Cards, Netbanking, Wallets) |
| **Authentication** | Firebase Phone OTP — one-time on first login, device permanently linked |
| **Device Policy** | One device per account — strictly enforced, no exceptions |
| **Content Security** | Screen recording blocked, screenshots disabled, dynamic watermark |
| **Admin Notification** | Swami Sir and Arvind Sir notified on every new subscription |
| **Target Geography** | Maharashtra, India |
| **Target Scale** | 50,000+ students — Maharashtra-wide |

---

## 2. Product Vision & Business Goals

### 2.1 Vision Statement

To provide the highest quality mathematics coaching to every SSC and CBSE student in Maharashtra through a secure, accessible, and affordable digital platform — extending Swami Sir's proven offline teaching to an unlimited number of students without geographical boundaries.

### 2.2 Business Goals

- Digitize Swami Sir's mathematics coaching and scale it to Maharashtra-wide reach
- Generate consistent subscription revenue through a digital platform
- Protect paid content fully — zero tolerance for piracy, screen recording, or account sharing
- Provide a professional, reliable learning experience that retains students through the full academic year
- Enable Swami Sir and Arvind Sir to manage the platform independently with minimal technical knowledge
- Build platform infrastructure for all classes upfront — activate each class when content is ready

### 2.3 Success Metrics

| Metric | Target |
|---|---|
| Paying students at launch (SSC 10th) | 100+ within first month |
| Video content completion rate | 60%+ of enrolled students complete 70%+ of course |
| Platform uptime | 99.9% — Firebase + Bunny.net SLA |
| Payment success rate | 95%+ via Razorpay |
| Student retention | 80%+ students active till March exam date |
| Screen recording incidents | Zero successful recordings |
| Support ticket resolution | Device change requests resolved within 2–7 days |

---

## 3. Scope of Product

### 3.1 Launch Scope — Phase 1 (Active at Launch)

Only SSC 10th Mathematics will be live and usable at launch. All other courses will have their structure built in the system but will be inactive and not visible to students until activated by admin.

| Course | Board | Class | Folder Structure | Status at Launch | Price |
|---|---|---|---|---|---|
| Mathematics Std. 10 | SSC Maharashtra | 10th | Two folders: Math-I and Math-II | **ACTIVE — Live at launch** | Rs. 12,499 |
| Mathematics Std. 9 | SSC Maharashtra | 9th | Two folders: Math-I and Math-II | INACTIVE — Structure built only | TBD |
| Mathematics Std. 8 | SSC Maharashtra | 8th | Single folder — all videos directly | INACTIVE — Structure built only | TBD |
| Mathematics Class 10 | CBSE | 10th | Single folder — all videos directly | INACTIVE — Structure built only | TBD |
| Mathematics Class 9 | CBSE | 9th | Single folder — all videos directly | INACTIVE — Structure built only | TBD |

### 3.2 What Is Out of Scope — Phase 1

- Live classes or real-time video sessions of any kind
- PDF notes, study materials, or downloadable content of any kind — completely excluded
- Test series, practice tests, or MCQ examinations
- Doubt submission or resolution feature
- Multiple instructors — Swami Sir is the only instructor
- Science subject or any subject other than Mathematics
- Web browser version for students — mobile app only
- Referral or reward program
- Marathi language interface — English only at launch
- iOS (Apple) app — Android only at launch
- Video download for offline viewing — stream only, no downloads ever
- Student self-service device change — admin only

---

## 4. Users & Roles

| Role | Who | Access Level | How Added |
|---|---|---|---|
| Admin | Swami Sir and/or Arvind Sir | Full access — Windows admin application only | System-level — hardcoded credentials |
| Paid Student | Student who completed Razorpay payment | Full course access — all lectures in subscribed course | Auto-activated on payment |
| Demo Student | Registered student who has not paid | First 2 lectures of any course only | Self-registration via app |
| Offline Student | Student who paid cash to Swami Sir directly | Full course access — same as paid student | Manually assigned by admin |

### 4.1 Student User Journey

1. Student downloads app from Google Play Store
2. Student registers with mobile number — OTP sent via Firebase
3. Student enters OTP — device is permanently linked to this account
4. Student completes mandatory profile setup (basic info, class, board, school, address, parent info)
5. Student lands on Home screen — can browse courses and watch first 2 demo lectures for free
6. Student decides to purchase — taps Buy Now on SSC 10th course
7. Student pays Rs. 12,499 via Razorpay (UPI / Card / Netbanking / Wallet)
8. Payment confirmed — course access unlocked instantly, no admin action required
9. Swami Sir and Arvind Sir receive push notification / SMS of new subscription
10. Student watches lectures sequentially — must complete 90% of each video to unlock next
11. Student retains access until batch end date (15th March or as set by admin)
12. Post-expiry — content is blocked, student prompted to contact for renewal

---

## 5. Student Mobile Application Features

### 5.1 Onboarding & Authentication

**Registration**

- Student enters 10-digit Indian mobile number
- OTP sent via Firebase Phone Authentication — 6-digit OTP, valid for 5 minutes
- Maximum 3 incorrect OTP attempts — account locked for 30 minutes after 3 failures
- On successful OTP entry — device is permanently linked to this account
- This is the ONLY time OTP is ever asked — subsequent logins on same device are automatic

**Profile Setup (Mandatory on First Login)**

Profile completion is mandatory before student can access the home screen. Four collapsible sections:

- Basic Info: Full name, date of birth, gender, profile photo (optional)
- Academic Info: Class (SSC/CBSE), board, school name, board exam year
- Parent Info: Father name, mother name, parent mobile number, parent email (optional)
- Address: Village/City, Taluka, District, State, PIN code

**Login — Same Device (Returning Student)**

- No OTP required — student is auto-logged in on app open
- JWT token refreshed silently in background
- If JWT expired — silent re-authentication using stored credentials

**Device Change Policy**

STRICT ONE DEVICE POLICY: Once a student logs in on a device, that device is permanently linked to the account. The student CANNOT log in on any other device without admin intervention.

If a student's phone is lost, broken, or needs replacement — they must contact Swami Math Classes support. Admin will reset the device link from the admin application. Resolution time: 2 to 7 working days.

There is no self-service device change option in the app. This is intentional to prevent account sharing.

### 5.2 Home Screen

- Announcement banner — supports both image (photo) and text. Admin controls from admin application.
- All active course cards with thumbnail, name, price, and Buy Now / Continue button
- Featured section — admin can highlight specific courses
- Exam countdown — shows days remaining to board exam date for enrolled course
- Bottom navigation: Home, My Courses, Store, Profile

### 5.3 My Courses (My Batches)

- Lists all courses the student is currently enrolled in
- Each course shows: course name, progress percentage, days remaining to expiry
- Tap course to open video list — lectures shown sequentially
- Locked lectures shown with lock icon — greyed out and not tappable
- Unlocked lectures show watch progress bar (percentage completed)
- Last watched lecture highlighted — student resumes from where they left off
- For SSC 9th and 10th courses — Math-I and Math-II subfolder tabs shown

### 5.4 Video Player

**Playback Features**

- HLS adaptive streaming via Bunny.net — auto quality adjustment based on internet speed
- Manual quality selection: Auto / 360p / 480p / 720p / 1080p
- Playback speed control: 0.5x / 0.75x / 1x / 1.25x / 1.5x / 2x
- Resume from last position — app remembers exact timestamp
- Full-screen mode with gesture controls
- Progress bar — student can see how much is watched but cannot scrub ahead to skip

**Sequential Locking**

- Students must watch lectures in order — lecture N is locked until lecture N-1 is 90% complete
- 90% watch threshold tracked in real-time and stored in Firestore
- Next lecture unlocks automatically when threshold is reached — no page refresh needed
- First 2 lectures of every course are always unlocked as demo — visible to all registered students
- Lectures 3 onwards require active paid subscription

**Security on Video Player**

> ⚠️ **CRITICAL SECURITY REQUIREMENT — MUST BE IMPLEMENTED IN DEVELOPMENT**

**Screen Recording:** Blocked completely on Android using FLAG_SECURE — screen goes black when recording is attempted. Detected and blurred on iOS.

**Screenshots:** Disabled inside the video player and throughout the entire application on Android using FLAG_SECURE.

**Dynamic Watermark:** Student's full name and registered mobile number overlaid on video at all times — semi-transparent, position changes periodically to prevent cropping.

**Signed URLs:** Every video stream URL is signed by Bunny.net with 5-minute expiry. The URL cannot be copied and used outside the app or shared.

**Domain Restriction:** Bunny.net configured to serve video only to the app's bundle ID. No other app or website can load the video URLs.

### 5.5 Store

- Shows all active courses with price, description, and course thumbnail
- Only SSC 10th shown at launch — other courses hidden until activated by admin
- Buy Now button opens Razorpay payment sheet within the app
- Payment methods: UPI, Debit/Credit Cards, Netbanking, Wallets
- Coupon code field — student can enter discount coupon before payment
- On successful payment — course access granted immediately, no waiting
- Payment receipt available in Profile > Payment History

### 5.6 Profile

- View and edit all 4 profile sections (Basic, Academic, Parent, Address)
- Subscription details — shows enrolled courses, expiry date, payment date
- Payment history — list of all transactions with date, amount, course, and status
- Logout button — clears local session but device link remains in backend
- App version number displayed at bottom

### 5.7 Push Notifications

- New lecture uploaded — notifies all enrolled students of that course
- Subscription expiry warning — 30 days before expiry and 7 days before expiry
- Payment confirmation — immediately after successful payment
- Admin announcement — admin can broadcast to all students or course-specific students
- All notifications managed via Firebase FCM

---

## 6. Subscription & Payment Model

### 6.1 Pricing

| Course | Board | Price | Status |
|---|---|---|---|
| Mathematics Std. 10 | SSC Maharashtra | Rs. 12,499 | **LIVE at launch** |
| Mathematics Std. 9 | SSC Maharashtra | TBD by admin | Inactive — structure built |
| Mathematics Std. 8 | SSC Maharashtra | TBD by admin | Inactive — structure built |
| Mathematics Class 10 | CBSE | TBD by admin | Inactive — structure built |
| Mathematics Class 9 | CBSE | TBD by admin | Inactive — structure built |

### 6.2 Subscription Expiry Logic

**Expiry Logic (Confirmed & Final):**

Each course has one batch end date set by admin. This date is editable by admin at any time from the admin application. Access is granted as long as today's date is on or before the batch end date.

**Code logic: `if (today <= batchEndDate) { allow access } else { block access }`**

SSC 10th batch end date: 15th March (editable by admin). Each other course will have its own independent date when activated.

- Subscription expiry is per course — not per student
- Admin sets one date for each course — all students of that course share the same expiry date
- Admin can change the batch end date at any time — the change applies immediately to all enrolled students
- There is no per-student expiry override — the course date applies to everyone
- No grace period — on expiry date+1, content is blocked completely
- Student sees a clear message on expiry with instructions to contact support for renewal

### 6.3 Payment Flow

1. Student taps Buy Now on SSC 10th course
2. App calls backend — Firebase Function creates Razorpay order with order ID
3. Razorpay payment sheet opens inside the app
4. Student selects payment method and completes payment
5. Razorpay sends webhook to Firebase Cloud Function
6. Backend verifies Razorpay webhook signature — invalid webhooks are discarded
7. If valid — subscription document created in Firestore with batchEndDate for that course
8. FCM push notification sent to student — course access confirmed
9. FCM push notification sent to Swami Sir AND Arvind Sir — new subscription alert
10. Student's My Courses tab updates in real-time — course is accessible immediately

### 6.4 Offline Student Enrollment

- Student pays cash directly to Swami Sir or Arvind Sir
- Admin logs into admin application — navigates to Student Management
- Admin searches for student by name or mobile number
- Admin assigns SSC 10th subscription manually — no payment processed
- Student's account is activated with the same batch end date as all other students
- Student receives push notification confirming course access

### 6.5 Coupon & Discount Codes

- Admin can create coupon codes from the admin application
- Each coupon has: code, discount type (flat or percentage), discount value, max uses, validity dates
- Student enters coupon code in Store before payment — discount applied to checkout
- Admin can deactivate or delete coupons at any time

---

## 7. Admin Windows Application

The Admin Application is a standalone Windows desktop application built using Flutter (Windows). It is installed and run directly on the administrator's Windows PC. At launch, the application will be distributed as a Windows installer package. React web admin panel is not in scope.

**Admin Users:** Swami Sir and Arvind Sir both have admin access. Both receive notifications on every new subscription.

**Access:** Windows desktop application (Windows 10 and above). Not accessible from the student mobile app.

**Security:** Admin login uses email + password (separate from student OTP authentication). Role-based access controlled via Firebase Auth custom claims.

### 7.1 Dashboard

- Summary tiles: Total Registered Students, Active Subscriptions, Total Revenue, New Subscriptions Today
- All tiles are clickable — tap to go to filtered list view
- Monthly revenue chart — bar chart showing revenue per month
- Course-wise enrollment chart — pie/bar chart showing students per course
- Recent activity feed — last 10 payments, registrations, and admin actions

### 7.2 Course & Video Management

- Create, edit, publish, and unpublish courses
- Set course price and batch end date for each course independently
- Edit batch end date anytime — change applies to all enrolled students of that course immediately
- Upload videos to Bunny.net — title, description, thumbnail, order number
- Drag-and-drop to reorder videos within a course or subfolder
- For SSC 9th and 10th: manage Math-I and Math-II subfolders independently
- Delete or unpublish individual videos
- View play count per video
- Mark first 2 lectures as demo — these are automatically accessible to non-paying students

### 7.3 Student Management

- View complete student list with search (by name, mobile, class, enrollment status)
- Filter by: course, subscription status, registration date, activity
- Student detail page: full profile, subscription info, payment history, last active
- Pause student account — student cannot login, sees 'Account paused — contact support' message
- Resume paused account
- Reset device ID — unlinks current device, student must re-verify OTP on next login (used for device change requests, resolved in 2–7 days)
- Manually assign course subscription to offline students
- Delete student account (with confirmation)

### 7.4 Subscription Management

- View all subscriptions — filter by course, status (active/expired), payment method
- Edit batch end date for any course — affects ALL students of that course
- Extend or revoke individual student subscription if required
- View revenue by course, by month, by payment method
- Export subscription data as CSV / Excel / PDF

### 7.5 Announcements & Notifications

- Create announcement banners — supports both image (photo upload) and text content
- Set banner active/inactive dates — schedule announcements in advance
- Send push notifications via FCM — target: all students / course-specific / individual student
- Schedule notifications for future date and time
- View notification delivery history

### 7.6 Reports & Export

- Student report — registered students, active students, inactive students
- Revenue report — total revenue, course-wise, month-wise, payment method-wise
- Subscription report — active, expired, manually assigned
- Offline students list — students enrolled without Razorpay payment
- All reports exportable as CSV, Excel (.xlsx), and PDF

---

## 8. Content Security Requirements

> 🔴 **MANDATORY SECURITY REQUIREMENT — NON-NEGOTIABLE**
>
> All security measures listed in this section MUST be implemented. No student must be able to record, capture, download, or share any video content from the platform under any circumstances.

| Security Measure | Implementation | What It Prevents |
|---|---|---|
| Screen Recording Block (Android) | FLAG_SECURE on all Activity windows — screen goes black when screen recording is detected or attempted | Android screen recording apps, built-in screen recorder |
| Screenshot Block (Android) | FLAG_SECURE flag — system prevents screenshot in entire app | Screenshots of video content, question images |
| Screen Recording (iOS) | iOS screen recording detection — video layer blurred/hidden when recording is detected | iOS screen recording in Control Center |
| Dynamic Watermark | Student full name + mobile number overlaid on video — semi-transparent, position rotates every 30 seconds | Deters recording — source student identifiable if leaked video found |
| Signed Video URLs | Bunny.net signed URL with 5-minute token expiry — new URL generated per play session | URL sharing, hotlinking, embedding on other sites |
| Domain / Bundle Restriction | Bunny.net configured to serve only to app bundle ID (com.swamimathclasses) — not accessible from browser or other apps | Extracting video URL and playing outside app |
| HLS Streaming Only | Videos delivered as HLS stream — no downloadable file exists | Downloading video file directly |
| Sequential Lock Enforcement | Backend validates sequential unlock before issuing any signed URL — client cannot bypass | Students skipping to later lectures without watching |
| JWT Authentication on Every Request | Every video URL request validated against active JWT token | Unauthorized video access |
| One Device Policy | Device ID stored — student can only stream from one device at a time | Account sharing — multiple students using one account |

---

## 9. Course Content Structure

| Course | Board | Folder Structure | Demo Lectures | Launch Status |
|---|---|---|---|---|
| Mathematics Std. 10 | SSC | Two subfolders: Math-I and Math-II | First 2 lectures of Math-I are demo | **ACTIVE** |
| Mathematics Std. 9 | SSC | Two subfolders: Math-I and Math-II | First 2 lectures of Math-I are demo | Inactive — built |
| Mathematics Std. 8 | SSC | Single folder — all videos directly | First 2 lectures are demo | Inactive — built |
| Mathematics Class 10 | CBSE | Single folder — all videos directly | First 2 lectures are demo | Inactive — built |
| Mathematics Class 9 | CBSE | Single folder — all videos directly (NO Math-I / Math-II) | First 2 lectures are demo | Inactive — built |

### 9.1 Demo Access Policy

- First 2 lectures of every course are freely accessible to all registered students
- Student must be registered and logged in to watch demo lectures
- No payment required for demo lectures
- From lecture 3 onwards — active paid subscription required
- Demo lectures are subject to same screen recording protection and watermark as paid lectures
- No PDF notes or any downloadable material in the app — completely excluded

---

## 10. Notification System

### 10.1 Student Notifications (Firebase FCM)

| Trigger | Recipient | Message Type | Timing |
|---|---|---|---|
| New video uploaded to course | All enrolled students of that course | Push notification | Immediately on upload |
| Payment successful | Paying student | Push notification | Immediately on payment |
| Subscription expiry warning | All students expiring in 30 days | Push notification | 30 days before batch end date |
| Subscription expiry final warning | All students expiring in 7 days | Push notification | 7 days before batch end date |
| Admin announcement | All / course-specific / individual | Push notification | Scheduled by admin |

### 10.2 Admin Notifications (New Subscription Alert)

**CONFIRMED: Both Swami Sir and Arvind Sir receive a notification for every new subscription received on the platform.**

Notification includes: student name, mobile number, course purchased, amount paid, payment method, and timestamp.

Delivery method: Push notification to admin's registered device (via FCM) and/or SMS (to be confirmed during development).

---

## 11. Technical Specifications

### 11.1 Technology Stack

| Component | Technology | Reason |
|---|---|---|
| Student App | Flutter (Android) | Single codebase, strong video support, FLAG_SECURE for security |
| Admin Application | Flutter (Windows) | Native Windows desktop app, single Flutter codebase shared with student app, rich data tables and dashboard support |
| Database | Firebase Firestore (NoSQL) | Real-time sync, auto-scales to 50,000+ students, serverless |
| Authentication | Firebase Phone Authentication | OTP login — no password infra needed, reliable OTP delivery |
| Backend Logic | Firebase Cloud Functions | Serverless — handles webhooks, subscription activation, API gateway |
| Video Hosting | Bunny.net Stream | HLS streaming, Mumbai CDN, signed URLs, affordable at scale |
| Payment | Razorpay | India-first, supports all Indian payment methods |
| Push Notifications | Firebase FCM | Free, reliable, supports topic broadcast and individual targeting |
| File Storage | Firebase Storage | Profile photos, thumbnails, announcement images |
| Admin App Distribution | Windows Installer (.exe) | Distributed directly to Swami Sir and Arvind Sir as Windows installer package |

### 11.2 Platform Support

| Platform | Minimum Version | Notes |
|---|---|---|
| Android App | Android 7.0 (API Level 24) | FLAG_SECURE available from API 24+ |
| Admin Application (Windows) | Windows 10 and above | Flutter Windows desktop app — installed on admin's PC |
| iOS App | Not in Phase 1 scope | Android only at launch |

### 11.3 Performance Requirements

- App cold launch to home screen: under 3 seconds on 4G connection
- Video start (tap to first frame): under 3 seconds on 4G connection
- API response time: under 1 second for all non-video endpoints
- Concurrent users: 5,000 simultaneous without degradation at launch
- Video quality: minimum 480p, target 720p for new uploads

---

## 12. Non-Functional Requirements

| Category | Requirement | Target |
|---|---|---|
| Availability | Platform uptime | 99.9% — Firebase + Bunny.net SLA |
| Security | Screen recording prevention | 100% — Zero successful recordings on Android |
| Security | Unauthorized video access | Zero — all streams require valid JWT + subscription |
| Security | Account sharing | Zero — one device per account, strictly enforced |
| Performance | App launch time | < 3 seconds on 4G |
| Performance | Video start time | < 3 seconds on 4G via Bunny.net CDN |
| Scalability | Concurrent users | 50,000+ without architecture change |
| Usability | Language | English (Marathi in future phase) |
| Usability | Profile completion | Mandatory before home screen access |
| Data Integrity | Payment activation | Subscription activates within 10 seconds of payment |
| Data Integrity | Progress tracking | Watch progress synced every 10 seconds during playback |
| Compliance | Payment security | Razorpay PCI-DSS compliant — no card data stored in app |

---

## 13. Future Scope — Phase 2

The following features are planned for Phase 2 after successful launch of Phase 1:

| Feature | Description |
|---|---|
| Activate remaining courses | SSC 8th, SSC 9th, CBSE 9th, CBSE 10th — content upload and activation when Swami Sir is ready |
| iOS App | Apple App Store submission after Android launch stabilises |
| Admin Windows Application (Flutter) | Primary admin interface as a Windows desktop application; React web admin panel is not in scope |
| Test Series | Chapter-wise and full-syllabus practice tests with MCQ and auto-scoring |
| Doubt Resolution | Students submit text/image doubts — admin replies within platform |
| Marathi Language UI | App interface in Marathi for wider Maharashtra accessibility |
| Referral Program | Students earn discount credits for referring new paying students |
| District Analytics | Admin sees student distribution across Maharashtra districts |
| Parent Dashboard | Separate parent login to monitor child progress |
| Science Subject | Expand platform to Science subject for SSC and CBSE |
| Web Version for Students | Browser-based student portal for students without smartphones |
| Multiple Pricing Tiers | Early bird pricing, bundle pricing once multiple classes are active |

---

## 14. Confirmed Decisions Register

All 22 product decisions are confirmed and final. This register serves as the single source of truth for all development and design decisions.

| # | Decision Area | Final Decision | Status |
|---|---|---|---|
| 1 | Payment Unlock | Auto unlock immediately after payment — no admin approval | **CONFIRMED** |
| 2 | Offline Students | Admin adds manually via admin application — no payment required | **CONFIRMED** |
| 3 | Launch Scope | SSC 10th only active at launch — all others inactive | **CONFIRMED** |
| 4 | Launch Price | SSC 10th = Rs. 12,499 per annual subscription | **CONFIRMED** |
| 5 | Subscription Expiry | Per course — one date set by admin, applies to all students of that course | **CONFIRMED** |
| 6 | Expiry Logic | if (today <= batchEndDate) allow access else block access | **CONFIRMED** |
| 7 | Batch End Date Edit | Admin can edit batch end date anytime from admin application | **CONFIRMED** |
| 8 | OTP Method | OTP only on first login — device permanently linked after | **CONFIRMED** |
| 9 | Device Change | Student contacts support, admin resets device — 2 to 7 working days | **CONFIRMED** |
| 10 | One Device Policy | Strictly one device per account — no exceptions in app | **CONFIRMED** |
| 11 | PDF Notes | Completely removed — no PDF notes or downloads of any kind | **CONFIRMED** |
| 12 | CBSE 9th Structure | Single folder — all lectures directly, no Math-I / Math-II split | **CONFIRMED** |
| 13 | Admin Notifications | Both Swami Sir and Arvind Sir notified on every new subscription | **CONFIRMED** |
| 14 | Admin Application | Windows desktop application built with Flutter — installed on admin PC, Firebase URL not applicable, Windows installer distributed directly | **CONFIRMED** |
| 15 | Announcement Banner | Supports both image (photo) and text — admin uploads from admin application | **CONFIRMED** |
| 16 | Screen Recording | Blocked completely — FLAG_SECURE Android, iOS detection + blur | **CONFIRMED** |
| 17 | Screenshots | Disabled throughout entire app using FLAG_SECURE | **CONFIRMED** |
| 18 | Video Hosting | Bunny.net Stream — HLS, signed URLs, Mumbai CDN | **CONFIRMED** |
| 19 | Video Security | Signed URLs (5 min expiry) + dynamic watermark (name + mobile) | **CONFIRMED** |
| 20 | Demo Access | First 2 lectures free with registration (login required) | **CONFIRMED** |
| 21 | Sequential Lock | 90% watch threshold required to unlock next lecture | **CONFIRMED** |
| 22 | Admin Notification Method | FCM push notification — both admins on every subscription | **CONFIRMED** |

---

## 15. Document Sign-Off

By signing below, all parties confirm that this PRD accurately represents the agreed product requirements and that development may proceed based on this document.

| Role | Name | Signature | Date |
|---|---|---|---|
| Product Owner / Client | Swami Sir — Swami Math Classes | | |
| Product Owner / Client | Arvind Sir — Swami Math Classes | | |
| Project Manager | Latur Digital Marketing | | |
| Lead Developer | | | |

Once this document is signed, any changes to requirements must go through a formal Change Request process. Changes may affect timeline and cost.

---

**— End of Document — Swami Math Classes PRD v1.0 — Latur Digital Marketing — Confidential —**
