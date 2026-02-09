# Qatar Landlord & Tenant App — Strategic Plan (v3)

## Changes from v2
- **Tech stack finalized:** Google Cloud Run + Flutter + Django/DRF + PostgreSQL
- **OCR simplified:** Autofill convenience tool only — user always reviews and confirms
- **Utilities approach changed:** In-app WebView redirects to Kahramaa/Ooredoo/Vodafone portals (no API integration)
- **Development approach:** Claude Code as primary development tool

---

## 1. Vision & Scope

### What This App Is
A compound and gated community management platform for Qatar that handles rent collection, post-dated cheque tracking, maintenance services, utility management, and tenant-landlord communication — starting with compounds and expanding to individual properties later.

### What This App Is NOT
- Not a property listing or search platform
- Not a real estate marketplace
- Not a lease origination tool

### Target Market Progression

```
Phase 1 (Launch)          Phase 2 (Expansion)         Phase 3 (Scale)
─────────────────         ──────────────────          ─────────────────
Compounds & Gated    →    Individual Buildings    →    Individual Flats
Communities               & Towers                    & Villas
(Pearl, Lusail,           (West Bay towers,           (Al Sadd, Old
Fox Hills, Qanat          Musheireb,                  Airport area,
Al Qasba)                 Al Dafna)                   Al Wakrah)
```

**Why compounds first:**
- Concentrated user base (hundreds of tenants per compound)
- Existing management office = single point of contact for onboarding
- Shared amenities and services create more touchpoints for the app
- Compound management already expects digital tools
- Higher willingness to pay for professional services

---

## 2. Platform Architecture

```
┌──────────────────────────────────────────────────────────┐
│                     Sakani Platform                       │
├────────────┬────────────┬──────────────┬─────────────────┤
│  Tenant    │  Landlord/ │  Maintenance │  Admin          │
│  App       │  Compound  │  Team App    │  Dashboard      │
│  (Flutter) │  Mgmt App  │  (Flutter)   │  (React Web)    │
│  iOS+Andrd │  (Flutter) │  iOS+Andrd   │                 │
├────────────┴────────────┴──────────────┴─────────────────┤
│                 Django REST API Backend                    │
│                 (Google Cloud Run)                         │
├────────────┬────────────┬──────────────┬─────────────────┤
│  Payments  │  Notif.    │  OCR         │  Storage        │
│  Module    │  Module    │  (Autofill)  │  Module         │
└────────────┴────────────┴──────────────┴─────────────────┘
```

### Four Distinct User Roles

| Role | Platform | Key Actions |
|------|----------|-------------|
| **Tenant** | Flutter mobile app (iOS + Android) | Pay rent, track cheques, submit maintenance, view bills, chat |
| **Landlord / Compound Management** | Flutter mobile app + React web dashboard | Track payments, manage units, approve maintenance, view reports, manage tenants |
| **Maintenance Team** | Flutter mobile app | Receive tickets, provide quotes, update status, upload completion photos |
| **Platform Admin (You)** | React web dashboard | Manage all compounds, oversee maintenance operations, analytics, billing |

### Tech Stack (Finalized)

| Layer | Technology | Rationale |
|-------|-----------|-----------|
| **Backend** | Django + Django REST Framework | Strong ORM, admin panel, mature ecosystem, excellent Claude Code support |
| **Database** | PostgreSQL (Cloud SQL) | Reliable, scales well, native Django support |
| **Mobile Apps** | Flutter (Dart) | Superior performance, consistent Arabic/RTL support, single codebase for iOS + Android |
| **Web Dashboard** | React | Admin/landlord dashboard, leverages existing expertise |
| **Hosting** | Google Cloud Run | Containerized Django, scales to zero, no server management |
| **File Storage** | Google Cloud Storage | Cheque photos, maintenance images, documents |
| **OCR** | Google Cloud Vision API | Pay-per-use, excellent Arabic support, same GCP ecosystem |
| **Push Notifications** | Firebase Cloud Messaging | Free tier sufficient, native Flutter integration |
| **Async Tasks** | Celery + Redis (Cloud Memorystore) | Background jobs: reminders, notifications, OCR processing |
| **Payments** | Sadad (NAPS/QPay) + Tap Payments (Visa/MC) | Local debit cards + international cards |
| **Development** | Claude Code (primary) | Django + Flutter are both well-supported by Claude Code |

### Infrastructure & Cost Estimate (Early Stage: 1-2 Compounds, ~200 Units)

