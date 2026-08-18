-- Generated from curated prototype JSON. Apply after supabase_schema.sql.

begin;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_ft_calendar', 'Financial Times Special Reports Calendar', 'Financial Times', 'https://commercial.ft.com/special-reports-calendar/', 'ranking_publisher', 'official_schedule', 'public_http'::source_access_mode, 'weekly', 5, true, '2026-08-18'::timestamptz, 'The calendar describes planned publication dates as provisional.')
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_ft_methodology', 'Financial Times Rankings Methodology Hub', 'Financial Times', 'https://rankings.ft.com/methodology', 'ranking_publisher', 'primary_rule', 'public_http'::source_access_mode, 'weekly', 5, true, '2026-08-18'::timestamptz, 'Individual methodology articles may be published outside the hub and should also be monitored.')
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_ft_mba_2026', 'Financial Times MBA 2026 Results', 'Financial Times', 'https://rankings.ft.com/rankings/3006/mba-2026', 'ranking_publisher', 'primary_result', 'public_http'::source_access_mode, 'monthly', 5, true, '2026-08-18'::timestamptz, 'Result-page access and visible fields can vary by region or session.')
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_ft_emba_2025', 'Financial Times EMBA 2025 Results', 'Financial Times', 'https://rankings.ft.com/rankings/3005/emba-2025', 'ranking_publisher', 'primary_result', 'public_http'::source_access_mode, 'monthly', 5, true, '2026-08-18'::timestamptz, null)
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_ft50_2026', 'Financial Times FT50 Journal List Update', 'Financial Times', 'https://www.ft.com/content/db863a0a-6524-45f9-bc52-fee997634bdc', 'ranking_publisher', 'primary_rule', 'public_http'::source_access_mode, 'monthly', 5, true, '2026-08-18'::timestamptz, 'The article explains use of the revised list in specified FT rankings; implementation details still require the relevant annual methodology.')
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_qs_cycle_2027', 'QS Graduate Management Education Rankings Cycle 2027', 'QS', 'https://support.qs.com/hc/en-gb/articles/6742129778588-QS-Graduate-Management-Education-GME-Rankings-Cycle-2027', 'ranking_publisher', 'official_schedule_and_rule', 'public_http'::source_access_mode, 'weekly', 5, true, '2026-08-18'::timestamptz, 'Some dates are expressed only as months or approximate mid-month windows.')
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_qs_mba_methodology', 'QS Global MBA Rankings Methodology', 'QS', 'https://www.topmba.com/mba-rankings/methodology', 'ranking_publisher', 'primary_rule', 'public_http'::source_access_mode, 'monthly', 5, true, '2026-08-18'::timestamptz, 'Methodology webpages can be updated without a versioned PDF; store snapshots in production.')
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_qs_mba_results_2026', 'QS Global MBA Rankings 2026', 'QS', 'https://www.topuniversities.com/mba-rankings', 'ranking_publisher', 'primary_result', 'public_http'::source_access_mode, 'monthly', 5, true, '2026-08-18'::timestamptz, 'The uploaded QS export is used for reproducible component-level analysis.')
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_qs_mim_results_2026', 'QS Business Master''s Rankings 2026: Management', 'QS', 'https://www.topuniversities.com/business-masters-rankings/management', 'ranking_publisher', 'primary_result', 'public_http'::source_access_mode, 'monthly', 5, true, '2026-08-18'::timestamptz, 'The uploaded QS export is used for reproducible component-level analysis.')
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_aacsb_standards', 'AACSB Global Standards', 'AACSB International', 'https://www.aacsb.edu/educators/global-standards', 'accreditor', 'primary_rule', 'public_http'::source_access_mode, 'monthly', 5, true, '2026-08-18'::timestamptz, 'Implementation timing and transition arrangements must be verified in AACSB guidance and the school portal.')
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_aacsb_ratification_2026', 'AACSB Announces Ratification of 2026 Global Standards', 'AACSB International', 'https://www.aacsb.edu/media-center/news/2026/04/global-standards-ratification', 'accreditor', 'official_announcement', 'public_http'::source_access_mode, 'monthly', 5, true, '2026-08-18'::timestamptz, null)
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_equis_docs', 'EQUIS Guides and Documents', 'EFMD Global', 'https://www.efmdglobal.org/accreditations-assessments/business-schools/equis/equis-guides-documents/', 'accreditor', 'primary_rule_index', 'public_http'::source_access_mode, 'monthly', 5, true, '2026-08-18'::timestamptz, 'Production monitoring should archive each versioned PDF, not only the index page.')
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_equis_2026_pdf', 'EQUIS Standards and Criteria 2026', 'EFMD Global', 'https://www.efmdglobal.org/wp-content/uploads/EQUIS_Standards_and_Criteria.pdf', 'accreditor', 'primary_rule', 'public_http'::source_access_mode, 'monthly', 5, true, '2026-08-18'::timestamptz, 'The unversioned file path can be overwritten; archive the retrieved document and hash.')
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_equis_2025_pdf', 'EQUIS Standards and Criteria 2025', 'EFMD Global', 'https://www.efmdglobal.org/wp-content/uploads/EQUIS-Standards-and-Criteria-2025.pdf', 'accreditor', 'primary_rule', 'public_http'::source_access_mode, 'archived_baseline', 5, true, '2026-08-18'::timestamptz, null)
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_esmt_degree_rankings', 'ESMT Degree Rankings', 'ESMT Berlin', 'https://esmt.berlin/degrees/degree-rankings', 'school_website', 'official_school_claim', 'public_http'::source_access_mode, 'weekly', 4, true, '2026-08-18'::timestamptz, 'Use the ranking publisher as the final authority for year, rank, and methodology.')
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_esmt_accreditation_rankings', 'ESMT Accreditation and Rankings', 'ESMT Berlin', 'https://esmt.berlin/about/accreditation-and-rankings', 'school_website', 'official_school_claim', 'public_http'::source_access_mode, 'weekly', 4, true, '2026-08-18'::timestamptz, 'Use the ranking publisher as the final authority for year, rank, and methodology.')
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_qs_workbook_2024', '2024 QS Global MBA Rankings Results Export', 'QS', 'https://www.topuniversities.com/mba-rankings', 'ranking_publisher_export', 'primary_result_export', 'local_attachment'::source_access_mode, 'annual', 5, false, '2026-08-18'::timestamptz, 'Confirm redistribution rights before sharing the raw export outside ESMT.')
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_qs_workbook_2025', '2025 QS Global MBA and Business Masters Results Export', 'QS', 'https://www.topuniversities.com/mba-rankings', 'ranking_publisher_export', 'primary_result_export', 'local_attachment'::source_access_mode, 'annual', 5, false, '2026-08-18'::timestamptz, 'Confirm redistribution rights before sharing the raw export outside ESMT.')
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_qs_workbook_2026', '2026 QS Global MBA and Business Masters Results Export', 'QS', 'https://www.topuniversities.com/mba-rankings', 'ranking_publisher_export', 'primary_result_export', 'local_attachment'::source_access_mode, 'annual', 5, false, '2026-08-18'::timestamptz, 'Confirm redistribution rights before sharing the raw export outside ESMT.')
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_ft_ebs_2025_export', 'FT European Business School Rankings 2025 Export', 'Financial Times', 'https://rankings.ft.com/business-education/european-business-school-rankings', 'ranking_publisher_export', 'primary_result_export', 'local_attachment'::source_access_mode, 'annual', 5, false, '2026-08-18'::timestamptz, 'Confirm redistribution rights before sharing the raw export outside ESMT.')
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_ft_participant_portal', 'FT Participant Portal and Direct Communications', 'Financial Times', null, 'ranking_publisher_private', 'private_operational_source', 'manual_private'::source_access_mode, 'per_working_day_in_submission_window', 5, false, null, 'Requires authorised ESMT access; do not expose credentials or private materials to the public app.')
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_qs_movein', 'QS MoveIN and Direct Communications', 'QS', null, 'ranking_publisher_private', 'private_operational_source', 'manual_private'::source_access_mode, 'per_working_day_in_submission_window', 5, false, null, 'Requires authorised ESMT access; do not expose credentials or submission data to the public app.')
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.sources (external_source_id, name, publisher, canonical_url, source_family, evidence_type, access_mode, monitor_cadence, authority_score, automated_collection_enabled, checked_at, caveat) values ('src_esmt_internal_calendar', 'ESMT Internal Ranking Calendar and Evidence Register', 'ESMT Berlin', null, 'internal', 'internal_operational_source', 'manual_private'::source_access_mode, 'continuous', 5, false, null, 'Production source only. Apply role-based access, retention, and personal-data controls.')
on conflict (external_source_id) do update set
  name = excluded.name, publisher = excluded.publisher, canonical_url = excluded.canonical_url,
  source_family = excluded.source_family, evidence_type = excluded.evidence_type,
  access_mode = excluded.access_mode, monitor_cadence = excluded.monitor_cadence,
  authority_score = excluded.authority_score,
  automated_collection_enabled = excluded.automated_collection_enabled,
  checked_at = excluded.checked_at, caveat = excluded.caveat;

