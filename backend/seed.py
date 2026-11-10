#!/usr/bin/env python3
"""
ALLSELL Database Seed Script
Populates allsell.db with realistic Ethiopian real estate & automotive data,
verified broker profiles with valid TIN numbers, and transaction audit trails.
"""

import sqlite3
import os
import uuid

DB_PATH = os.path.join(os.path.dirname(__file__), "allsell.db")
SCHEMA_PATH = os.path.join(os.path.dirname(__file__), "schema.sql")

def init_and_seed():
    if os.path.exists(DB_PATH):
        os.remove(DB_PATH)

    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    # Read and apply schema
    with open(SCHEMA_PATH, "r", encoding="utf-8") as f:
        cursor.executescript(f.read())

    # 1. Seed Users (Brokers, Customers, Auditor)
    users = [
        ("user-agent-1", "Abebe Demisse", "+251911428890", "abebe@boleproperty.et", "AGENT"),
        ("user-agent-2", "Selamawit Tadesse", "+251923456789", "selam@addisliving.et", "AGENT"),
        ("user-agent-3", "Henok Girma", "+251911994433", "henok@addismotors.et", "AGENT"),
        ("user-agent-4", "Dawit Bekele", "+251912345678", "dawit@habeshaauto.et", "AGENT"),
        ("user-cust-1", "Prem Kumar", "+251911002233", "prem@example.com", "CUSTOMER"),
        ("user-auditor-1", "Federal Auditor (ERA)", "+251115510000", "audit@era.gov.et", "AUDITOR"),
    ]
    cursor.executemany("INSERT INTO users (id, full_name, phone_number, email, role) VALUES (?, ?, ?, ?, ?)", users)

    # 2. Seed Agent Profiles (TIN & National IDs)
    agent_profiles = [
        ("user-agent-1", "Bole Premier Realty", "0048192841", "ET-FAN-984120", "BL-AA-2022-841", "VERIFIED", "2023-01-15 10:00:00", 4.95, 48),
        ("user-agent-2", "Addis Living Real Estate", "0059281723", "ET-FAN-723145", "BL-AA-2023-112", "VERIFIED", "2023-04-20 11:30:00", 4.88, 36),
        ("user-agent-3", "Addis Motor Vault", "0019283741", "ET-FAN-374198", "BL-AA-2021-490", "VERIFIED", "2022-11-05 09:15:00", 4.92, 62),
        ("user-agent-4", "Habesha Auto Brokers", "0081726354", "ET-FAN-635412", "BL-AA-2023-678", "VERIFIED", "2023-08-12 14:00:00", 4.75, 29),
    ]
    cursor.executemany("""
        INSERT INTO agent_profiles (user_id, agency_name, tin_number, national_id_number, business_license_number, verification_status, verified_at, rating, deals_count)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, agent_profiles)

    # 3. Seed Properties (Houses / Villas / Condos in Addis Ababa)
    properties = [
        (
            "prop-1", "user-agent-1", "FOR_SALE", "VILLA",
            "Modern Luxury Villa in Bole Atlas",
            "Stunning luxury villa located in the prestigious Bole Atlas neighborhood. Features high-end European finishes, backup generator, 5,000L water tank reserve, and 24/7 security booth.",
            28500000.0, "ETB", "Addis Ababa", "Bole", "Wereda 03", "Bole Atlas, Near Edna Mall",
            9.0012, 38.7845, 4, 5, 380.0, 500.0, "FULLY_FURNISHED", "5,000L Reserve Tank", 1, 1,
            "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=800&q=80",
            "VERIFIED", "ACTIVE"
        ),
        (
            "prop-2", "user-agent-2", "FOR_SALE", "APARTMENT",
            "CMC Sunshine Luxury 3-Bed Apartment",
            "Brand new 3-bedroom apartment on the 6th floor with breathtaking mountain views. Modern elevator, designated underground parking, and fiber optic connection.",
            14200000.0, "ETB", "Addis Ababa", "Yeka", "Wereda 08", "CMC Sunshine Site 2",
            9.0210, 38.8320, 3, 2, 165.0, None, "UNFURNISHED", "Central Site Reserve", 1, 0,
            "https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80",
            "VERIFIED", "ACTIVE"
        ),
        (
            "prop-3", "user-agent-1", "FOR_RENT", "VILLA",
            "Diplomatic Residence in Old Airport",
            "Secured high-commission diplomatic residence close to the International Community School (ICS). Expansive manicured garden, guard house, and separate service quarters.",
            145000.0, "ETB", "Addis Ababa", "Nifas Silk", "Wereda 02", "Old Airport, Near ICS",
            8.9830, 38.7350, 5, 5, 450.0, 800.0, "SEMI_FURNISHED", "10,000L Dual Reserve", 1, 1,
            "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80",
            "VERIFIED", "ACTIVE"
        ),
        (
            "prop-4", "user-agent-1", "FOR_RENT", "CONDOMINIUM",
            "Modern Condominium in Kazanchis",
            "Fully furnished 2-bed flat situated in the heart of Kazanchis near UNECA. Ideal for international expats, diplomats, and NGO professionals.",
            45000.0, "ETB", "Addis Ababa", "Kirkos", "Wereda 06", "Kazanchis, Near UNECA",
            9.0180, 38.7690, 2, 2, 110.0, None, "FULLY_FURNISHED", "Site Tank", 1, 0,
            "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80",
            "VERIFIED", "ACTIVE"
        ),
        (
            "prop-5", "user-agent-2", "FOR_SALE", "PENTHOUSE",
            "Executive Penthouse in Sarbet",
            "Panoramic top-floor penthouse with 360-degree views of Addis Ababa. Modern jacuzzi, smart home automated lights, and 2 dedicated parking bays.",
            24000000.0, "ETB", "Addis Ababa", "Nifas Silk", "Wereda 04", "Sarbet, Near AU Headquarters",
            8.9950, 38.7410, 3, 3, 230.0, None, "FULLY_FURNISHED", "Dual Roof Tanks", 1, 1,
            "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80",
            "VERIFIED", "ACTIVE"
        )
    ]
    cursor.executemany("""
        INSERT INTO properties (
            id, agent_id, listing_type, property_type, title, description, price, currency,
            city, sub_city, wereda, address, latitude, longitude, bedrooms, bathrooms,
            area_sqm, compound_sqm, furnishing_status, water_tank_reserve, has_backup_generator,
            has_3phase_power, primary_image, verification_status, status
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, properties)

    # 4. Seed Vehicles (Ethiopian Automotive Market)
    vehicles = [
        (
            "car-1", "user-agent-3", "Toyota", "Land Cruiser Prado TX-L", 2024, "BRAND_NEW",
            14800000.0, "ETB", 0, "AUTOMATIC", "DIESEL", "2.8L Turbo Diesel", "SUV", "Pearl White",
            "Addis Ababa", "Bole", 1,
            "https://images.unsplash.com/photo-1594502184342-2e12f877aa73?auto=format&fit=crop&w=800&q=80",
            "VERIFIED", "ACTIVE"
        ),
        (
            "car-2", "user-agent-3", "Toyota", "RAV4 Hybrid Limited", 2022, "FOREIGN_USED",
            7400000.0, "ETB", 24000, "AUTOMATIC", "HYBRID", "2.5L Hybrid Dual VVT-i", "SUV", "Silver Metallic",
            "Addis Ababa", "Kirkos", 1,
            "https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?auto=format&fit=crop&w=800&q=80",
            "VERIFIED", "ACTIVE"
        ),
        (
            "car-3", "user-agent-4", "Suzuki", "Dzire GLX Automatic", 2024, "BRAND_NEW",
            3850000.0, "ETB", 0, "AUTOMATIC", "PETROL", "1.2L DualJet", "SEDAN", "Midnight Black",
            "Addis Ababa", "Yeka", 1,
            "https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=800&q=80",
            "VERIFIED", "ACTIVE"
        ),
        (
            "car-4", "user-agent-4", "Hyundai", "Tucson 2.0 Signature", 2021, "ETHIOPIAN_USED",
            5900000.0, "ETB", 38000, "AUTOMATIC", "PETROL", "2.0L MPI Engine", "SUV", "Amazon Gray",
            "Addis Ababa", "Bole", 1,
            "https://images.unsplash.com/photo-1583121274602-3e2820c69888?auto=format&fit=crop&w=800&q=80",
            "VERIFIED", "ACTIVE"
        ),
        (
            "car-5", "user-agent-3", "Mercedes-Benz", "G63 AMG Edition 1", 2023, "BRAND_NEW",
            34000000.0, "ETB", 1200, "AUTOMATIC", "PETROL", "4.0L Bi-Turbo V8", "SUV", "Magno Matte Black",
            "Addis Ababa", "Bole", 1,
            "https://images.unsplash.com/photo-1520031441872-265e4ff70366?auto=format&fit=crop&w=800&q=80",
            "VERIFIED", "ACTIVE"
        )
    ]
    cursor.executemany("""
        INSERT INTO vehicles (
            id, agent_id, make, model, year, condition, price, currency, mileage_km,
            transmission, fuel_type, engine_capacity_cc, body_type, color,
            city, sub_city, customs_cleared, primary_image, verification_status, status
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, vehicles)

    # 5. Seed Simulated Transactions (for Government Auditor Engine)
    transactions = [
        ("tx-1", "user-cust-1", "user-agent-1", "user-agent-1", "PROPERTY", "prop-1", 28500000.0, 570000.0, 57000.0, "COMPLETED"),
        ("tx-2", "user-cust-1", "user-agent-3", "user-agent-3", "VEHICLE", "car-1", 14800000.0, 296000.0, 29600.0, "COMPLETED"),
        ("tx-3", "user-cust-1", "user-agent-4", "user-agent-4", "VEHICLE", "car-3", 3850000.0, 77000.0, 7700.0, "COMPLETED"),
    ]
    cursor.executemany("""
        INSERT INTO transactions (id, buyer_id, seller_id, agent_id, listing_type, listing_id, amount, commission_amount, platform_fee, status)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, transactions)

    # 6. Seed Lead Unlocks (Telebirr records)
    lead_unlocks = [
        ("lead-1", "user-cust-1", "prop-1", "PROPERTY", 20.0, "ETB", "TELEBIRR", "TB-20241109-849102", "user-agent-1"),
        ("lead-2", "user-cust-1", "car-1", "VEHICLE", 20.0, "ETB", "TELEBIRR", "TB-20241110-192841", "user-agent-3")
    ]
    cursor.executemany("""
        INSERT INTO lead_unlocks (id, user_id, listing_id, listing_type, amount, currency, payment_provider, payment_reference, agent_id)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, lead_unlocks)

    conn.commit()
    conn.close()
    print("ALLSELL Database initialized and seeded successfully at:", DB_PATH)

if __name__ == "__main__":
    init_and_seed()

