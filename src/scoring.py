"""Transparent, deterministic priority scoring.

This is a governance rule, not a predictive model. Every input should be
reviewable and overridable by an authorised human with an audit comment.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Mapping


DEFAULT_WEIGHTS = {
    "strategic_impact": 30,
    "urgency": 25,
    "actionability": 20,
    "esmt_relevance": 15,
    "evidence_confidence": 10,
}


@dataclass(frozen=True)
class ScoreResult:
    score: float
    band: str
    weighted_contributions: dict[str, float]


def priority_band(score: float) -> str:
    """Map a 0-100 score to the prototype priority band."""
    if score >= 75:
        return "Act now"
    if score >= 55:
        return "Plan"
    if score >= 35:
        return "Monitor"
    return "Archive"


def calculate_priority(
    dimensions: Mapping[str, int | float],
    weights: Mapping[str, int | float] | None = None,
) -> ScoreResult:
    """Calculate the weighted 0-100 priority score.

    Dimension values must be between 0 and 5. Weights must be positive and
    total 100 so that the result remains directly interpretable.
    """
    active_weights = dict(weights or DEFAULT_WEIGHTS)
    missing = set(active_weights) - set(dimensions)
    extra = set(dimensions) - set(active_weights)
    if missing or extra:
        raise ValueError(f"Scoring keys mismatch. Missing={missing}; extra={extra}")
    if round(sum(active_weights.values()), 8) != 100:
        raise ValueError("Scoring weights must total 100.")

    contributions: dict[str, float] = {}
    for key, weight in active_weights.items():
        value = float(dimensions[key])
        if not 0 <= value <= 5:
            raise ValueError(f"{key} must be between 0 and 5; received {value}")
        contributions[key] = value * float(weight) / 5

    score = round(sum(contributions.values()), 1)
    return ScoreResult(
        score=score,
        band=priority_band(score),
        weighted_contributions={key: round(value, 1) for key, value in contributions.items()},
    )

