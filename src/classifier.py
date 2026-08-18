"""Rule-based signal suggestions.

These rules reduce triage work but never publish a classification. A page
change can reflect navigation, cookies, or copy-editing, so all suggestions
carry a human-review requirement.
"""

from __future__ import annotations

from dataclasses import dataclass


TYPE_RULES = {
    "submission_window": ("deadline", "submission", "data collection", "movein", "questionnaire"),
    "methodology_change": ("methodology", "weight", "indicator", "journal list", "ft50"),
    "accreditation_standard": ("standard", "accreditation", "aacsb", "equis", "amba"),
    "ranking_result": ("ranking", "ranked", "results", "position"),
    "publication_window": ("publication", "publish", "release", "calendar"),
}

PROGRAMME_RULES = {
    "Full-time MBA": ("full-time mba", "global mba"),
    "Executive MBA": ("executive mba", "emba"),
    "Part-time Blended MBA": ("online mba", "part-time mba", "blended mba"),
    "Master in Global Management": ("masters in management", "master in management", "mim"),
    "Executive Education": ("executive education", "customised", "open-enrolment"),
}


@dataclass(frozen=True)
class ClassificationSuggestion:
    signal_type: str
    programmes: list[str]
    matched_terms: list[str]
    requires_human_review: bool = True


def suggest_classification(title: str, body: str) -> ClassificationSuggestion:
    """Return deterministic suggestions for a changed-source candidate."""
    text = f"{title} {body}".casefold()
    type_matches: list[tuple[str, list[str]]] = []
    all_matches: list[str] = []

    for signal_type, terms in TYPE_RULES.items():
        matches = [term for term in terms if term in text]
        if matches:
            type_matches.append((signal_type, matches))
            all_matches.extend(matches)

    signal_type = type_matches[0][0] if type_matches else "unclassified"
    programmes = []
    for programme, terms in PROGRAMME_RULES.items():
        matches = [term for term in terms if term in text]
        if matches:
            programmes.append(programme)
            all_matches.extend(matches)

    return ClassificationSuggestion(
        signal_type=signal_type,
        programmes=programmes or ["Institution-wide"],
        matched_terms=sorted(set(all_matches)),
    )

