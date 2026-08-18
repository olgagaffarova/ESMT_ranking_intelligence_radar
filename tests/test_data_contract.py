import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def load(name):
    with (ROOT / name).open(encoding="utf-8") as handle:
        return json.load(handle)


class DataContractTests(unittest.TestCase):
    def test_all_signals_have_evidence_and_separate_judgement(self):
        signals = load("data/raw/signals.json")
        for signal in signals:
            self.assertTrue(signal["source_ids"])
            self.assertTrue(signal["factual_summary"].strip())
            self.assertTrue(signal["verification_status"].strip())
            self.assertTrue(signal["esmt_interpretation"].strip())
            self.assertTrue(signal["recommended_action"].strip())

    def test_ids_are_unique_and_references_resolve(self):
        sources = load("data/raw/sources.json")
        signals = load("data/raw/signals.json")
        source_ids = [source["source_id"] for source in sources]
        signal_ids = [signal["signal_id"] for signal in signals]
        self.assertEqual(len(source_ids), len(set(source_ids)))
        self.assertEqual(len(signal_ids), len(set(signal_ids)))
        known = set(source_ids)
        for signal in signals:
            self.assertLessEqual(set(signal["source_ids"]), known)

    def test_private_sources_are_not_enabled_for_collection(self):
        sources = load("data/raw/sources.json")
        for source in sources:
            if source["access_mode"] == "manual_private":
                self.assertFalse(source["enabled"])


if __name__ == "__main__":
    unittest.main()
