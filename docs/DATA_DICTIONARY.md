# Data Dictionary

## Signal record

| Field | Type | Meaning / control |
|---|---|---|
| `signal_id` | string | Stable external key; unique and immutable |
| `title` | string | Short human-readable signal title |
| `signal_type` | enum-like string | `publication_window`, `submission_window`, `methodology_change`, `accreditation_standard`, `competitive_shift`, `ranking_result`, or `communication_mismatch` |
| `programmes` | string array | Affected programme(s) or `Institution-wide` |
| `ranking_or_standard` | string | Named ranking, cycle, or standard |
| `observed_at` | date | Date on which the prototype verified the record |
| `event_date_start` | date | Sort/filter boundary for the event window |
| `event_date_end` | date | Sort/filter boundary for the event window |
| `date_precision` | enum-like string | Exactness/governance label; must be displayed with the date |
| `official_date_text` | string | Publisher-supported date wording, paraphrased where necessary |
| `date_assumption` | nullable string | Explains a sorting boundary not supplied as an exact official date |
| `factual_summary` | string | Evidence-supported fact only |
| `verification_status` | string | How the fact was verified; not a workflow status |
| `source_ids` | string array | Foreign keys to the source registry |
| `independent_confirmation_count` | integer | Independent organisations confirming the fact; multiple pages from one publisher still count as one authority |
| `esmt_interpretation` | string | Explicit management inference, never presented as source fact |
| `recommended_action` | string | Proposed response, subject to accountable approval |
| `proposed_owner` | string | Suggested owner; not an assertion of ESMT's actual organisation design |
| `proposed_due_date` | date | Internal proposal, never an official publisher deadline |
| `status` | enum | `New`, `In review`, `Actioned`, `Monitoring`, `Closed`, or `Superseded` |
| `score_inputs` | object | Five transparent 0–5 dimensions |

## Processed signal fields

| Field | Type | Meaning |
|---|---|---|
| `priority_score` | number | Weighted 0–100 rule output |
| `priority_band` | enum | `Act now`, `Plan`, `Monitor`, or `Archive` |
| `score_contributions` | object | Point contribution of each dimension; sums to the score |
| `days_to_window_start_as_of_2026_08_18` | integer | Reproducible interval from the fixed prototype date |
| `days_to_window_end_as_of_2026_08_18` | integer | Reproducible interval from the fixed prototype date |
| `sources` | object array | Denormalised display metadata; registry remains the source of truth |

## Date precision values

| Value | Display rule |
|---|---|
| `exact` | An exact source-supported date may be displayed |
| `exact_provisional` | Show exact date and the provisional caveat together |
| `month` | Display month/year; do not invent a day |
| `approximate_window` | Show official wording and any sorting-boundary assumption |
| `year` | Display edition/year only |
| `observation_date` | The date records when QA was observed, not the underlying ranking cycle |
| `publication_month_assumption` | Month used as a cycle/sorting convention; not an asserted publication date |
| `month_not_verified_in_seed` | Exact day was not established for this prototype record |

## Source record

| Field | Type | Meaning / control |
|---|---|---|
| `source_id` | string | Stable source key |
| `name` / `publisher` | string | Human-readable identity |
| `canonical_url` | nullable URL | Public landing/result/rule URL |
| `local_attachment` | nullable path | Expected location of an authorised workbook; raw files are not bundled |
| `source_family` | string | Publisher, accreditor, school website, export, private publisher, or internal |
| `evidence_type` | string | Rule, result, schedule, announcement, school claim, or operational source |
| `access_mode` | enum | `public_http`, `local_attachment`, or `manual_private` |
| `monitor_cadence` | string | Proposed review rhythm, not a publisher commitment |
| `authority_score` | 0–5 integer | Governance aid; publisher/accreditor primaries are highest |
| `enabled` | boolean | Whether the public prototype may automatically collect the source |
| `checked_at` | nullable date | Last seed verification date |
| `caveat` | nullable string | Important access, precision, licensing, or authority limitation |

## Status lifecycle

| Status | Entry criterion | Exit control |
|---|---|---|
| `New` | Verified or imported record awaits owner review | Assign reviewer and accept/reject classification |
| `In review` | Evidence and implications are being checked | Record decision, action, or monitoring rationale |
| `Actioned` | Concrete response completed | Preserve evidence and decide whether ongoing monitoring remains |
| `Monitoring` | No immediate intervention; source/event still relevant | Reassess on event, source change, or review date |
| `Closed` | No further action required | Resolution note and evidence link required in production schema |
| `Superseded` | Replaced by a newer cycle/version | Link to successor record |