| Service | Monthly Cost (USD) |
|---------|-------------------|
| Cloud Run (Django API) | 15–30 (scales to zero when idle) |
| Cloud SQL (PostgreSQL, db-f1-micro) | 25–40 |
| Cloud Storage | 5–10 |
| Cloud Vision API (OCR) | 5–15 (pay per image) |
| Firebase (push notifications) | Free tier |
| Cloud Memorystore (Redis) | ~30 (or defer to Phase 2) |
| **Total** | **~80–130** |

### Development Environment

```
Claude Code (primary IDE)
    ├── Django backend (Python)
    ├── Flutter apps (Dart)
    ├── React dashboard (JavaScript/TypeScript)
    └── Docker (local testing + Cloud Run deployment)

Git Repository Structure:
sakani/
├── backend/          # Django + DRF
│   ├── compounds/    # Compound & unit management
│   ├── cheques/      # Cheque tracking
│   ├── maintenance/  # Maintenance-as-a-service
│   ├── payments/     # Payment processing
│   ├── ocr/          # OCR autofill service
│   └── notifications/
├── mobile/           # Flutter app (all 3 roles via role-based navigation)
├── dashboard/        # React admin/landlord web dashboard
├── docker/           # Dockerfiles, docker-compose
└── docs/             # API docs, architecture decisions
```

---

## 3. Core Modules

### Module 1: Compound & Unit Management

The foundation — managing the physical structure and tenant assignments.

**Features:**
- Compound profile (name, location, amenities, management contact, rules)
- Building/block hierarchy within compound
- Unit registry (unit number, type, size, floor, bedrooms, status)
- Tenant assignment to units (move-in/move-out tracking)
- Tenant profile with QID verification and document uploads
- Lease information storage (start date, end date, rent amount, terms)
- Occupancy dashboard (occupied, vacant, notice given)
- Tenant directory for compound management
- Shared amenity booking (gym, pool, meeting rooms — for compounds)

**Data Model Sketch:**
```
Compound → Building → Unit → Lease → Tenant
                                ↓
                          Cheque Schedule
                          Payment Records
                          Maintenance Tickets
```

### Module 2: Rent Collection & Post-Dated Cheque Management

This is the critical module — the #1 pain point in Qatar's rental market.

#### Post-Dated Cheque Tracker (Core Feature)
In Qatar, rent is typically paid via post-dated cheques (usually 4-12 cheques per year). This creates a significant tracking burden for both parties.

**Features:**
- Register full cheque schedule at lease start (cheque number, bank, amount, date)
- Automatic reminders before each cheque date (7 days, 3 days, 1 day)
- Landlord marks cheque as: deposited / cleared / bounced / replaced
- Bounce alert workflow — notify tenant immediately, track resolution
- Cheque image capture via camera with OCR autofill (see Module 6 — OCR)
- Cheque replacement tracking (when a bounced cheque is replaced)
- Dashboard: upcoming cheques timeline, overdue cheques, cleared vs pending
- Annual cheque schedule overview per tenant

#### Digital Payments (Supplementary)
For compounds or tenants who prefer digital payment alongside or instead of cheques.

**Features:**
- Pay rent via NAPS/QPay (Sadad integration) or Visa/Mastercard (Tap)
- Automated recurring payment setup
- Partial payment handling
- Late payment tracking and penalty calculation
- Digital receipt generation (Arabic/English, PDF)
- Payment history and export

#### Financial Overview (Landlord/Compound Side)
- Rent collection status per unit (paid / pending / overdue / bounced)
- Monthly and annual income tracking per compound
- Expense tracking (maintenance costs, compound fees)
- Exportable reports (Excel/PDF)
- Outstanding balance summary

### Module 3: Maintenance-as-a-Service

**This is a revenue-generating service, not just a feature.** You operate/partner with maintenance teams and charge for the service — the app is the delivery mechanism.

#### How It Works:

```
┌──────────┐    ┌──────────────┐    ┌─────────────────┐    ┌──────────┐
│  Tenant   │    │   Platform   │    │  Maintenance     │    │  Tenant  │
│  submits  │───→│   routes to  │───→│  Team provides   │───→│  accepts │
│  request  │    │   maint team │    │  quote + ETA     │    │  or      │
│  + photos │    │              │    │                  │    │  rejects │
└──────────┘    └──────────────┘    └─────────────────┘    └──────────┘
                                                                │
                                          ┌─────────────────────┤
                                          ↓                     ↓
                                    If ACCEPTED:           If REJECTED:
                                    Team schedules         Tenant handles
                                    & completes work       it themselves
                                    Tenant confirms        (ticket closed)
                                    & pays via app
```

