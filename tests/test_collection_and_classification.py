import unittest

from src.classifier import suggest_classification
from src.collector import fetch_public_source, normalize_html


class CollectionAndClassificationTests(unittest.TestCase):
    def test_classifier_is_explicitly_review_only(self):
        suggestion = suggest_classification(
            "QS Online MBA data collection deadline",
            "The questionnaire will be available in MoveIN.",
        )
        self.assertEqual(suggestion.signal_type, "submission_window")
        self.assertIn("Part-time Blended MBA", suggestion.programmes)
        self.assertTrue(suggestion.requires_human_review)

    def test_html_normalisation_removes_navigation_and_scripts(self):
        html = "<html><body><nav>Menu</nav><main><h1>Methodology update</h1><p>Weight changed.</p></main><script>noise</script></body></html>"
        self.assertEqual(normalize_html(html), "Methodology update Weight changed.")

    def test_private_source_cannot_be_fetched(self):
        source = {
            "source_id": "private",
            "access_mode": "manual_private",
            "enabled": False,
            "canonical_url": None,
        }
        with self.assertRaisesRegex(ValueError, "not approved for public HTTP"):
            fetch_public_source(source)


if __name__ == "__main__":
    unittest.main()
