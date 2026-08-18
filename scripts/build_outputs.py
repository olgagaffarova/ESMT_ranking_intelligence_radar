"""Validate raw records and create deterministic processed outputs."""

from __future__ import annotations

import csv
import json
import sys
from datetime import date
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from src.scoring import calculate_priority  # noqa: E402


AS_OF_DATE = date(2026, 8, 18)
ALLOWED_DATE_PRECISION = {
    "exact",
    "exact_provisional",
    "month",
    "approximate_window",
    "year",
    "observation_date",
    "publication_month_assumption",
    "month_not_verified_in_seed",
}


def load_json(path: Path) -> Any:
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def validate_records(sources: list[dict[str, Any]], signals: list[dict[str, Any]]) -> None:
    source_ids = [source["source_id"] for source in sources]
    signal_ids = [signal["signal_id"] for signal in signals]
    if len(source_ids) != len(set(source_ids)):
        raise ValueError("Duplicate source_id detected")
    if len(signal_ids) != len(set(signal_ids)):
        raise ValueError("Duplicate signal_id detected")

    source_set = set(source_ids)
    for signal in signals:
        required = {
            "factual_summary",
            "verification_status",
            "source_ids",
            "esmt_interpretation",
            "recommended_action",
            "score_inputs",
        }
        missing = required - set(signal)
        if missing:
            raise ValueError(f"{signal['signal_id']} is missing {sorted(missing)}")
        unknown_sources = set(signal["source_ids"]) - source_set
        if unknown_sources:
            raise ValueError(f"{signal['signal_id']} references unknown sources {unknown_sources}")
        if signal["date_precision"] not in ALLOWED_DATE_PRECISION:
            raise ValueError(f"Unsupported date_precision on {signal['signal_id']}")
        start = date.fromisoformat(signal["event_date_start"])
        end = date.fromisoformat(signal["event_date_end"])
        if end < start:
            raise ValueError(f"End date precedes start date on {signal['signal_id']}")
        if signal["date_precision"] in {"month", "approximate_window", "publication_month_assumption"}:
            if start.day != 1:
                raise ValueError(f"Approximate/month start must be the first day on {signal['signal_id']}")


def enrich(signal: dict[str, Any], source_by_id: dict[str, dict[str, Any]]) -> dict[str, Any]:
    result = dict(signal)
    start = date.fromisoformat(signal["event_date_start"])
    end = date.fromisoformat(signal["event_date_end"])
    score_result = calculate_priority(signal["score_inputs"])
    result["priority_score"] = score_result.score
    result["priority_band"] = score_result.band
    result["score_contributions"] = score_result.weighted_contributions
    result["days_to_window_start_as_of_2026_08_18"] = (start - AS_OF_DATE).days
    result["days_to_window_end_as_of_2026_08_18"] = (end - AS_OF_DATE).days
    result["sources"] = [
        {
            "source_id": source_id,
            "name": source_by_id[source_id]["name"],
            "url": source_by_id[source_id].get("canonical_url"),
            "evidence_type": source_by_id[source_id]["evidence_type"],
            "access_mode": source_by_id[source_id]["access_mode"],
        }
        for source_id in signal["source_ids"]
    ]
    return result


def main() -> None:
    sources = load_json(ROOT / "data/raw/sources.json")
    signals = load_json(ROOT / "data/raw/signals.json")
    validate_records(sources, signals)
    source_by_id = {source["source_id"]: source for source in sources}
    enriched = [enrich(signal, source_by_id) for signal in signals]
    enriched.sort(key=lambda item: (-item["priority_score"], item["event_date_start"], item["signal_id"]))

    processed_dir = ROOT / "data/processed"
    processed_dir.mkdir(parents=True, exist_ok=True)
    with (processed_dir / "signals_enriched.json").open("w", encoding="utf-8") as handle:
        json.dump(enriched, handle, indent=2, ensure_ascii=False)
        handle.write("\n")

    csv_fields = [
        "signal_id",
        "title",
        "signal_type",
        "ranking_or_standard",
        "priority_score",
        "priority_band",
        "status",
        "event_date_start",
        "event_date_end",
        "date_precision",
        "proposed_owner",
        "proposed_due_date",
        "verification_status",
    ]
    with (processed_dir / "signals_summary.csv").open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=csv_fields)
        writer.writeheader()
        for signal in enriched:
            writer.writerow({key: signal.get(key) for key in csv_fields})

    print(f"Validated {len(sources)} sources and built {len(enriched)} signals as of {AS_OF_DATE}.")


if __name__ == "__main__":
    main()