#### Tenant Side:
- Submit maintenance request with:
  - Category (AC, plumbing, electrical, painting, pest control, appliance, general)
  - Description (text, Arabic or English)
  - Photos/videos of the issue
  - Urgency level (routine / urgent / emergency)
  - Preferred time slots for visit
- Receive quote from maintenance team:
  - Estimated cost breakdown
  - Estimated completion time
  - Scheduled visit time
- Accept or reject the quote:
  - **Accept:** Work is scheduled, tenant can track progress
  - **Reject:** Ticket is closed, tenant handles it on their own
- Track status in real-time: submitted → quoted → accepted → in-progress → completed
- Rate the service after completion
- Pay maintenance fee through the app

#### Maintenance Team Side (Your Partnered/In-House Team):
- Receive new tickets with all details and photos
- Provide quote (cost + time estimate)
- Schedule visit upon acceptance
- Update status as work progresses
- Upload before/after completion photos
- Mark job as complete

#### Compound Management / Landlord Side:
- View all maintenance activity across their units
- Approve/override maintenance requests if needed (configurable)
- Track maintenance spending per unit
- Identify recurring issues (e.g., building-wide AC problems)
- Monthly maintenance cost reports

#### Emergency Handling:
Qatar summers reach 50°C. AC failure is a genuine emergency.
- Emergency tickets bypass the quote step
- Maintenance team is dispatched immediately
- Emergency surcharge can be applied
- Escalation notifications to compound management

#### Revenue Angle:
- You take a margin on each maintenance job (e.g., 15-25% markup on contractor cost)
- Or you charge a flat service fee per ticket
- Premium "priority response" tier for faster service
- Potential monthly maintenance subscription per unit

### Module 4: Utilities Management (WebView Approach)

Direct API integration with Kahramaa and telecom providers is not feasible for the initial launch. Instead, we use an in-app WebView to keep users within the app experience while redirecting them to the provider's own payment portal.

#### How It Works:

```
Utility Section in App
├── Kahramaa (Electricity & Water) → [Pay Now] → Opens Kahramaa portal in WebView
├── Ooredoo                        → [Pay Now] → Opens Ooredoo portal in WebView
└── Vodafone                       → [Pay Now] → Opens Vodafone portal in WebView
         │
         └── After payment → User logs payment manually in app
                             (amount, date, category, optional receipt photo)
```

**Features:**
- Quick-access links to payment portals (Kahramaa, Ooredoo, Vodafone) via in-app WebView
- Manual payment logging after completing payment (amount, date, bill type)
- Optional receipt photo upload (OCR autofill for amount and date — see Module 6)
- Bill responsibility tracking per lease (who pays what — tenant or landlord)
- Payment reminders before typical due dates
- Historical payment log with monthly totals
- Utility transfer checklist for move-in/move-out (Kahramaa account transfer steps)

**Future Enhancement:**
If Kahramaa or telecom providers open public APIs or partnership opportunities, the WebView can be swapped for native integration without changing the user experience.

### Module 5: Communication & Notifications

**Features:**
- In-app messaging between tenant ↔ landlord/compound management
- Compound-wide announcements (maintenance shutdowns, rule changes, events)
- Push notifications for all critical events:
  - Cheque date approaching
  - Rent overdue
  - Maintenance status update
  - New announcement
- SMS fallback for critical notifications
- WhatsApp integration (optional — many Qatar residents prefer WhatsApp)
- Document sharing within chat (receipts, NOC letters, contracts)
- Arabic/English bilingual throughout
- Notification preferences (tenant can choose what to receive)

---

## 4. OCR Autofill (Convenience Feature — Phase 1)

OCR is used strictly as an **autofill convenience tool**. The user always reviews and confirms the extracted data before it is saved. This keeps the implementation simple and removes the need for high-accuracy pipelines, confidence scoring, or manual review queues.

### How It Works (All OCR Flows):

```
User takes photo → Google Cloud Vision extracts text → App parses relevant fields
→ Form is pre-filled → User reviews, corrects if needed → User confirms and saves
```

The user is always the final authority. OCR just saves them from typing.

### 4.1 Cheque OCR Autofill
**Trigger:** User taps "Scan Cheque" when registering a new cheque.

**Fields auto-filled:**
- Cheque number
- Bank name
- Amount
- Date

**Implementation:**
- Flutter camera capture → send image to backend
- Backend calls Google Cloud Vision API (text detection)
- Simple parsing logic extracts fields based on position/keywords (Qatar bank cheques follow consistent layouts)
- Return parsed fields to the app
- App pre-fills the cheque registration form
- User reviews, corrects any errors, and confirms

