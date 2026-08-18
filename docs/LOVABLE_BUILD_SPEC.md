# Lovable Build Specification — ESMT Ranking Intelligence Radar

Use this document after the data model and scoring governance have been accepted. It is intentionally explicit so that visual generation does not invent business rules.

## Copy-paste master prompt for Lovable

```text
Build a responsive internal decision-support web app called “ESMT Ranking Intelligence Radar”. It is a prototype and must not imply it is an official ESMT system.

Purpose:
Turn verified ranking, accreditation, publication, submission-window, competitor, and communication-QA signals into an auditable action queue for a business-school Ranking Manager.

Non-negotiable product rule:
Never merge evidence, interpretation, and recommendation. Every signal detail must have three visually distinct sections:
1) Verified fact
2) ESMT interpretation (explicitly labelled as judgement)
3) Proposed action (explicitly labelled as proposed)

Use Supabase with the schema supplied separately. Read the default score from the signal_priority view or the calculate_signal_priority function. Do not reproduce or silently change scoring weights in frontend code.

Pages:
1. Overview
   - KPI cards: Act now, starts in 60 days, unresolved communication QA, unconnected private sources
   - priority distribution
   - upcoming event timeline
   - compact “data limitations” banner
2. Priority Inbox
   - dense sortable table; filters for programme, signal type, priority band, status, owner, publisher
   - columns: score, band, title, type, programme, timing, status, proposed owner
   - saved filter state in URL
3. Signal Detail
   - header with score, band, status, exact date-precision badge
   - separate Fact, Interpretation, Proposed Action panels
   - evidence list with source authority, access mode, verification status, last checked, and external link
   - scoring breakdown bar chart
   - activity/audit timeline
   - reviewer actions: assign, change status, override score with mandatory reason, add note
4. Source Health
   - source table with access mode, cadence, last successful check, hash-change candidate, error state
   - private/manual sources must show “Not connected” and may never be fetched from the public client
5. Communication QA
   - unresolved mismatches, affected pages, publisher evidence, proposed correction, owner, due date
6. Settings / Governance
   - read-only scoring weights for normal users
   - admin versioning workflow for weights and bands
   - status definitions and data-retention notice

Visual direction:
Serious editorial intelligence product, not a marketing dashboard. Off-white canvas (#F6F4EF), near-black text (#101723), restrained cobalt (#165DFF) for verified/interactive states, amber (#C47B13) for judgement, red (#BA3A3A) only for overdue/errors, soft grey borders. Use Inter or a similar neutral sans serif. Compact 12-column desktop grid, generous detail-page whitespace, 8px spacing system, 12px card radius. Avoid gradients, glassmorphism, decorative AI imagery, excessive shadows, and gamified score rings.

Accessibility:
WCAG AA contrast, keyboard navigable controls, visible focus, semantic table markup, icons always paired with text, do not communicate priority by colour alone.

Data rules:
- A source with access_mode=manual_private is never fetched or exposed through unauthenticated endpoints.
- Show official_date_text and date_precision together.
- If date_precision is month/approximate/year, do not format it as an exact official day.
- proposed_due_date must be labelled “Internal proposed due date”.
- source facts can be verified; interpretation and action are always human judgement.
- all mutations create audit_events with actor, before, after, timestamp, and reason where required.
- score override requires a reason and keeps the calculated score visible.

Roles:
- viewer: read verified signals and public-source metadata
- reviewer: comment, assign, change workflow status
- admin: manage sources, scoring versions, and overrides
Use Supabase Auth and RLS. No anonymous write access.

Seed data:
Import data/raw/sources.json and data/processed/signals_enriched.json. Keep manual/private sources as disabled. Preserve source_ids and signal_ids as external keys.

Empty/error states:
- no matching signals: explain active filters and provide reset
- source fetch failure: preserve last successful snapshot and show stale status
- no evidence: block “Verified” status
- private source: show connection instructions, never a fake success state

Acceptance tests:
- score and band match the supplied processed seed for every record
- fact/judgement/action panels are separately labelled on desktop and mobile
- a month-only QS date never appears as an exact official publication day
- score override cannot save without a reason
- a manual_private source cannot be enabled for browser-side HTTP collection
- closing a communication QA signal requires a resolution note and evidence link
- all table filters work together and survive refresh through URL state
```

## Information architecture

| Route | Primary user question | Main objects |
|---|---|---|
| `/overview` | What needs attention now? | Signal, priority view, event window |
| `/signals` | Which records match my responsibility? | Signal, programme, status, owner |
| `/signals/:id` | What is proven, inferred, and proposed? | Signal, evidence, sources, audit |
| `/sources` | Where are monitoring gaps or failures? | Source, snapshot, access mode |
| `/communication-qa` | Which public claims are inconsistent? | Signal subtype, affected URL, correction |
| `/governance` | How is priority and access controlled? | Scoring version, role, retention |

## Components

- `PriorityBadge`: text + restrained colour; never colour-only.
- `DatePrecisionBadge`: exact, provisional, month, approximate window, year, observation date.
- `EvidencePanel`: fact and source lineage only.
- `JudgementPanel`: amber treatment and judgement label.
- `ActionPanel`: proposed owner/due date and workflow controls.
- `ScoreBreakdown`: five contributions and current weight version.
- `SourceHealthRow`: enabled, access mode, freshness, last error, last hash.
- `AuditTimeline`: immutable event stream.
- `LimitationBanner`: visible whenever private coverage is missing.

## Recommended build sequence

1. Create Supabase project, apply `sql/supabase_schema.sql`, configure Auth and replace the placeholder RLS policies with approved ESMT role claims.
2. Run `python scripts/generate_supabase_seed.py`, inspect `sql/seed_generated.sql`, and apply it server-side.
3. Implement read-only Overview, Inbox, Detail, and Source Health.
4. Add reviewer mutations and audit events.
5. Add communication-QA resolution workflow.
6. Add score override with mandatory reason.
7. Add source-snapshot ingestion through a protected server function; never from the browser.
8. Run the acceptance tests above before visual refinement.

## What not to send to Lovable

- Participant-portal credentials or copied private guidance.
- Personal data, salary microdata, survey contacts, or student/alumni records.
- Raw publisher exports unless licence and project privacy are confirmed.
- Production secrets in prompt text or frontend environment variables.
