# Project Walkthrough: From Ranking Noise to an Auditable Action Queue

This document explains the prototype as an operating design, not as a polished product story. It records what was done, why, what can fail, and what a production owner would have to decide.

## 1. Define the job before selecting technology

The Ranking Manager job description requires accurate and ethical data work, process automation, competitive analysis, ranking strategy, communication, and predictive analysis. A generic “business-school news feed” would cover only a small part of that scope and could create more noise.

The prototype therefore focuses on one bounded job: **turn official external ranking and accreditation signals into a verified, prioritised, reviewable action queue**.

It does not attempt to replace submission portals, internal data governance, or the human interpretation of methodology.

**Failure condition:** success measured by number of scraped articles rather than decisions supported.

## 2. Establish a source policy

The source registry uses four evidence categories:

1. Ranking-publisher rules, schedules, and results.
2. Accreditor standards and announcements.
3. Official ESMT website claims for communication QA.
4. Uploaded official result exports for reproducible component analysis.

Private sources are represented, but disabled: FT participant communications, QS MoveIN, and ESMT internal data/evidence systems.

**Decision:** a strong primary source can verify a fact even if only one organisation can authoritatively publish it. “Independent confirmation count” is still stored, but source count is not confused with truth.

**Failure condition:** presenting a school press release or secondary article as the methodology authority.

## 3. Preserve date precision

Ranking schedules often use exact dates, months, or approximate windows. The data model stores:

- window start and end for filtering;
- a `date_precision` label;
- the publisher's timing in `official_date_text`;
- any operational assumption used to create sortable boundaries.

For example, “October 2026 to mid-January 2027” is stored as an approximate window. The derived 1 October and 15 January boundaries are explicitly labelled as assumptions and must not be republished as official deadlines.

**Failure condition:** turning a publication month into an invented exact day.

## 4. Separate fact, interpretation, and action

Each record has three distinct layers:

- `factual_summary`: what the evidence supports;
- `esmt_interpretation`: a management inference;
- `recommended_action`: a proposal, with proposed owner and internal due date.

This separation matters because a correct fact can still lead to a weak interpretation, and a useful action can still be mistimed. Reviewers need to challenge each layer independently.

**Failure condition:** an AI-generated paragraph that mixes evidence and recommendation so thoroughly that neither can be audited.

## 5. Build a curated seed before automating collection

Eighteen seed signals were created from official sources and the supplied exports. They cover:

- upcoming FT and QS publication windows;
- upcoming QS collection windows;
- FT50 methodology exposure;
- AACSB and EQUIS standards;
- QS component and peer movement;
- current ESMT website inconsistencies;
- major published ESMT result claims.

This seed is intentionally small. It tests the full data contract before web change detection adds volume.

**Failure condition:** automating 100 sources before the team agrees what a valid signal looks like.

## 6. Add conservative change detection

`src/collector.py` retrieves only registry entries marked `public_http`, removes high-noise page elements, normalises text, and computes a SHA-256 hash.

A hash difference creates a **review candidate**, not a methodology-change signal. Navigation updates, cookie text, and page redesigns can change a hash without changing a ranking rule.

Production would require:

- terms/robots review;
- publisher-specific extraction rules;
- respectful rate limits and retries;
- encrypted snapshot storage;
- diff views;
- source-health alerts;
- reviewer approval before signal publication.

**Failure condition:** treating a changed webpage as a verified substantive change.

## 7. Use rule-based classification only as a suggestion

`src/classifier.py` maps transparent keywords to candidate types and programme tags. The output always carries `requires_human_review=True`.

This is cheaper and more auditable than an LLM for the first triage pass. It will also miss synonyms and context; that limitation is preferable to hiding uncertainty behind a fluent label.

**Failure condition:** using a keyword or model label as final governance without review.

## 8. Apply a transparent priority rule

Five dimensions are scored from 0 to 5:

| Dimension | Weight | Question |
|---|---:|---|
| Strategic impact | 30% | Could this materially affect eligibility, position, accreditation, or trust? |
| Urgency | 25% | How soon does the response window start or close? |
| Actionability | 20% | Can ESMT take a concrete action? |
| ESMT relevance | 15% | Is the affected programme/process material to ESMT? |
| Evidence confidence | 10% | How strong and precise is the evidence? |

The weights are management assumptions. In production they need an owner, version history, override reason, and periodic back-testing against actual actions.

**Failure condition:** calling the score an objective measure of importance or a prediction of rank movement.

## 9. Analyse ranking results at component and peer level

The QS export analysis produces two examples of why raw rank movement is insufficient:

- Global MBA: ESMT moved from 78 to 84 and its score fell 1.0. The largest component declines were Entrepreneurship & Alumni Outcomes (-5.4) and Employability (-2.1); selected German peers were broadly stable.
- Management: ESMT moved from 75 to 100 while its score fell only 0.9. This makes score density and competitor movement essential context. The largest component decline was Value for Money (-4.6).

These are descriptive findings. They do not prove which underlying input caused the change.

**Failure condition:** attributing causality from published output scores alone.

## 10. Add communication QA as a first-class signal

Two current mismatches demonstrate a practical use case:

- rank 79 in FT MBA is labelled 2026 on the degree page but 2025 on the central page;
- FT EMBA rank 42 is a 2025 result but is labelled 2026 on the central page.

The proposed control is a structured claim register containing publisher, edition, programme, result, geography, approved wording, source URL, validation date, owner, and expiry/review date. Public pages should consume or be checked against that register.

**Failure condition:** correcting pages individually without fixing the duplicated-data process.

## 11. Expose the work in two review surfaces

The Streamlit prototype is for interactive triage. The audit workbook is for management, hand-off, and evidence review. Both use the same processed records.

The four interface areas are:

1. Priority Inbox
2. Signal Detail
3. Source Health
4. Communication QA

No edit workflow is implemented in Streamlit; production edits belong in a database with role-based access and history.

**Failure condition:** letting a dashboard become an unaudited source of truth.

## 12. Prepare for Lovable without coupling the logic to the UI

The Lovable specification defines the information architecture, design system, Supabase tables, row-level security expectations, and acceptance criteria. The data and scoring logic remain portable.

This prevents visual prototyping from deciding the governance model by accident.

**Failure condition:** building attractive cards before deciding evidence, date precision, ownership, and status semantics.

## 13. Validate before hand-off

The build step checks:

- unique source and signal IDs;
- valid source references;
- mandatory evidence, interpretation, and action fields;
- date ordering and precision rules;
- score input keys and 0–5 bounds.

The project also tests that private/manual sources are disabled for automated collection.

**Failure condition:** a visually plausible dashboard backed by broken joins or undocumented date assumptions.

## 14. Production decisions still required

Before ESMT could adopt this concept, responsible owners must decide:

- which rankings and programmes are in scope;
- source licences and permitted archiving;
- who can see submission and personal data;
- who approves signals, scores, and public claims;
- official internal deadlines and escalation paths;
- how snapshots and evidence are retained;
- whether public-page monitoring is legally and technically permitted per source;
- how model assumptions are validated if predictive analytics is added.

The prototype demonstrates operating logic. It does not answer those governance questions on ESMT's behalf.