insert into public.signals (external_signal_id, title, signal_type, programmes, ranking_or_standard, observed_at, event_date_start, event_date_end, date_precision, official_date_text, date_assumption, factual_summary, verification_status, independent_confirmation_count, esmt_interpretation, recommended_action, proposed_owner, proposed_due_date, status, strategic_impact, urgency, actionability, esmt_relevance, evidence_confidence) values ('sig_ft_mim_2026_publication', 'FT Masters in Management 2026 publication is planned for 7 September', 'publication_window', array['Master in Global Management']::text[], 'Financial Times Masters in Management', '2026-08-18'::date, '2026-09-07'::date, '2026-09-07'::date, 'exact_provisional', '7 September 2026; planned date is marked provisional by the FT calendar', null, 'The Financial Times special-reports calendar plans the 2026 Masters in Management ranking for 7 September 2026.', 'verified_with_calendar_caveat', 1, 'This is a near-term communications and result-validation event for ESMT''s management master''s portfolio; it is not a submission deadline.', 'Prepare a publication-day validation checklist, peer comparison template, and pre-approved communication scenarios. Reconfirm the FT date one week before publication.', 'Ranking Manager + Communications', '2026-08-31'::date, 'New'::workflow_status, 4, 4, 4, 4, 4)
on conflict (external_signal_id) do update set
  title = excluded.title, signal_type = excluded.signal_type, programmes = excluded.programmes,
  ranking_or_standard = excluded.ranking_or_standard, observed_at = excluded.observed_at,
  event_date_start = excluded.event_date_start, event_date_end = excluded.event_date_end,
  date_precision = excluded.date_precision, official_date_text = excluded.official_date_text,
  date_assumption = excluded.date_assumption, factual_summary = excluded.factual_summary,
  verification_status = excluded.verification_status,
  independent_confirmation_count = excluded.independent_confirmation_count,
  esmt_interpretation = excluded.esmt_interpretation, recommended_action = excluded.recommended_action,
  proposed_owner = excluded.proposed_owner, proposed_due_date = excluded.proposed_due_date,
  status = excluded.status, strategic_impact = excluded.strategic_impact, urgency = excluded.urgency,
  actionability = excluded.actionability, esmt_relevance = excluded.esmt_relevance,
  evidence_confidence = excluded.evidence_confidence;

insert into public.signals (external_signal_id, title, signal_type, programmes, ranking_or_standard, observed_at, event_date_start, event_date_end, date_precision, official_date_text, date_assumption, factual_summary, verification_status, independent_confirmation_count, esmt_interpretation, recommended_action, proposed_owner, proposed_due_date, status, strategic_impact, urgency, actionability, esmt_relevance, evidence_confidence) values ('sig_qs_mba_2027_publication', 'QS plans the next Global MBA publication for September 2026', 'publication_window', array['Full-time MBA']::text[], 'QS Global MBA Rankings 2027', '2026-08-18'::date, '2026-09-01'::date, '2026-09-30'::date, 'month', 'September 2026', null, 'QS lists September 2026 as the publication month for its Global MBA and Business Masters rankings in the 2027 cycle.', 'verified', 1, 'ESMT needs a result-validation and communications plan, but the source does not provide an exact publication day.', 'Create a September watch window and draft best/base/worst-case messaging. Do not advertise an exact date until QS confirms it.', 'Ranking Manager + MBA Team + Communications', '2026-08-31'::date, 'New'::workflow_status, 4, 4, 4, 4, 5)
on conflict (external_signal_id) do update set
  title = excluded.title, signal_type = excluded.signal_type, programmes = excluded.programmes,
  ranking_or_standard = excluded.ranking_or_standard, observed_at = excluded.observed_at,
  event_date_start = excluded.event_date_start, event_date_end = excluded.event_date_end,
  date_precision = excluded.date_precision, official_date_text = excluded.official_date_text,
  date_assumption = excluded.date_assumption, factual_summary = excluded.factual_summary,
  verification_status = excluded.verification_status,
  independent_confirmation_count = excluded.independent_confirmation_count,
  esmt_interpretation = excluded.esmt_interpretation, recommended_action = excluded.recommended_action,
  proposed_owner = excluded.proposed_owner, proposed_due_date = excluded.proposed_due_date,
  status = excluded.status, strategic_impact = excluded.strategic_impact, urgency = excluded.urgency,
  actionability = excluded.actionability, esmt_relevance = excluded.esmt_relevance,
  evidence_confidence = excluded.evidence_confidence;

