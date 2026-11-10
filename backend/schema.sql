-- ==============================================================================
-- ALLSELL Platform Database Schema
-- Ethiopian Real Estate & Automotive Dual Marketplace
-- Compatible with PostgreSQL (Supabase) and SQLite 3
-- ==============================================================================

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    full_name TEXT NOT NULL,
    phone_number TEXT UNIQUE NOT NULL,
    email TEXT,
    role TEXT NOT NULL DEFAULT 'CUSTOMER', -- 'CUSTOMER', 'AGENT', 'MODERATOR', 'ADMIN', 'AUDITOR'
    is_active INTEGER NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Agent Profiles (KYC & Ethiopian TIN Verification)
CREATE TABLE IF NOT EXISTS agent_profiles (
    user_id TEXT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    agency_name TEXT,
    tin_number TEXT UNIQUE NOT NULL,        -- Ethiopian Tax Identification Number
    national_id_number TEXT,               -- Ethiopian Fayda National ID / Kebele ID
    business_license_number TEXT,
    verification_status TEXT NOT NULL DEFAULT 'PENDING', -- 'PENDING', 'VERIFIED', 'REJECTED', 'SUSPENDED'
    verified_at TIMESTAMP,
    rating REAL DEFAULT 5.0,
    deals_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Properties (Real Estate Vertical)
CREATE TABLE IF NOT EXISTS properties (
    id TEXT PRIMARY KEY,
    agent_id TEXT NOT NULL REFERENCES users(id),
    listing_type TEXT NOT NULL,           -- 'FOR_SALE', 'FOR_RENT'
    property_type TEXT NOT NULL,          -- 'VILLA', 'APARTMENT', 'CONDOMINIUM', 'COMMERCIAL', 'PENTHOUSE', 'LAND'
    title TEXT NOT NULL,
    description TEXT,
    price REAL NOT NULL,
    currency TEXT NOT NULL DEFAULT 'ETB',
    city TEXT NOT NULL DEFAULT 'Addis Ababa',
    sub_city TEXT NOT NULL,               -- 'Bole', 'Kirkos', 'Yeka', 'Nifas Silk', etc.
    wereda TEXT,
    address TEXT,
    latitude REAL,
    longitude REAL,
    bedrooms INTEGER DEFAULT 0,
    bathrooms INTEGER DEFAULT 0,
    area_sqm REAL NOT NULL,
    compound_sqm REAL,
    furnishing_status TEXT DEFAULT 'UNFURNISHED',
    water_tank_reserve TEXT,              -- e.g. '5000L Reserve Tank'
    has_backup_generator INTEGER DEFAULT 0,
    has_3phase_power INTEGER DEFAULT 0,
    primary_image TEXT NOT NULL,
    verification_status TEXT DEFAULT 'VERIFIED', -- 'PENDING', 'VERIFIED', 'REJECTED'
    status TEXT DEFAULT 'ACTIVE',                -- 'ACTIVE', 'SOLD', 'RENTED', 'INACTIVE'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Vehicles (Automotive Vertical)
CREATE TABLE IF NOT EXISTS vehicles (
    id TEXT PRIMARY KEY,
    agent_id TEXT NOT NULL REFERENCES users(id),
    make TEXT NOT NULL,                   -- e.g. 'Toyota'
    model TEXT NOT NULL,                  -- e.g. 'Land Cruiser Prado'
    year INTEGER NOT NULL,
    condition TEXT NOT NULL,              -- 'BRAND_NEW', 'FOREIGN_USED', 'ETHIOPIAN_USED'
    price REAL NOT NULL,
    currency TEXT NOT NULL DEFAULT 'ETB',
    mileage_km INTEGER DEFAULT 0,
    transmission TEXT NOT NULL,           -- 'AUTOMATIC', 'MANUAL'
    fuel_type TEXT NOT NULL,              -- 'PETROL', 'DIESEL', 'HYBRID', 'ELECTRIC'
    engine_capacity_cc TEXT,
    body_type TEXT,                       -- 'SUV', 'SEDAN', 'PICKUP', 'HATCHBACK'
    color TEXT,
    city TEXT NOT NULL DEFAULT 'Addis Ababa',
    sub_city TEXT NOT NULL,
    customs_cleared INTEGER DEFAULT 1,
    primary_image TEXT NOT NULL,
    verification_status TEXT DEFAULT 'VERIFIED',
    status TEXT DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Listing Media Gallery
CREATE TABLE IF NOT EXISTS listing_media (
    id TEXT PRIMARY KEY,
    listing_id TEXT NOT NULL,
    listing_type TEXT NOT NULL,           -- 'PROPERTY', 'VEHICLE'
    media_url TEXT NOT NULL,
    media_type TEXT DEFAULT 'IMAGE',      -- 'IMAGE', 'VIDEO', 'VIRTUAL_TOUR'
    sort_order INTEGER DEFAULT 0
);

-- 6. Lead Unlocks (Monetized Telebirr / CBE Birr micro-payments)
CREATE TABLE IF NOT EXISTS lead_unlocks (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL REFERENCES users(id),
    listing_id TEXT NOT NULL,
    listing_type TEXT NOT NULL,
    amount REAL NOT NULL DEFAULT 20.0,
    currency TEXT DEFAULT 'ETB',
    payment_provider TEXT NOT NULL,       -- 'TELEBIRR', 'CBE_BIRR', 'MPESA'
    payment_reference TEXT UNIQUE NOT NULL,
    agent_id TEXT NOT NULL REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Transactions & Escrow
CREATE TABLE IF NOT EXISTS transactions (
    id TEXT PRIMARY KEY,
    buyer_id TEXT REFERENCES users(id),
    seller_id TEXT REFERENCES users(id),
    agent_id TEXT REFERENCES users(id),
    listing_type TEXT NOT NULL,
    listing_id TEXT NOT NULL,
    amount REAL NOT NULL,
    commission_amount REAL NOT NULL,
    platform_fee REAL NOT NULL,
    status TEXT NOT NULL DEFAULT 'INITIATED', -- 'INITIATED', 'ESCROW_PAID', 'COMPLETED', 'CANCELLED'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    settled_at TIMESTAMP
);

-- 8. Government & Auditor Log (Immutable Regulatory Trail)
CREATE TABLE IF NOT EXISTS audit_logs (
    id TEXT PRIMARY KEY,
    event_type TEXT NOT NULL,            -- 'BROKER_VERIFIED', 'LISTING_PUBLISHED', 'LEAD_UNLOCKED', 'TRANSACTION_SETTLED'
    actor_id TEXT,
    entity_id TEXT,
    details TEXT,
    ip_address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for high-performance sub-city and price range queries
CREATE INDEX IF NOT EXISTS idx_properties_subcity ON properties(sub_city, listing_type, price);
CREATE INDEX IF NOT EXISTS idx_vehicles_make ON vehicles(make, condition, price);
CREATE INDEX IF NOT EXISTS idx_lead_unlocks_user ON lead_unlocks(user_id, listing_id);

