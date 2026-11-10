# ALLSELL Backend & Government Auditor Engine

This directory contains the production-ready database schema and REST API server for the **ALLSELL** dual marketplace (Houses & Cars) in Ethiopia.

## Architecture & Features

1. **Dual Domain Persistence:**
   * `properties`: Real estate listings (Villas, Apartments, Condos, Commercial) with Addis Ababa sub-cities and Ethiopian utilities (water tanks, backup generators, 3-phase electricity).
   * `vehicles`: Automotive listings with Ethiopian market condition filters (*Brand New*, *Foreign Used*, *Ethiopian Used*) and customs clearance tracking.
2. **Broker KYC & TIN Verification:**
   * `agent_profiles`: Stores mandatory Ethiopian Tax Identification Numbers (TIN), Kebele / Fayda National IDs, and business licenses.
3. **Monetized Lead Reveal Micro-transactions:**
   * `lead_unlocks`: Tracks 20 ETB micro-payments via Telebirr and CBE Birr, unlocking protected agent phone/WhatsApp contacts.
4. **Government & Auditor Compliance Reporting:**
   * `transactions` & `audit_logs`: Calculates real-time Gross Transaction Volume (GTV), broker commission splits, and computes Ethiopian Revenue Authority (ERA) 2% withholding and turnover tax estimates.

---

## Quick Start (Python - Zero Dependencies)

The server runs out of the box using Python's standard library:

```bash
# 1. Seed or re-initialize the database
python3 backend/seed.py

# 2. Run the REST API server on port 8080
python3 backend/server.py 8080
```

---

## API Endpoints Reference

### Public Marketplace
* `GET /api/properties?sub_city=Bole&listing_type=FOR_SALE` - List verified properties
* `GET /api/properties/:id` - Single property with agent details
* `POST /api/properties` - Publish new property listing
* `GET /api/vehicles?sub_city=Bole&condition=BRAND_NEW` - List verified vehicles
* `GET /api/vehicles/:id` - Single vehicle details
* `POST /api/vehicles` - Publish new vehicle listing

### Transactions & Verification
* `POST /api/leads/unlock` - Process 20 ETB Telebirr unlock and return masked contact
* `POST /api/agents/kyc` - Submit broker TIN and National ID for review

### Regulatory & Auditor
* `GET /api/auditor/kpis` - Real-time GTV, broker counts, and tax calculations
* `GET /api/auditor/tax-report` - Exportable transaction ledger for tax authority

