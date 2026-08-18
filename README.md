# ESMT Ranking Intelligence Radar

An auditable prototype for monitoring ranking, accreditation, publication, and communication signals that may require action from ESMT Berlin.

The product is deliberately narrower than a general business-school news feed. It is designed around a Ranking Manager's operating questions:

1. What changed or is approaching?
2. Is the claim supported by an official source?
3. Which ESMT programme or process is exposed?
4. What action should be considered, by when, and by whom?
5. Which parts are facts and which parts are management judgement?

## What is included

- A registry of public sources and explicit manual/private-source placeholders.
- A curated, reproducible seed dataset based on official publisher, accreditor, ESMT, and uploaded ranking-result files.
- Deterministic scoring and rule-based classification; no LLM is required.
- A Streamlit prototype with an inbox, signal detail, source health, and communication QA.
- A reproducible notebook for the QS trend analysis.
- An audit workbook for non-technical review.
- A Lovable + Supabase implementation specification and SQL schema.
- Tests for scoring, evidence, date precision, and ID integrity.

## Critical boundary

This prototype is **not** a production ranking-submission system. Public web monitoring cannot see FT participant portals, QS MoveIN, accreditor portals, internal calendars, CRM data, or publisher emails. Those sources are represented as manual/private placeholders and must be connected under ESMT's access, retention, and confidentiality rules.

An observed page change is not automatically a methodology change. The collector only creates a review candidate. A Ranking Manager must verify and classify it.

## Evidence model

Every signal separates three layers:

| Layer | Meaning | Governance |
|---|---|---|
| `factual_summary` | What the official source or uploaded publisher export supports | Must have a source and verification status |
| `esmt_interpretation` | Why the fact could matter to ESMT | Explicitly labelled as interpretation |
| `recommended_action` | A proposed operational response | Human-owned proposal, not an official deadline |

Dates also preserve precision. If a publisher says only “September 2026”, the system stores a month window rather than inventing an exact publication day.

## Priority score

The default score is a configurable management rule, not a statistical forecast:

```text
score = (impact*30 + urgency*25 + actionability*20 + relevance*15 + confidence*10) / 5
```

Each dimension is 0–5. Bands are:

- 75–100: Act now
- 55–74: Plan
- 35–54: Monitor
- 0–34: Archive

## Quick start

```bash
python scripts/build_outputs.py
python -m unittest discover -s tests -v
streamlit run app.py
```

The seed analysis uses a fixed as-of date of `2026-08-18` for reproducibility. The app defaults to today's date when deriving live days-to-event values.

## Repository map

```text
app.py                         Streamlit prototype
config/scoring.json            Transparent scoring governance
data/raw/sources.json          Source registry
data/raw/signals.json          Curated facts, interpretations, and actions
data/processed/                Deterministic build outputs
docs/PROJECT_WALKTHROUGH.md    Detailed end-to-end process and decisions
docs/LOVABLE_BUILD_SPEC.md     Product/UI hand-off
notebooks/                     Reproducible QS analysis
scripts/build_outputs.py       Validation and enrichment pipeline
sql/supabase_schema.sql        Production-ready relational starting point
src/collector.py               Public-page snapshot and change detection
src/classifier.py              Review-only rule suggestions
src/scoring.py                 Priority calculation
tests/                         Governance and data-quality checks
```

## Data-use notes

- Only official/public pages and the supplied official publisher exports are used for factual seed signals.
- The supplied QS and FT workbooks are inputs for this demonstration but are not duplicated in the project bundle. Before extraction or redistribution, confirm the publisher's licence and ESMT's usage rights; see `inputs/README.md`.
- Do not put private participant-portal content, personal data, salaries, survey contacts, or credentials into a public Lovable project.
- Production should retain source snapshots, change hashes, reviewer identity, and every status/score override.