insert into public.signals (external_signal_id, title, signal_type, programmes, ranking_or_standard, observed_at, event_date_start, event_date_end, date_precision, official_date_text, date_assumption, factual_summary, verification_status, independent_confirmation_count, esmt_interpretation, recommended_action, proposed_owner, proposed_due_date, status, strategic_impact, urgency, actionability, esmt_relevance, evidence_confidence) values ('sig_qs_mim_2027_publication', 'QS plans the next Business Masters publication for September 2026', 'publication_window', array['Master in Global Management']::text[], 'QS Business Master''s Rankings 2027: Management', '2026-08-18'::date, '2026-09-01'::date, '2026-09-30'::date, 'month', 'September 2026', null, 'QS lists September 2026 as the publication month for its Global MBA and Business Masters rankings in the 2027 cycle.', 'verified', 1, 'The 2026 Management result showed a large rank movement with a small overall-score change, so publication-day analysis should separate score movement from cohort compression.', 'Prepare score-distribution and German-peer comparisons before the release; use a month window until QS provides an exact day.', 'Ranking Manager + Masters Team + Communications', '2026-08-31'::date, 'New'::workflow_status, 4, 4, 4, 4, 5)
on conflict (external_signal_id) do update set
  title = excluded.title, signal_type = excluded.signal_type, programmes = excluded.programmes,
  ranking_or_standard = excluded.ranking_or_standard, observed_at = excluded.observed_at,
  event_date_start = excluded.event_date_start, event_date_end = excluded.event_date_end,
  date_precision = excluded.date_precision, official_date_text = excluded.official_date_text,
  date_assumption = excluded.date_assumption, factual_summary = excluded.factual_summary,
  verification_status = excluded.verification_status,
  independent_confirmation_count = excluded.independent_confirmation_count,
  esmt_interpretation = excluded.esmt_interpretation, recommended_action = excluded.recommended_action,
  proposed_owner = excluded.proposed_owner, proposed_due_date = excluded.proposed_due_date,
  status = excluded.status, strategic_impact = excluded.strategic_impact, urgency = excluded.urgency,
  actionability = excluded.actionability, esmt_relevance = excluded.esmt_relevance,
  evidence_confidence = excluded.evidence_confidence;

insert into public.signals (external_signal_id, title, signal_type, programmes, ranking_or_standard, observed_at, event_date_start, event_date_end, date_precision, official_date_text, date_assumption, factual_summary, verification_status, independent_confirmation_count, esmt_interpretation, recommended_action, proposed_owner, proposed_due_date, status, strategic_impact, urgency, actionability, esmt_relevance, evidence_confidence) values ('sig_ft_emba_2026_publication', 'FT Executive MBA 2026 publication is planned for 12 October', 'publication_window', array['Executive MBA']::text[], 'Financial Times Executive MBA', '2026-08-18'::date, '2026-10-12'::date, '2026-10-12'::date, 'exact_provisional', '12 October 2026; planned date is marked provisional by the FT calendar', null, 'The Financial Times special-reports calendar plans the 2026 Executive MBA ranking for 12 October 2026.', 'verified_with_calendar_caveat', 1, 'The event is relevant to result validation and to correcting the current year-label inconsistency on ESMT''s central ranking page.', 'Resolve the existing 2025/2026 label mismatch before the new cycle, then prepare an October validation and communications checklist.', 'Ranking Manager + Executive MBA Team + Communications', '2026-10-05'::date, 'New'::workflow_status, 4, 3, 4, 4, 4)
on conflict (external_signal_id) do update set
  title = excluded.title, signal_type = excluded.signal_type, programmes = excluded.programmes,
  ranking_or_standard = excluded.ranking_or_standard, observed_at = excluded.observed_at,
  event_date_start = excluded.event_date_start, event_date_end = excluded.event_date_end,
  date_precision = excluded.date_precision, official_date_text = excluded.official_date_text,
  date_assumption = excluded.date_assumption, factual_summary = excluded.factual_summary,
  verification_status = excluded.verification_status,
  independent_confirmation_count = excluded.independent_confirmation_count,
  esmt_interpretation = excluded.esmt_interpretation, recommended_action = excluded.recommended_action,
  proposed_owner = excluded.proposed_owner, proposed_due_date = excluded.proposed_due_date,
  status = excluded.status, strategic_impact = excluded.strategic_impact, urgency = excluded.urgency,
  actionability = excluded.actionability, esmt_relevance = excluded.esmt_relevance,
  evidence_confidence = excluded.evidence_confidence;

insert into public.signals (external_signal_id, title, signal_type, programmes, ranking_or_standard, observed_at, event_date_start, event_date_end, date_precision, official_date_text, date_assumption, factual_summary, verification_status, independent_confirmation_count, esmt_interpretation, recommended_action, proposed_owner, proposed_due_date, status, strategic_impact, urgency, actionability, esmt_relevance, evidence_confidence) values ('sig_ft_ebs_2026_publication', 'FT European Business Schools 2026 publication is planned for 7 December', 'publication_window', array['Institution-wide']::text[], 'Financial Times European Business Schools', '2026-08-18'::date, '2026-12-07'::date, '2026-12-07'::date, 'exact_provisional', '7 December 2026; planned date is marked provisional by the FT calendar', null, 'The Financial Times special-reports calendar plans the 2026 European Business Schools ranking for 7 December 2026.', 'verified_with_calendar_caveat', 1, 'This composite ranking can affect institution-level positioning and draws on performance across eligible FT programme rankings.', 'Maintain an auditable component-results bridge and create a pre-release scenario model; reconfirm the provisional date in late November.', 'Ranking Manager', '2026-11-30'::date, 'Monitoring'::workflow_status, 4, 2, 3, 5, 4)
on conflict (external_signal_id) do update set
  title = excluded.title, signal_type = excluded.signal_type, programmes = excluded.programmes,
  ranking_or_standard = excluded.ranking_or_standard, observed_at = excluded.observed_at,
  event_date_start = excluded.event_date_start, event_date_end = excluded.event_date_end,
  date_precision = excluded.date_precision, official_date_text = excluded.official_date_text,
  date_assumption = excluded.date_assumption, factual_summary = excluded.factual_summary,
  verification_status = excluded.verification_status,
  independent_confirmation_count = excluded.independent_confirmation_count,
  esmt_interpretation = excluded.esmt_interpretation, recommended_action = excluded.recommended_action,
  proposed_owner = excluded.proposed_owner, proposed_due_date = excluded.proposed_due_date,
  status = excluded.status, strategic_impact = excluded.strategic_impact, urgency = excluded.urgency,
  actionability = excluded.actionability, esmt_relevance = excluded.esmt_relevance,
  evidence_confidence = excluded.evidence_confidence;