### 4.2 Utility Receipt OCR Autofill
**Trigger:** User taps "Scan Receipt" when logging a utility payment.

**Fields auto-filled:**
- Amount paid
- Date
- Provider name (auto-select Kahramaa/Ooredoo/Vodafone)

### 4.3 Lease Document OCR Autofill
**Trigger:** Landlord/management uploads a lease document photo or PDF.

**Fields auto-filled:**
- Tenant name
- Lease start and end dates
- Monthly rent amount
- Unit/property reference

### 4.4 Maintenance Receipt OCR Autofill
**Trigger:** Maintenance team or landlord photographs an expense receipt.

**Fields auto-filled:**
- Vendor name
- Amount
- Date

### Technical Implementation

| Component | Choice | Notes |
|-----------|--------|-------|
| OCR Engine | Google Cloud Vision API | Excellent Arabic support, pay-per-use, same GCP ecosystem |
| Image Capture | Flutter camera plugin | Edge detection and crop before upload |
| Processing | Django backend service | Receives image → calls Vision API → parses response → returns fields |
| Cost | ~$1.50 per 1,000 images | Very low cost at early scale |

**Why Google Cloud Vision over self-hosted:**
- No model training or fine-tuning needed
- Arabic + English mixed text handled natively
- Maintenance-free — no infrastructure to manage
- At early scale (few hundred images/month), cost is negligible
- Can always move to self-hosted later if volume justifies it

---

## 5. Qatar-Specific Considerations

### 5.1 Localization Requirements
- Full RTL (Right-to-Left) layout for Arabic — Flutter handles this well natively
- Arabic-first UI design, with English toggle
- Hijri date option alongside Gregorian
- QAR currency formatting (ر.ق)
- Qatar phone number format (+974 XXXX XXXX)
- Qatar ID (QID) format validation

### 5.2 Compound-Specific Features
For the Phase 1 compound focus, these are essential:

- **Gate access management** (like TownTender) — QR code for resident/guest entry
- **Visitor pre-registration** — tenant registers expected guest, gate receives notification
- **Amenity booking** — pool, gym, BBQ area, meeting room scheduling
- **Parking management** — assigned spots, visitor parking passes
- **Common area maintenance** — compound-wide issues (elevator, hallway, garden)
- **HOA/Service charge tracking** — separate from rent, compound fees collection
- **Building rules & community guidelines** — digital handbook accessible in-app
- **Move-in/move-out workflow** — inspection checklist, key handover, utility transfer

### 5.3 Regulatory Alignment
- Lease templates aligned with Qatar rental law
- Aqarat (Real Estate Regulatory Authority) compliance tracking
- Data privacy compliance for tenant PII and QID storage
- Payment processing through licensed providers (Sadad, Tap)
- Proper handling of security deposits per Qatar law

---

## 6. Revenue Model (TBD — Options to Explore)

Revenue model requires further analysis. Here are the options on the table for continued discussion:

### Option A: Maintenance Margin Model
- Free app for tenants and landlords
- Revenue comes from markup on maintenance services (15-25%)
- Pros: Zero barrier to adoption, revenue scales with usage
- Cons: Need to build/partner with reliable maintenance operations
- Key question: Is the maintenance margin alone enough to sustain the business?

### Option B: Compound Subscription + Maintenance
- Compound management pays monthly per-unit fee (5-15 QAR/unit/month)
- Maintenance margin on top
- Pros: Predictable recurring revenue + variable maintenance income
- Cons: Compounds may resist per-unit fees early on
- Key question: What's the willingness-to-pay for compound managers?

### Option C: Transaction Fee Model
- Small fee on rent payments processed through the app (0.5-1.5%)
- Plus maintenance margin
- Pros: Revenue directly tied to rent volume
- Cons: Landlords may resist paying fees on their own rent; cheque payments don't generate transaction fees
- Key question: How much rent will actually flow through digital payments vs cheques?

### Option D: Freemium + Premium Features
- Basic compound management is free
- Premium features: advanced analytics, AI document processing, priority maintenance, bulk reports
- Plus maintenance margin
- Pros: Easy onboarding, upsell path
- Cons: Need to define a compelling free vs premium split

### Questions to Resolve:
1. Who is the paying customer — the compound management office, the landlord, or the tenant?
2. What is the maintenance cost structure — in-house team, single contractor partner, or multiple partners?
3. Is maintenance the primary revenue driver, or should the platform itself generate revenue too?
4. What's the target unit economics — how many units per compound to break even?
5. Would compounds pay for a white-label version of the platform?

