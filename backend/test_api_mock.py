#!/usr/bin/env python3
"""
ALLSELL In-Memory Handler Unit Test
Directly tests database operations and business logic without opening network sockets.
"""

import unittest
import sqlite3
import os
import json
import uuid

DB_PATH = os.path.join(os.path.dirname(__file__), "allsell.db")

class AllSellDatabaseLogicTestCase(unittest.TestCase):
    def setUp(self):
        self.conn = sqlite3.connect(DB_PATH)
        self.conn.row_factory = sqlite3.Row

    def tearDown(self):
        self.conn.close()

    def test_properties_retrieval_and_join(self):
        cursor = self.conn.cursor()
        cursor.execute("""
            SELECT p.*, a.agency_name, a.tin_number, a.verification_status as agent_verified, u.phone_number as agent_phone, u.full_name as agent_name
            FROM properties p
            JOIN users u ON p.agent_id = u.id
            JOIN agent_profiles a ON u.id = a.user_id
            WHERE p.status = 'ACTIVE'
        """)
        rows = [dict(r) for r in cursor.fetchall()]
        self.assertGreaterEqual(len(rows), 4)
        for r in rows:
            self.assertIsNotNone(r["tin_number"])
            self.assertEqual(r["currency"], "ETB")
            self.assertIn(r["sub_city"], ["Bole", "Yeka", "Nifas Silk", "Kirkos"])

    def test_vehicles_retrieval(self):
        cursor = self.conn.cursor()
        cursor.execute("""
            SELECT v.*, a.agency_name, a.tin_number, u.phone_number as agent_phone
            FROM vehicles v
            JOIN users u ON v.agent_id = u.id
            JOIN agent_profiles a ON u.id = a.user_id
            WHERE v.status = 'ACTIVE'
        """)
        rows = [dict(r) for r in cursor.fetchall()]
        self.assertGreaterEqual(len(rows), 5)
        for r in rows:
            self.assertIn(r["condition"], ["BRAND_NEW", "FOREIGN_USED", "ETHIOPIAN_USED"])
            self.assertGreater(r["price"], 0)

    def test_lead_unlock_logic(self):
        cursor = self.conn.cursor()
        # Find prop-1 agent
        cursor.execute("SELECT agent_id FROM properties WHERE id = 'prop-1'")
        prop = cursor.fetchone()
        self.assertIsNotNone(prop)
        agent_id = prop["agent_id"]

        unlock_id = f"test-unlock-{uuid.uuid4().hex[:6]}"
        cursor.execute("""
            INSERT INTO lead_unlocks (id, user_id, listing_id, listing_type, amount, currency, payment_provider, payment_reference, agent_id)
            VALUES (?, 'user-cust-1', 'prop-1', 'PROPERTY', 20.0, 'ETB', 'TELEBIRR', ?, ?)
        """, (unlock_id, f"TB-{uuid.uuid4().hex[:8]}", agent_id))
        self.conn.commit()

        # Verify insertion
        cursor.execute("SELECT * FROM lead_unlocks WHERE id = ?", (unlock_id,))
        record = cursor.fetchone()
        self.assertIsNotNone(record)
        self.assertEqual(record["amount"], 20.0)

    def test_auditor_calculations(self):
        cursor = self.conn.cursor()
        cursor.execute("SELECT SUM(amount) as gtv, SUM(commission_amount) as commission FROM transactions WHERE status = 'COMPLETED'")
        row = cursor.fetchone()
        gtv = row["gtv"]
        commission = row["commission"]

        self.assertGreater(gtv, 0)
        self.assertGreater(commission, 0)

        # 2% Ethiopian Revenue Authority withholding tax
        withholding = commission * 0.02
        self.assertGreater(withholding, 0)

if __name__ == "__main__":
    unittest.main()