insert into public.signals (external_signal_id, title, signal_type, programmes, ranking_or_standard, observed_at, event_date_start, event_date_end, date_precision, official_date_text, date_assumption, factual_summary, verification_status, independent_confirmation_count, esmt_interpretation, recommended_action, proposed_owner, proposed_due_date, status, strategic_impact, urgency, actionability, esmt_relevance, evidence_confidence) values ('sig_qs_online_mba_2027_collection', 'QS Online MBA 2027 data collection is expected from October to mid-January', 'submission_window', array['Part-time Blended MBA']::text[], 'QS Online MBA Rankings 2027', '2026-08-18'::date, '2026-10-01'::date, '2027-01-15'::date, 'approximate_window', 'October 2026 to mid-January 2027', '1 October and 15 January are sorting boundaries only; QS supplies month and mid-month wording, not exact dates.', 'QS states that institution data collection for the 2027 Online MBA ranking will run from October 2026 to mid-January 2027 and that extensions will not be granted.', 'verified', 1, 'The public schedule is sufficient for readiness planning, but the operative deadline and questionnaire must be verified in MoveIN.', 'Open an internal evidence checklist now, assign field owners, and require the authorised portal owner to record the exact opening and closing dates when available.', 'Ranking Manager + Part-time MBA Team', '2026-09-15'::date, 'New'::workflow_status, 4, 3, 5, 4, 5)
on conflict (external_signal_id) do update set
  title = excluded.title, signal_type = excluded.signal_type, programmes = excluded.programmes,
  ranking_or_standard = excluded.ranking_or_standard, observed_at = excluded.observed_at,
  event_date_start = excluded.event_date_start, event_date_end = excluded.event_date_end,
  date_precision = excluded.date_precision, official_date_text = excluded.official_date_text,
  date_assumption = excluded.date_assumption, factual_summary = excluded.factual_summary,
  verification_status = excluded.verification_status,
  independent_confirmation_count = excluded.independent_confirmation_count,
  esmt_interpretation = excluded.esmt_interpretation, recommended_action = excluded.recommended_action,
  proposed_owner = excluded.proposed_owner, proposed_due_date = excluded.proposed_due_date,
  status = excluded.status, strategic_impact = excluded.strategic_impact, urgency = excluded.urgency,
  actionability = excluded.actionability, esmt_relevance = excluded.esmt_relevance,
  evidence_confidence = excluded.evidence_confidence;

insert into public.signals (external_signal_id, title, signal_type, programmes, ranking_or_standard, observed_at, event_date_start, event_date_end, date_precision, official_date_text, date_assumption, factual_summary, verification_status, independent_confirmation_count, esmt_interpretation, recommended_action, proposed_owner, proposed_due_date, status, strategic_impact, urgency, actionability, esmt_relevance, evidence_confidence) values ('sig_qs_emba_2027_collection', 'QS Executive MBA 2027 data collection is expected from October to mid-January', 'submission_window', array['Executive MBA']::text[], 'QS Executive MBA Rankings 2027', '2026-08-18'::date, '2026-10-01'::date, '2027-01-15'::date, 'approximate_window', 'October 2026 to mid-January 2027', '1 October and 15 January are sorting boundaries only; QS supplies month and mid-month wording, not exact dates.', 'QS states that institution data collection for the 2027 Executive MBA ranking will run from October 2026 to mid-January 2027 and that extensions will not be granted.', 'verified', 1, 'The public schedule enables readiness work but does not replace the exact dates, validation rules, and field definitions in MoveIN.', 'Create the internal data-owner matrix and evidence pack before October; record exact portal dates when the authorised account sees them.', 'Ranking Manager + Executive MBA Team', '2026-09-15'::date, 'New'::workflow_status, 4, 3, 5, 4, 5)
on conflict (external_signal_id) do update set
  title = excluded.title, signal_type = excluded.signal_type, programmes = excluded.programmes,
  ranking_or_standard = excluded.ranking_or_standard, observed_at = excluded.observed_at,
  event_date_start = excluded.event_date_start, event_date_end = excluded.event_date_end,
  date_precision = excluded.date_precision, official_date_text = excluded.official_date_text,
  date_assumption = excluded.date_assumption, factual_summary = excluded.factual_summary,
  verification_status = excluded.verification_status,
  independent_confirmation_count = excluded.independent_confirmation_count,
  esmt_interpretation = excluded.esmt_interpretation, recommended_action = excluded.recommended_action,
  proposed_owner = excluded.proposed_owner, proposed_due_date = excluded.proposed_due_date,
  status = excluded.status, strategic_impact = excluded.strategic_impact, urgency = excluded.urgency,
  actionability = excluded.actionability, esmt_relevance = excluded.esmt_relevance,
  evidence_confidence = excluded.evidence_confidence;

insert into public.signals (external_signal_id, title, signal_type, programmes, ranking_or_standard, observed_at, event_date_start, event_date_end, date_precision, official_date_text, date_assumption, factual_summary, verification_status, independent_confirmation_count, esmt_interpretation, recommended_action, proposed_owner, proposed_due_date, status, strategic_impact, urgency, actionability, esmt_relevance, evidence_confidence) values ('sig_ft50_2026_change', 'FT revised the FT50 journal list used in research metrics', 'methodology_change', array['Full-time MBA', 'Executive MBA', 'Part-time Blended MBA', 'Institution-wide research']::text[], 'Financial Times research rank / FT50', '2026-08-18'::date, '2026-04-29'::date, '2026-04-29'::date, 'exact', '29 April 2026', null, 'FT added Academy of Management Annals, American Sociological Review, and Psychological Science to the FT50, and removed Human Relations, Journal of Business Ethics, and Organization Studies. FT says the revised list is used for research measures in its Global MBA, EMBA, and Online MBA rankings.', 'verified', 1, 'Historical and forecast research counts may change even without a change in faculty output. This can affect cross-year comparability and scenario models.', 'Remap ESMT publications and peer benchmarks to the revised list, quantify the delta, and version the journal-list logic used in forecasts.', 'Ranking Manager + Research Office', '2026-09-15'::date, 'In review'::workflow_status, 5, 4, 5, 4, 5)
on conflict (external_signal_id) do update set
  title = excluded.title, signal_type = excluded.signal_type, programmes = excluded.programmes,
  ranking_or_standard = excluded.ranking_or_standard, observed_at = excluded.observed_at,
  event_date_start = excluded.event_date_start, event_date_end = excluded.event_date_end,
  date_precision = excluded.date_precision, official_date_text = excluded.official_date_text,
  date_assumption = excluded.date_assumption, factual_summary = excluded.factual_summary,
  verification_status = excluded.verification_status,
  independent_confirmation_count = excluded.independent_confirmation_count,
  esmt_interpretation = excluded.esmt_interpretation, recommended_action = excluded.recommended_action,
  proposed_owner = excluded.proposed_owner, proposed_due_date = excluded.proposed_due_date,
  status = excluded.status, strategic_impact = excluded.strategic_impact, urgency = excluded.urgency,
  actionability = excluded.actionability, esmt_relevance = excluded.esmt_relevance,
  evidence_confidence = excluded.evidence_confidence;

