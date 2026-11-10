# 🇪🇹 ALLSELL — Connect & Simplify
**Dual Real Estate & Automotive Marketplace for Ethiopia**  
*Version 1.0 | Official Flutter Application & Backend Architecture*

![ALLSELL Brand Logo](assets/images/logo.png)

---

## 🌟 Executive Summary

**ALLSELL** is a dual-vertical e-commerce and classifieds marketplace platform tailored specifically for the Ethiopian market, unifying **Real Estate (Houses/Properties)** and **Automotive (Cars/Vehicles)** into a seamless, verified, and transparent transaction ecosystem.

### Core Business Pillars
1. **Unified Dual Marketplace:** Instant switching between **Houses** (Rent/Sale) and **Cars** (New/Used) with location-first filtering across Addis Ababa sub-cities (*Bole, Kirkos, Yeka, Nifas Silk, Lideta, Arada, etc.*) and regional hubs.
2. **Verified Agent Ecosystem:** Strict broker onboarding with Ethiopian Tax Identification Number (TIN) and official ID document verification. Verified brokers carry the prominent `✓ Verified` trust badge.
3. **Monetized Lead Reveal & Transaction Monitoring:** Contact details are gated behind micro-transactions (Telebirr, CBE Birr) to protect broker leads and eliminate fake inquiries.
4. **Government & Auditor Portal:** Dedicated regulatory compliance dashboard providing economic volume tracking (Gross Transaction Volume in ETB) and tax reporting compliant with Ethiopian legal frameworks.

---

## 🎨 Visual Identity & Color Palette

* **Primary Brand Amber:** `#FF8D00` (Warm, vibrant Ethiopian gold-amber representing commerce, energy, and value)
* **Primary Deep Black:** `#000000` / `#0D0E11` (Sophisticated contrast and typography)
* **Warm Cashmere Surface:** `#F7F5F0` / `#FAF9F6` (Wireframe-matching off-white background)
* **Verified Accent Gold:** `#D97706` / `#16A34A` (Trust badges and verification marks)
* **Telebirr Accent:** `#0077FE` (Payment indicators and lead unlock prompts)

---

## 📱 Mobile Wireframe Layout Breakdown

```
+-----------------------------------------------------------+
| [ALLSELL Logo]           [ Addis Ababa ▾ ]     [ Filter ] |
+-----------------------------------------------------------+
| [ 🔍 Search houses or cars in Addis Ababa...            ] |
+-----------------------------------------------------------+
|   [ 🏠 Houses (Active) ]         [ 🚗 Cars ]              |
+-----------------------------------------------------------+
| [Featured this week: Luxury Bole Villas & Toyota Prados ] |
+-----------------------------------------------------------+
|  +-----------------------+     +-----------------------+  |
|  | [House Photo 1/8]     |     | [House Photo 1/6]     |  |
|  | ✓ VERIFIED            |     | ✓ VERIFIED            |  |
|  | ETB 28,500,000        |     | ETB 14,200,000        |  |
|  | Modern Villa Bole     |     | Sunshine 3-Bed CMC    |  |
|  | 4 Bed · 5 Bath · 380m²|     | 3 Bed · 2 Bath · 165m²|  |
|  | 📍 Bole Atlas         |     | 📍 CMC, Yeka          |  |
|  +-----------------------+     +-----------------------+  |
+-----------------------------------------------------------+
| [ Home ]          [ Add (+) ]     [ Favorites ]  [ Portal ]|
+-----------------------------------------------------------+
```

---

## 🚀 Running the Project

### 1. Interactive Web Simulator (Instant Preview)
Open the standalone interactive prototype in any browser without needing Flutter installed:
```bash
# Open directly in macOS:
open web/demo.html
```
* **Features in Demo:** Full dual-category switcher, Addis Ababa sub-city filter, Telebirr 20 ETB lead unlock modal, and Government Auditor compliance portal.

### 2. Flutter Mobile Application
```bash
# Install dependencies
flutter pub get

# Run on connected device or simulator
flutter run
```

### 3. Backend & Auditor Engine (Python / SQLite)
```bash
# Initialize and seed database
python3 backend/seed.py

# Start the REST API server on port 8080
python3 backend/server.py 8080
```

---

## 🏛️ Government & Auditor Portal

Accessible directly within the app's **Portals** tab:
* **Gross Transaction Volume (GTV):** Real-time aggregation of completed property and vehicle sales in ETB.
* **Verified Broker Registry:** Verification status, TIN registration, and performance metrics.
* **Ethiopian Revenue Authority (ERA) Tax Statements:** Computes standard 2% withholding and turnover taxes based on Ethiopian tax regulations, exportable to CSV/PDF.

---

## 📂 Project Structure

```
├── ALLSELL_SYSTEM_DESIGN.md       # Full architecture & specification doc
├── ALLSELL_SYSTEM_DESIGN.html     # Client presentation document
├── ALLSELL_SYSTEM_DESIGN.pdf      # Exportable PDF specification
├── assets/images/logo.png         # Official ALLSELL logo
├── backend/
│   ├── schema.sql                 # PostgreSQL & SQLite database schema
│   ├── seed.py                    # Ethiopian seed data script
│   ├── server.py                  # Standalone REST API server
│   └── test_api_mock.py           # Unit tests
├── lib/
│   ├── data/                      # Ethiopian real estate & car mock data
│   ├── models/                    # Property, Car, Seller (TIN) models
│   ├── screens/                   # Explore, Details, Sell, Saved, Portals
│   ├── state/                     # Unified CarStore state management
│   ├── theme/                     # Brand Amber & Deep Black theme
│   └── widgets/                   # PropertyCard, CarCard, TelebirrPaywallModal
└── web/
    └── demo.html                  # Interactive mobile simulator
```
