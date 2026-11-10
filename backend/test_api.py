#!/usr/bin/env python3
"""
ALLSELL Backend API Integration Test
Tests all endpoints against allsell.db:
- Health check
- Properties list & detail
- Vehicles list & detail
- Telebirr Contact Reveal micro-transaction
- Agent KYC registration
- Government Auditor KPIs & Tax calculation
"""

import unittest
import urllib.request
import urllib.error
import json
import threading
import time
from server import run_server

TEST_PORT = 8999
BASE_URL = f"http://127.0.0.1:{TEST_PORT}"

class AllSellAPITestCase(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # Start server in background thread
        cls.server_thread = threading.Thread(target=run_server, args=(TEST_PORT,), daemon=True)
        cls.server_thread.start()
        time.sleep(0.6) # allow server to bind

    def _get(self, path):
        req = urllib.request.Request(f"{BASE_URL}{path}", headers={"Content-Type": "application/json"})
        with urllib.request.urlopen(req) as resp:
            return json.loads(resp.read().decode("utf-8"))

    def _post(self, path, data):
        req = urllib.request.Request(
            f"{BASE_URL}{path}",
            data=json.dumps(data).encode("utf-8"),
            headers={"Content-Type": "application/json"}
        )
        with urllib.request.urlopen(req) as resp:
            return json.loads(resp.read().decode("utf-8"))

    def test_01_health(self):
        res = self._get("/api/health")
        self.assertEqual(res["status"], "online")
        self.assertEqual(res["platform"], "ALLSELL Ethiopia")

    def test_02_properties_list(self):
        res = self._get("/api/properties")
        self.assertTrue(res["success"])
        self.assertGreaterEqual(res["count"], 1)
        first = res["data"][0]
        self.assertIn("title", first)
        self.assertIn("price", first)
        self.assertIn("tin_number", first) # Broker TIN joined

    def test_03_properties_subcity_filter(self):
        res = self._get("/api/properties?sub_city=Bole")
        self.assertTrue(res["success"])
        for p in res["data"]:
            self.assertEqual(p["sub_city"].lower(), "bole")

    def test_04_vehicles_list(self):
        res = self._get("/api/vehicles")
        self.assertTrue(res["success"])
        self.assertGreaterEqual(res["count"], 1)
        first = res["data"][0]
        self.assertIn("make", first)
        self.assertIn("model", first)
        self.assertIn("condition", first)

    def test_05_telebirr_lead_unlock(self):
        payload = {
            "listing_id": "prop-1",
            "listing_type": "PROPERTY",
            "provider": "TELEBIRR"
        }
        res = self._post("/api/leads/unlock", payload)
        self.assertTrue(res["success"])
        self.assertIn("TB-", res["payment_reference"])
        self.assertIn("phone_number", res["unlocked_contact"])
        self.assertEqual(res["unlocked_contact"]["phone_number"], "+251911428890")

    def test_06_auditor_kpis(self):
        res = self._get("/api/auditor/kpis")
        self.assertTrue(res["success"])
        metrics = res["metrics"]
        self.assertIn("gross_transaction_volume", metrics)
        self.assertIn("verified_brokers_count", metrics)
        self.assertIn("estimated_withholding_tax_2pct", metrics)
        self.assertGreater(metrics["gross_transaction_volume"], 0)

    def test_07_agent_kyc_submission(self):
        payload = {
            "full_name": "Kidus Hailu",
            "phone_number": "+251911887766",
            "tin_number": "0099887766",
            "agency_name": "Kidus Properties",
            "national_id_number": "ET-FAN-112233"
        }
        res = self._post("/api/agents/kyc", payload)
        self.assertTrue(res["success"])
        self.assertEqual(res["status"], "PENDING")

if __name__ == "__main__":
    unittest.main()