insert into public.signals (external_signal_id, title, signal_type, programmes, ranking_or_standard, observed_at, event_date_start, event_date_end, date_precision, official_date_text, date_assumption, factual_summary, verification_status, independent_confirmation_count, esmt_interpretation, recommended_action, proposed_owner, proposed_due_date, status, strategic_impact, urgency, actionability, esmt_relevance, evidence_confidence) values ('sig_aacsb_2026_standards', 'AACSB ratified new 2026 Global Standards', 'accreditation_standard', array['Institution-wide']::text[], 'AACSB 2026 Global Standards', '2026-08-18'::date, '2026-04-20'::date, '2026-04-20'::date, 'exact', '20 April 2026', null, 'AACSB announced ratification of its 2026 Global Standards and describes the framework as principles- and outcomes-focused.', 'verified', 1, 'This is institution-wide accreditation governance, not a ranking-news item. The practical exposure depends on transition rules and ESMT''s review cycle, which are not established in this public seed signal.', 'Run a controlled gap assessment against the final standards and transition guidance; map each requirement to an evidence owner and existing assurance process.', 'Accreditation Lead + Ranking Manager', '2026-09-30'::date, 'In review'::workflow_status, 5, 4, 5, 5, 5)
on conflict (external_signal_id) do update set
  title = excluded.title, signal_type = excluded.signal_type, programmes = excluded.programmes,
  ranking_or_standard = excluded.ranking_or_standard, observed_at = excluded.observed_at,
  event_date_start = excluded.event_date_start, event_date_end = excluded.event_date_end,
  date_precision = excluded.date_precision, official_date_text = excluded.official_date_text,
  date_assumption = excluded.date_assumption, factual_summary = excluded.factual_summary,
  verification_status = excluded.verification_status,
  independent_confirmation_count = excluded.independent_confirmation_count,
  esmt_interpretation = excluded.esmt_interpretation, recommended_action = excluded.recommended_action,
  proposed_owner = excluded.proposed_owner, proposed_due_date = excluded.proposed_due_date,
  status = excluded.status, strategic_impact = excluded.strategic_impact, urgency = excluded.urgency,
  actionability = excluded.actionability, esmt_relevance = excluded.esmt_relevance,
  evidence_confidence = excluded.evidence_confidence;

insert into public.signals (external_signal_id, title, signal_type, programmes, ranking_or_standard, observed_at, event_date_start, event_date_end, date_precision, official_date_text, date_assumption, factual_summary, verification_status, independent_confirmation_count, esmt_interpretation, recommended_action, proposed_owner, proposed_due_date, status, strategic_impact, urgency, actionability, esmt_relevance, evidence_confidence) values ('sig_equis_2026_microcredentials', 'EQUIS 2026 criteria explicitly include micro-credentials and stackable modules', 'accreditation_standard', array['Executive Education', 'Degree programmes', 'Institution-wide']::text[], 'EQUIS Standards and Criteria 2026', '2026-08-18'::date, '2026-01-01'::date, '2026-12-31'::date, 'year', '2026 edition', null, 'The 2026 EQUIS criteria explicitly refer to micro-credentials and stackable modules in the internationalisation context; the term is absent from the 2025 criteria PDF checked for this prototype.', 'verified_document_comparison', 1, 'ESMT should ensure that short-format and stackable learning offers are represented consistently in programme inventories, internationalisation evidence, quality assurance, and partner reporting.', 'Document the relevant portfolio, governance, international reach, learning assurance, and evidence links; ask the accreditation owner whether this changes the next self-assessment narrative.', 'Accreditation Lead + Executive Education', '2026-10-15'::date, 'In review'::workflow_status, 4, 3, 4, 5, 5)
on conflict (external_signal_id) do update set
  title = excluded.title, signal_type = excluded.signal_type, programmes = excluded.programmes,
  ranking_or_standard = excluded.ranking_or_standard, observed_at = excluded.observed_at,
  event_date_start = excluded.event_date_start, event_date_end = excluded.event_date_end,
  date_precision = excluded.date_precision, official_date_text = excluded.official_date_text,
  date_assumption = excluded.date_assumption, factual_summary = excluded.factual_summary,
  verification_status = excluded.verification_status,
  independent_confirmation_count = excluded.independent_confirmation_count,
  esmt_interpretation = excluded.esmt_interpretation, recommended_action = excluded.recommended_action,
  proposed_owner = excluded.proposed_owner, proposed_due_date = excluded.proposed_due_date,
  status = excluded.status, strategic_impact = excluded.strategic_impact, urgency = excluded.urgency,
  actionability = excluded.actionability, esmt_relevance = excluded.esmt_relevance,
  evidence_confidence = excluded.evidence_confidence;

insert into public.signals (external_signal_id, title, signal_type, programmes, ranking_or_standard, observed_at, event_date_start, event_date_end, date_precision, official_date_text, date_assumption, factual_summary, verification_status, independent_confirmation_count, esmt_interpretation, recommended_action, proposed_owner, proposed_due_date, status, strategic_impact, urgency, actionability, esmt_relevance, evidence_confidence) values ('sig_qs_mba_2026_shift', 'ESMT''s QS Global MBA rank moved from 78 to 84 while key German peers were broadly stable', 'competitive_shift', array['Full-time MBA']::text[], 'QS Global MBA Rankings 2026', '2026-08-18'::date, '2025-09-01'::date, '2025-09-30'::date, 'publication_month_assumption', '2026 edition; workbook comparison uses the 2025 and 2026 result files', 'September is used only as a cycle label because the seed export does not establish an exact publication day.', 'In the supplied QS exports, ESMT moved from rank 78 and score 60.4 in 2025 to rank 84 and score 59.4 in 2026. Entrepreneurship and Alumni Outcomes fell 5.4 points and Employability fell 2.1, while ROI, Thought Leadership, and Diversity improved. Frankfurt remained 40, Mannheim moved 47 to 46, and WHU moved 55 to 57.', 'computed_from_official_exports', 1, 'The movement is not explained by a broad decline among the selected German peers. The most plausible analytical focus is the two falling components, but causality cannot be inferred from result files alone.', 'Reconcile the submitted inputs and survey/outcomes evidence behind Employability and Entrepreneurship & Alumni Outcomes, then model feasible component scenarios using the published weights.', 'Ranking Manager + MBA Careers + Alumni Relations', '2026-09-30'::date, 'In review'::workflow_status, 4, 3, 4, 4, 5)
on conflict (external_signal_id) do update set
  title = excluded.title, signal_type = excluded.signal_type, programmes = excluded.programmes,
  ranking_or_standard = excluded.ranking_or_standard, observed_at = excluded.observed_at,
  event_date_start = excluded.event_date_start, event_date_end = excluded.event_date_end,
  date_precision = excluded.date_precision, official_date_text = excluded.official_date_text,
  date_assumption = excluded.date_assumption, factual_summary = excluded.factual_summary,
  verification_status = excluded.verification_status,
  independent_confirmation_count = excluded.independent_confirmation_count,
  esmt_interpretation = excluded.esmt_interpretation, recommended_action = excluded.recommended_action,
  proposed_owner = excluded.proposed_owner, proposed_due_date = excluded.proposed_due_date,
  status = excluded.status, strategic_impact = excluded.strategic_impact, urgency = excluded.urgency,
  actionability = excluded.actionability, esmt_relevance = excluded.esmt_relevance,
  evidence_confidence = excluded.evidence_confidence;

