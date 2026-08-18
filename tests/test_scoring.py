import unittest

from src.scoring import calculate_priority, priority_band


class ScoringTests(unittest.TestCase):
    def test_score_formula_and_contributions(self):
        result = calculate_priority(
            {
                "strategic_impact": 4,
                "urgency": 4,
                "actionability": 4,
                "esmt_relevance": 4,
                "evidence_confidence": 5,
            }
        )
        self.assertEqual(result.score, 82.0)
        self.assertEqual(result.band, "Act now")
        self.assertEqual(sum(result.weighted_contributions.values()), 82.0)

    def test_priority_band_boundaries(self):
        self.assertEqual(priority_band(75), "Act now")
        self.assertEqual(priority_band(74.9), "Plan")
        self.assertEqual(priority_band(55), "Plan")
        self.assertEqual(priority_band(35), "Monitor")
        self.assertEqual(priority_band(34.9), "Archive")

    def test_rejects_out_of_range_dimension(self):
        dimensions = {
            "strategic_impact": 6,
            "urgency": 4,
            "actionability": 4,
            "esmt_relevance": 4,
            "evidence_confidence": 4,
        }
        with self.assertRaisesRegex(ValueError, "between 0 and 5"):
            calculate_priority(dimensions)


if __name__ == "__main__":
    unittest.main()
