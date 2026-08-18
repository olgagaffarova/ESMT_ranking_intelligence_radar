"""Generate idempotent Supabase/Postgres seed SQL from the curated JSON.

Run after `python scripts/build_outputs.py`. The generated file contains no
credentials and deliberately keeps manual/private collection disabled.
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]


def load_json(path: Path) -> Any:
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def sql_text(value: str | None) -> str:
    if value is None:
        return "null"
    return "'" + value.replace("'", "''") + "'"


def sql_bool(value: bool) -> str:
    return "true" if value else "false"


def sql_date(value: str | None) -> str:
    return f"{sql_text(value)}::date" if value else "null"


def sql_array(values: list[str]) -> str:
    return "array[" + ", ".join(sql_text(value) for value in values) + "]::text[]"


def source_insert(source: dict[str, Any]) -> str:
    columns = (
        "external_source_id, name, publisher, canonical_url, source_family, evidence_type, "
        "access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat"
    )
    values = ", ".join(
        [
            sql_text(source["source_id"]),
            sql_text(source["name"]),
            sql_text(source["publisher"]),
            sql_text(source.get("canonical_url")),
            sql_text(source["source_family"]),
            sql_text(source["evidence_type"]),
            f"{sql_text(source['access_mode'])}::source_access_mode",
            sql_text(source["monitor_cadence"]),
            str(source["authority_score"]),
            sql_bool(source["enabled"] and source["access_mode"] == "public_http"),
            f"{sql_text(source.get('checked_at'))}::timestamptz" if source.get("checked_at") else "null",
            sql_text(source.get("caveat")),
        ]
    )
    return (
        f"insert into public.sources ({columns}) values ({values})\n"
        "on conflict (external_source_id) do update set\n"
        "  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,\n"
        "  source_family = excluded.source_family, evidence_type = excluded.evidence_type,\n"
        "  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,\n"
        "  authority_score = excluded.authority_score,\n"
        "  automated_collection_enabled = excluded.automated_collection_enabled,\n"
        "  checked_at = excluded.checked_at, caveat = excluded.caveat;"
    )


def signal_insert(signal: dict[str, Any]) -> str:
    score = signal["score_inputs"]
    columns = (
        "external_signal_id, title, signal_type, programmes, ranking_or_standard, observed_at, "
        "event_date_start, event_date_end, date_precision, official_date_text, date_assumption, "
        "factual_summary, verification_status, independent_confirmation_count, esmt_interpretation, "
        "recommended_action, proposed_owner, proposed_due_date, status, strategic_impact, urgency, "
        "actionability, esmt_relevance, evidence_confidence"
    )
    values = ", ".join(
        [
            sql_text(signal["signal_id"]),
            sql_text(signal["title"]),
            sql_text(signal["signal_type"]),
            sql_array(signal["programmes"]),
            sql_text(signal["ranking_or_standard"]),
            sql_date(signal["observed_at"]),
            sql_date(signal["event_date_start"]),
            sql_date(signal["event_date_end"]),
            sql_text(signal["date_precision"]),
            sql_text(signal["official_date_text"]),
            sql_text(signal.get("date_assumption")),
            sql_text(signal["factual_summary"]),
            sql_text(signal["verification_status"]),
            str(signal["independent_confirmation_count"]),
            sql_text(signal["esmt_interpretation"]),
            sql_text(signal["recommended_action"]),
            sql_text(signal["proposed_owner"]),
            sql_date(signal["proposed_due_date"]),
            f"{sql_text(signal['status'])}::workflow_status",
            str(score["strategic_impact"]),
            str(score["urgency"]),
            str(score["actionability"]),
            str(score["esmt_relevance"]),
            str(score["evidence_confidence"]),
        ]
    )
    return (
        f"insert into public.signals ({columns}) values ({values})\n"
        "on conflict (external_signal_id) do update set\n"
        "  title = excluded.title, signal_type = excluded.signal_type, programmes = excluded.programmes,\n"
        "  ranking_or_standard = excluded.ranking_or_standard, observed_at = excluded.observed_at,\n"
        "  event_date_start = excluded.event_date_start, event_date_end = excluded.event_date_end,\n"
        "  date_precision = excluded.date_precision, official_date_text = excluded.official_date_text,\n"
        "  date_assumption = excluded.date_assumption, factual_summary = excluded.factual_summary,\n"
        "  verification_status = excluded.verification_status,\n"
        "  independent_confirmation_count = excluded.independent_confirmation_count,\n"
        "  esmt_interpretation = excluded.esmt_interpretation, recommended_action = excluded.recommended_action,\n"
        "  proposed_owner = excluded.proposed_owner, proposed_due_date = excluded.proposed_due_date,\n"
        "  status = excluded.status, strategic_impact = excluded.strategic_impact, urgency = excluded.urgency,\n"
        "  actionability = excluded.actionability, esmt_relevance = excluded.esmt_relevance,\n"
        "  evidence_confidence = excluded.evidence_confidence;"
    )


def link_insert(signal_id: str, source_id: str) -> str:
    return (
        "insert into public.signal_sources (signal_id, source_id)\n"
        f"select s.id, src.id from public.signals s join public.sources src on src.external_source_id = {sql_text(source_id)}\n"
        f"where s.external_signal_id = {sql_text(signal_id)}\n"
        "on conflict (signal_id, source_id) do nothing;"
    )


def main() -> None:
    sources = load_json(ROOT / "data/raw/sources.json")
    signals = load_json(ROOT / "data/raw/signals.json")
    statements = [
        "-- Generated from curated prototype JSON. Apply after supabase_schema.sql.",
        "begin;",
        *[source_insert(source) for source in sources],
        *[signal_insert(signal) for signal in signals],
        *[
            link_insert(signal["signal_id"], source_id)
            for signal in signals
            for source_id in signal["source_ids"]
        ],
        "commit;",
        "",
    ]
    output = ROOT / "sql/seed_generated.sql"
    output.write_text("\n\n".join(statements), encoding="utf-8")
    print(f"Generated {output} with {len(sources)} sources and {len(signals)} signals.")


if __name__ == "__main__":
    main()