insert into public.signals (external_signal_id, title, signal_type, programmes, ranking_or_standard, observed_at, event_date_start, event_date_end, date_precision, official_date_text, date_assumption, factual_summary, verification_status, independent_confirmation_count, esmt_interpretation, recommended_action, proposed_owner, proposed_due_date, status, strategic_impact, urgency, actionability, esmt_relevance, evidence_confidence) values ('sig_qs_mim_2026_shift', 'ESMT''s QS Management rank moved from 75 to 100 despite only a 0.9-point score decline', 'competitive_shift', array['Master in Global Management']::text[], 'QS Business Master''s Rankings 2026: Management', '2026-08-18'::date, '2025-09-01'::date, '2025-09-30'::date, 'publication_month_assumption', '2026 edition; workbook comparison uses the 2025 and 2026 result files', 'September is used only as a cycle label because the seed export does not establish an exact publication day.', 'In the supplied QS exports, ESMT moved from rank 75 and score 52.0 in 2025 to rank 100 and score 51.1 in 2026. Value for Money fell 4.6 points and Diversity fell 3.1, while Thought Leadership rose 1.8 and Employability rose 0.2. Several selected German peers improved or fell less sharply.', 'computed_from_official_exports', 1, 'A 25-place rank movement with a 0.9-point score decline suggests cohort density and competitor movement matter. Treating the rank change alone as a performance collapse would be analytically weak.', 'Analyse Value for Money inputs, score density around ESMT, new entrants, and peer changes; present score and rank side by side in management reporting.', 'Ranking Manager + Masters Team + Finance/Careers data owners', '2026-09-30'::date, 'In review'::workflow_status, 4, 3, 4, 4, 5)
on conflict (external_signal_id) do update set
  title = excluded.title, signal_type = excluded.signal_type, programmes = excluded.programmes,
  ranking_or_standard = excluded.ranking_or_standard, observed_at = excluded.observed_at,
  event_date_start = excluded.event_date_start, event_date_end = excluded.event_date_end,
  date_precision = excluded.date_precision, official_date_text = excluded.official_date_text,
  date_assumption = excluded.date_assumption, factual_summary = excluded.factual_summary,
  verification_status = excluded.verification_status,
  independent_confirmation_count = excluded.independent_confirmation_count,
  esmt_interpretation = excluded.esmt_interpretation, recommended_action = excluded.recommended_action,
  proposed_owner = excluded.proposed_owner, proposed_due_date = excluded.proposed_due_date,
  status = excluded.status, strategic_impact = excluded.strategic_impact, urgency = excluded.urgency,
  actionability = excluded.actionability, esmt_relevance = excluded.esmt_relevance,
  evidence_confidence = excluded.evidence_confidence;

insert into public.signals (external_signal_id, title, signal_type, programmes, ranking_or_standard, observed_at, event_date_start, event_date_end, date_precision, official_date_text, date_assumption, factual_summary, verification_status, independent_confirmation_count, esmt_interpretation, recommended_action, proposed_owner, proposed_due_date, status, strategic_impact, urgency, actionability, esmt_relevance, evidence_confidence) values ('sig_esmt_mba_year_mismatch', 'ESMT pages attach different years to the same Full-time MBA rank', 'communication_mismatch', array['Full-time MBA']::text[], 'Financial Times MBA', '2026-08-18'::date, '2026-08-18'::date, '2026-08-18'::date, 'observation_date', 'Observed on 18 August 2026', null, 'ESMT''s degree-ranking page labels Full-time MBA rank 79 as 2026, consistent with the FT MBA 2026 result page. ESMT''s central accreditation-and-rankings page labels rank 79 as 2025, while the FT 2025 rank shown on the degree page is 80.', 'verified_cross_page_mismatch', 2, 'This is a controllable website QA defect. It can weaken trust in external claims and complicate future update cycles.', 'Correct the year label on the central page and add a single structured ranking-claims register that feeds all public pages.', 'Communications + Ranking Manager', '2026-08-21'::date, 'New'::workflow_status, 3, 4, 5, 5, 5)
on conflict (external_signal_id) do update set
  title = excluded.title, signal_type = excluded.signal_type, programmes = excluded.programmes,
  ranking_or_standard = excluded.ranking_or_standard, observed_at = excluded.observed_at,
  event_date_start = excluded.event_date_start, event_date_end = excluded.event_date_end,
  date_precision = excluded.date_precision, official_date_text = excluded.official_date_text,
  date_assumption = excluded.date_assumption, factual_summary = excluded.factual_summary,
  verification_status = excluded.verification_status,
  independent_confirmation_count = excluded.independent_confirmation_count,
  esmt_interpretation = excluded.esmt_interpretation, recommended_action = excluded.recommended_action,
  proposed_owner = excluded.proposed_owner, proposed_due_date = excluded.proposed_due_date,
  status = excluded.status, strategic_impact = excluded.strategic_impact, urgency = excluded.urgency,
  actionability = excluded.actionability, esmt_relevance = excluded.esmt_relevance,
  evidence_confidence = excluded.evidence_confidence;

insert into public.signals (external_signal_id, title, signal_type, programmes, ranking_or_standard, observed_at, event_date_start, event_date_end, date_precision, official_date_text, date_assumption, factual_summary, verification_status, independent_confirmation_count, esmt_interpretation, recommended_action, proposed_owner, proposed_due_date, status, strategic_impact, urgency, actionability, esmt_relevance, evidence_confidence) values ('sig_esmt_emba_year_mismatch', 'ESMT''s central page labels the FT Executive MBA rank 42 with the wrong cycle', 'communication_mismatch', array['Executive MBA']::text[], 'Financial Times Executive MBA', '2026-08-18'::date, '2026-08-18'::date, '2026-08-18'::date, 'observation_date', 'Observed on 18 August 2026', null, 'ESMT''s central accreditation-and-rankings page labels Executive MBA rank 42 as 2026, while the FT result page identifies rank 42 as the 2025 Executive MBA result published in October 2025.', 'verified_cross_page_mismatch', 2, 'The page presents a future-cycle label for an existing result. The defect is easy to correct and should be resolved before the planned October 2026 release.', 'Correct the cycle to 2025, verify all displayed ranking years against publisher result pages, and add a two-person approval check for future updates.', 'Communications + Ranking Manager', '2026-08-21'::date, 'New'::workflow_status, 3, 4, 5, 5, 5)
on conflict (external_signal_id) do update set
  title = excluded.title, signal_type = excluded.signal_type, programmes = excluded.programmes,
  ranking_or_standard = excluded.ranking_or_standard, observed_at = excluded.observed_at,
  event_date_start = excluded.event_date_start, event_date_end = excluded.event_date_end,
  date_precision = excluded.date_precision, official_date_text = excluded.official_date_text,
  date_assumption = excluded.date_assumption, factual_summary = excluded.factual_summary,
  verification_status = excluded.verification_status,
  independent_confirmation_count = excluded.independent_confirmation_count,
  esmt_interpretation = excluded.esmt_interpretation, recommended_action = excluded.recommended_action,
  proposed_owner = excluded.proposed_owner, proposed_due_date = excluded.proposed_due_date,
  status = excluded.status, strategic_impact = excluded.strategic_impact, urgency = excluded.urgency,
  actionability = excluded.actionability, esmt_relevance = excluded.esmt_relevance,
  evidence_confidence = excluded.evidence_confidence;