---

## 7. Development Roadmap

### Phase 1: MVP — Compound Launch (3-4 months)
**Goal:** Launch with 1-2 pilot compounds, validate core workflows

**Build:**
- Django backend with Cloud Run deployment (Docker + CI/CD)
- Flutter mobile app with role-based navigation (tenant, landlord, maintenance)
- React admin dashboard (basic)
- Compound & unit management (hierarchy, tenant assignment)
- Tenant and landlord/management registration with QID
- Post-dated cheque tracker (register, remind, track status)
- Cheque OCR autofill (photograph → pre-fill form → user confirms)
- Basic maintenance request flow (submit with photos → quote → accept/reject → complete)
- Maintenance team interface in Flutter app
- Push notifications via Firebase (cheque reminders, maintenance updates)
- Arabic/English bilingual UI with full RTL support
- PostgreSQL on Cloud SQL

**Don't Build Yet:**
- Digital payment integration (Sadad/Tap)
- Utility WebView section
- Advanced analytics or reports
- Gate access / amenity booking
- Lease or receipt OCR
- WhatsApp integration

### Phase 2: Payments & Utilities (2-3 months)
**Goal:** Enable digital payments, add utility tracking, expand OCR

**Build:**
- Sadad/QPay payment integration for rent
- Tap Payments for Visa/Mastercard
- Digital receipt generation (Arabic/English PDF)
- Utility section with WebView links (Kahramaa, Ooredoo, Vodafone)
- Manual utility payment logging with receipt OCR autofill
- Lease document OCR autofill
- Financial dashboard (collection status, income/expense per compound)
- In-app messaging (tenant ↔ management)
- Compound-wide announcements
- Maintenance service ratings
- Celery + Redis for background task processing

### Phase 3: Compound Features & Scale (2-3 months)
**Goal:** Full compound management, onboard more compounds

**Build:**
- Gate access (QR code system)
- Visitor pre-registration
- Amenity booking (pool, gym, BBQ, meeting rooms)
- Parking management
- HOA/service charge tracking
- Advanced reporting and analytics
- Move-in/move-out workflows
- WhatsApp notification integration
- SMS fallback for critical notifications

### Phase 4: Expansion to Individual Properties (3+ months)
**Goal:** Adapt platform for non-compound use cases

**Build:**
- Individual landlord onboarding (no compound hierarchy needed)
- Simplified maintenance workflow for individual units
- Property-level financial tracking
- Standalone lease management
- Tenant self-service portal
- Multi-property dashboard for landlords with portfolios

---

## 8. Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Compounds don't want to switch from current system | High | Offer free pilot period; focus on cheque tracking as immediate value |
| Maintenance team quality/reliability | High | Start with vetted partner; strict SLA and rating system |
| Tenants reject maintenance quotes too often | Medium | Competitive pricing; transparent cost breakdown; satisfaction guarantee |
| Low digital payment adoption (cheque culture) | Medium | Cheque tracking IS the core feature; digital payments are supplementary |
| OCR autofill accuracy varies | Low | User always reviews and confirms; OCR is convenience, not automation |
| Regulatory changes | Medium | Flexible templates; monitor Aqarat updates regularly |
| Scaling maintenance operations to multiple compounds | Medium | Standardize processes early; zone-based team assignments |
| Flutter learning curve | Low | Dart is approachable from JS/React background; Claude Code handles Flutter well |

---

## 9. Immediate Next Steps

1. **Validate with 2-3 compound management offices** — interview them about current pain points, willingness to use a new platform, and what they'd pay for
2. **Map the maintenance business model** — talk to 2-3 maintenance contractors about partnership terms, cost structures, and response time capabilities
3. **Prototype the cheque tracker** — this is the fastest feature to validate and the most unique selling point
4. **Set up development environment** — Django project scaffold, Flutter project, Docker config, GCP project creation (Claude Code can handle all of this)
5. **Test OCR autofill** — photograph a few Qatar bank cheques, run through Google Cloud Vision API, assess how well basic field parsing works
6. **Decide on company structure** — sole proprietorship, LLC, or QFC registration based on revenue model
7. **Secure Sadad developer access** — apply for their sandbox/API credentials early, as fintech onboarding in Qatar can take time

---

*v3 — Finalized tech stack (Cloud Run + Flutter + Django), simplified OCR to autofill-only, utilities via WebView, Claude Code as primary development tool.*