insert into public.signals (external_signal_id, title, signal_type, programmes, ranking_or_standard, observed_at, event_date_start, event_date_end, date_precision, official_date_text, date_assumption, factual_summary, verification_status, independent_confirmation_count, esmt_interpretation, recommended_action, proposed_owner, proposed_due_date, status, strategic_impact, urgency, actionability, esmt_relevance, evidence_confidence) values ('sig_ft_mba_2026_result', 'ESMT is 79th globally and second in Germany in the FT MBA 2026 ranking', 'ranking_result', array['Full-time MBA']::text[], 'Financial Times MBA 2026', '2026-08-18'::date, '2026-02-16'::date, '2026-02-16'::date, 'exact', 'Published 16 February 2026', null, 'The FT MBA 2026 result places ESMT at rank 79. ESMT''s degree-ranking page describes this as second in Germany.', 'verified', 2, 'The result is already public. The remaining operational value is claim consistency, peer/component analysis, and preserving a validated evidence record.', 'Archive the validated result, rank context, publication date, approved claim wording, and source snapshot in the central claims register.', 'Ranking Manager + Communications', '2026-08-31'::date, 'Monitoring'::workflow_status, 3, 2, 4, 5, 5)
on conflict (external_signal_id) do update set
  title = excluded.title, signal_type = excluded.signal_type, programmes = excluded.programmes,
  ranking_or_standard = excluded.ranking_or_standard, observed_at = excluded.observed_at,
  event_date_start = excluded.event_date_start, event_date_end = excluded.event_date_end,
  date_precision = excluded.date_precision, official_date_text = excluded.official_date_text,
  date_assumption = excluded.date_assumption, factual_summary = excluded.factual_summary,
  verification_status = excluded.verification_status,
  independent_confirmation_count = excluded.independent_confirmation_count,
  esmt_interpretation = excluded.esmt_interpretation, recommended_action = excluded.recommended_action,
  proposed_owner = excluded.proposed_owner, proposed_due_date = excluded.proposed_due_date,
  status = excluded.status, strategic_impact = excluded.strategic_impact, urgency = excluded.urgency,
  actionability = excluded.actionability, esmt_relevance = excluded.esmt_relevance,
  evidence_confidence = excluded.evidence_confidence;

insert into public.signals (external_signal_id, title, signal_type, programmes, ranking_or_standard, observed_at, event_date_start, event_date_end, date_precision, official_date_text, date_assumption, factual_summary, verification_status, independent_confirmation_count, esmt_interpretation, recommended_action, proposed_owner, proposed_due_date, status, strategic_impact, urgency, actionability, esmt_relevance, evidence_confidence) values ('sig_ft_ebs_2025_result', 'ESMT is 12th in Europe and first in Germany in the FT European Business Schools 2025 ranking', 'ranking_result', array['Institution-wide']::text[], 'Financial Times European Business Schools 2025', '2026-08-18'::date, '2025-12-01'::date, '2025-12-31'::date, 'month_not_verified_in_seed', '2025 edition; exact day not asserted in this seed signal', null, 'The supplied FT export and ESMT''s ranking pages place ESMT at rank 12 in Europe and first in Germany in the 2025 European Business Schools ranking.', 'verified_from_export_and_school_claim', 2, 'The result is a high-value institutional claim, but it should be linked to the correct cycle, ranking scope, and component evidence.', 'Keep the claim in the structured register and document the component rankings feeding the composite result for management reporting.', 'Ranking Manager + Communications', '2026-09-30'::date, 'Monitoring'::workflow_status, 4, 1, 3, 5, 5)
on conflict (external_signal_id) do update set
  title = excluded.title, signal_type = excluded.signal_type, programmes = excluded.programmes,
  ranking_or_standard = excluded.ranking_or_standard, observed_at = excluded.observed_at,
  event_date_start = excluded.event_date_start, event_date_end = excluded.event_date_end,
  date_precision = excluded.date_precision, official_date_text = excluded.official_date_text,
  date_assumption = excluded.date_assumption, factual_summary = excluded.factual_summary,
  verification_status = excluded.verification_status,
  independent_confirmation_count = excluded.independent_confirmation_count,
  esmt_interpretation = excluded.esmt_interpretation, recommended_action = excluded.recommended_action,
  proposed_owner = excluded.proposed_owner, proposed_due_date = excluded.proposed_due_date,
  status = excluded.status, strategic_impact = excluded.strategic_impact, urgency = excluded.urgency,
  actionability = excluded.actionability, esmt_relevance = excluded.esmt_relevance,
  evidence_confidence = excluded.evidence_confidence;

insert into public.signals (external_signal_id, title, signal_type, programmes, ranking_or_standard, observed_at, event_date_start, event_date_end, date_precision, official_date_text, date_assumption, factual_summary, verification_status, independent_confirmation_count, esmt_interpretation, recommended_action, proposed_owner, proposed_due_date, status, strategic_impact, urgency, actionability, esmt_relevance, evidence_confidence) values ('sig_ft_execed_2026_result', 'ESMT reports top-10 positions in both FT Executive Education 2026 tables', 'ranking_result', array['Executive Education']::text[], 'Financial Times Executive Education 2026', '2026-08-18'::date, '2026-05-01'::date, '2026-05-31'::date, 'month_not_verified_in_seed', '2026 edition; exact day not asserted in this seed signal', null, 'ESMT''s official ranking pages report rank 5 for customised executive education and rank 9 for open-enrolment executive education in the FT 2026 results; the open result is described as first in Germany.', 'verified_school_claim_requires_publisher_archive', 1, 'These are strong public claims, but the prototype has not archived the corresponding publisher result rows. Production should not rely on the school page alone.', 'Attach the FT result rows and approved claim wording to the evidence register, then verify consistency across Executive Education pages and campaign materials.', 'Ranking Manager + Executive Education + Communications', '2026-09-15'::date, 'In review'::workflow_status, 4, 2, 4, 5, 4)
on conflict (external_signal_id) do update set
  title = excluded.title, signal_type = excluded.signal_type, programmes = excluded.programmes,
  ranking_or_standard = excluded.ranking_or_standard, observed_at = excluded.observed_at,
  event_date_start = excluded.event_date_start, event_date_end = excluded.event_date_end,
  date_precision = excluded.date_precision, official_date_text = excluded.official_date_text,
  date_assumption = excluded.date_assumption, factual_summary = excluded.factual_summary,
  verification_status = excluded.verification_status,
  independent_confirmation_count = excluded.independent_confirmation_count,
  esmt_interpretation = excluded.esmt_interpretation, recommended_action = excluded.recommended_action,
  proposed_owner = excluded.proposed_owner, proposed_due_date = excluded.proposed_due_date,
  status = excluded.status, strategic_impact = excluded.strategic_impact, urgency = excluded.urgency,
  actionability = excluded.actionability, esmt_relevance = excluded.esmt_relevance,
  evidence_confidence = excluded.evidence_confidence;

insert into public.signals (external_signal_id, title, signal_type, programmes, ranking_or_standard, observed_at, event_date_start, event_date_end, date_precision, official_date_text, date_assumption, factual_summary, verification_status, independent_confirmation_count, esmt_interpretation, recommended_action, proposed_owner, proposed_due_date, status, strategic_impact, urgency, actionability, esmt_relevance, evidence_confidence) values ('sig_ft_online_mba_2026_result', 'ESMT reports Germany''s top position in the FT Online MBA 2026 ranking', 'ranking_result', array['Part-time Blended MBA']::text[], 'Financial Times Online MBA 2026', '2026-08-18'::date, '2026-03-01'::date, '2026-03-31'::date, 'month_not_verified_in_seed', '2026 edition; exact day not asserted in this seed signal', null, 'ESMT''s official degree-ranking page describes the Part-time MBA as first in Germany in the FT Online MBA 2026 ranking.', 'verified_school_claim_requires_publisher_archive', 1, 'The claim is strategically useful but is not fully evidenced in the prototype because the publisher result row has not been archived.', 'Archive the FT result row and approved wording, then align the public programme and central ranking pages to the same record.', 'Ranking Manager + Part-time MBA Team + Communications', '2026-09-15'::date, 'In review'::workflow_status, 4, 2, 4, 5, 4)
on conflict (external_signal_id) do update set
  title = excluded.title, signal_type = excluded.signal_type, programmes = excluded.programmes,
  ranking_or_standard = excluded.ranking_or_standard, observed_at = excluded.observed_at,
  event_date_start = excluded.event_date_start, event_date_end = excluded.event_date_end,
  date_precision = excluded.date_precision, official_date_text = excluded.official_date_text,
  date_assumption = excluded.date_assumption, factual_summary = excluded.factual_summary,
  verification_status = excluded.verification_status,
  independent_confirmation_count = excluded.independent_confirmation_count,
  esmt_interpretation = excluded.esmt_interpretation, recommended_action = excluded.recommended_action,
  proposed_owner = excluded.proposed_owner, proposed_due_date = excluded.proposed_due_date,
  status = excluded.status, strategic_impact = excluded.strategic_impact, urgency = excluded.urgency,
  actionability = excluded.actionability, esmt_relevance = excluded.esmt_relevance,
  evidence_confidence = excluded.evidence_confidence;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_ft_calendar'
where s.external_signal_id = 'sig_ft_mim_2026_publication'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_qs_cycle_2027'
where s.external_signal_id = 'sig_qs_mba_2027_publication'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_qs_cycle_2027'
where s.external_signal_id = 'sig_qs_mim_2027_publication'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_ft_calendar'
where s.external_signal_id = 'sig_ft_emba_2026_publication'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_ft_calendar'
where s.external_signal_id = 'sig_ft_ebs_2026_publication'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_qs_cycle_2027'
where s.external_signal_id = 'sig_qs_online_mba_2027_collection'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_qs_movein'
where s.external_signal_id = 'sig_qs_online_mba_2027_collection'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_qs_cycle_2027'
where s.external_signal_id = 'sig_qs_emba_2027_collection'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_qs_movein'
where s.external_signal_id = 'sig_qs_emba_2027_collection'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_ft50_2026'
where s.external_signal_id = 'sig_ft50_2026_change'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_ft_methodology'
where s.external_signal_id = 'sig_ft50_2026_change'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_aacsb_ratification_2026'
where s.external_signal_id = 'sig_aacsb_2026_standards'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_aacsb_standards'
where s.external_signal_id = 'sig_aacsb_2026_standards'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_equis_2026_pdf'
where s.external_signal_id = 'sig_equis_2026_microcredentials'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_equis_2025_pdf'
where s.external_signal_id = 'sig_equis_2026_microcredentials'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_equis_docs'
where s.external_signal_id = 'sig_equis_2026_microcredentials'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_qs_workbook_2025'
where s.external_signal_id = 'sig_qs_mba_2026_shift'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_qs_workbook_2026'
where s.external_signal_id = 'sig_qs_mba_2026_shift'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_qs_mba_results_2026'
where s.external_signal_id = 'sig_qs_mba_2026_shift'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_qs_mba_methodology'
where s.external_signal_id = 'sig_qs_mba_2026_shift'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_qs_workbook_2025'
where s.external_signal_id = 'sig_qs_mim_2026_shift'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_qs_workbook_2026'
where s.external_signal_id = 'sig_qs_mim_2026_shift'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_qs_mim_results_2026'
where s.external_signal_id = 'sig_qs_mim_2026_shift'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_esmt_degree_rankings'
where s.external_signal_id = 'sig_esmt_mba_year_mismatch'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_esmt_accreditation_rankings'
where s.external_signal_id = 'sig_esmt_mba_year_mismatch'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_ft_mba_2026'
where s.external_signal_id = 'sig_esmt_mba_year_mismatch'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_esmt_accreditation_rankings'
where s.external_signal_id = 'sig_esmt_emba_year_mismatch'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_ft_emba_2025'
where s.external_signal_id = 'sig_esmt_emba_year_mismatch'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_ft_mba_2026'
where s.external_signal_id = 'sig_ft_mba_2026_result'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_esmt_degree_rankings'
where s.external_signal_id = 'sig_ft_mba_2026_result'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_ft_ebs_2025_export'
where s.external_signal_id = 'sig_ft_ebs_2025_result'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_esmt_degree_rankings'
where s.external_signal_id = 'sig_ft_ebs_2025_result'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_esmt_accreditation_rankings'
where s.external_signal_id = 'sig_ft_ebs_2025_result'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_esmt_degree_rankings'
where s.external_signal_id = 'sig_ft_execed_2026_result'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_esmt_accreditation_rankings'
where s.external_signal_id = 'sig_ft_execed_2026_result'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_ft_methodology'
where s.external_signal_id = 'sig_ft_execed_2026_result'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_esmt_degree_rankings'
where s.external_signal_id = 'sig_ft_online_mba_2026_result'
on conflict (signal_id, source_id) do nothing;

insert into public.signal_sources (signal_id, source_id)
select s.id, src.id from public.signals s join public.sources src on src.external_source_id = 'src_ft_methodology'
where s.external_signal_id = 'sig_ft_online_mba_2026_result'
on conflict (signal_id, source_id) do nothing;

commit;

