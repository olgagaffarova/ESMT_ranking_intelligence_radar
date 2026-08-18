-- ESMT Ranking Intelligence Radar: Supabase/Postgres starting schema.
-- Apply only after ESMT approves roles, retention, and source-data licensing.

create extension if not exists pgcrypto;

create type source_access_mode as enum ('public_http', 'local_attachment', 'manual_private');
create type workflow_status as enum ('New', 'In review', 'Actioned', 'Monitoring', 'Closed', 'Superseded');
create type priority_band as enum ('Act now', 'Plan', 'Monitor', 'Archive');

create table if not exists public.sources (
  id uuid primary key default gen_random_uuid(),
  external_source_id text unique not null,
  name text not null,
  publisher text not null,
  canonical_url text,
  source_family text not null,
  evidence_type text not null,
  access_mode source_access_mode not null,
  monitor_cadence text not null,
  authority_score smallint not null check (authority_score between 0 and 5),
  automated_collection_enabled boolean not null default false,
  checked_at timestamptz,
  last_success_at timestamptz,
  last_error text,
  caveat text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint private_source_not_automatically_collected check (
    access_mode <> 'manual_private' or automated_collection_enabled = false
  )
);

create table if not exists public.scoring_versions (
  id uuid primary key default gen_random_uuid(),
  version_name text unique not null,
  strategic_impact_weight numeric not null,
  urgency_weight numeric not null,
  actionability_weight numeric not null,
  esmt_relevance_weight numeric not null,
  evidence_confidence_weight numeric not null,
  act_now_min numeric not null default 75,
  plan_min numeric not null default 55,
  monitor_min numeric not null default 35,
  approved_by uuid references auth.users(id),
  approved_at timestamptz,
  active boolean not null default false,
  created_at timestamptz not null default now(),
  constraint weights_total_100 check (
    strategic_impact_weight + urgency_weight + actionability_weight +
    esmt_relevance_weight + evidence_confidence_weight = 100
  )
);

create unique index if not exists one_active_scoring_version
  on public.scoring_versions (active) where active = true;

insert into public.scoring_versions (
  version_name, strategic_impact_weight, urgency_weight, actionability_weight,
  esmt_relevance_weight, evidence_confidence_weight, active
)
values ('prototype-v1', 30, 25, 20, 15, 10, true)
on conflict (version_name) do nothing;

create table if not exists public.signals (
  id uuid primary key default gen_random_uuid(),
  external_signal_id text unique not null,
  title text not null,
  signal_type text not null,
  programmes text[] not null default '{}',
  ranking_or_standard text not null,
  observed_at date not null,
  event_date_start date not null,
  event_date_end date not null,
  date_precision text not null,
  official_date_text text not null,
  date_assumption text,
  factual_summary text not null,
  verification_status text not null,
  independent_confirmation_count smallint not null default 0,
  esmt_interpretation text not null,
  recommended_action text not null,
  proposed_owner text,
  proposed_due_date date,
  status workflow_status not null default 'New',
  strategic_impact smallint not null check (strategic_impact between 0 and 5),
  urgency smallint not null check (urgency between 0 and 5),
  actionability smallint not null check (actionability between 0 and 5),
  esmt_relevance smallint not null check (esmt_relevance between 0 and 5),
  evidence_confidence smallint not null check (evidence_confidence between 0 and 5),
  score_override numeric check (score_override between 0 and 100),
  score_override_reason text,
  score_override_by uuid references auth.users(id),
  score_override_at timestamptz,
  resolution_note text,
  resolution_evidence_url text,
  resolved_by uuid references auth.users(id),
  resolved_at timestamptz,
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint event_window_order check (event_date_end >= event_date_start),
  constraint override_requires_reason check (
    score_override is null or length(trim(score_override_reason)) >= 10
  ),
  constraint closure_requires_resolution_evidence check (
    status <> 'Closed' or (
      length(trim(resolution_note)) >= 10 and
      length(trim(resolution_evidence_url)) >= 8 and
      resolved_at is not null
    )
  )
);

create table if not exists public.signal_sources (
  signal_id uuid not null references public.signals(id) on delete cascade,
  source_id uuid not null references public.sources(id) on delete restrict,
  locator text,
  evidence_note text,
  is_primary boolean not null default true,
  created_at timestamptz not null default now(),
  primary key (signal_id, source_id)
);

create table if not exists public.source_snapshots (
  id uuid primary key default gen_random_uuid(),
  source_id uuid not null references public.sources(id) on delete cascade,
  retrieved_at timestamptz not null,
  http_status integer,
  content_hash text not null,
  storage_path text not null,
  substantive_change boolean,
  reviewed_by uuid references auth.users(id),
  reviewed_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists public.signal_comments (
  id uuid primary key default gen_random_uuid(),
  signal_id uuid not null references public.signals(id) on delete cascade,
  author_id uuid not null references auth.users(id),
  body text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.audit_events (
  id bigint generated always as identity primary key,
  entity_type text not null,
  entity_id uuid not null,
  event_type text not null,
  actor_id uuid references auth.users(id),
  before_state jsonb,
  after_state jsonb,
  reason text,
  created_at timestamptz not null default now()
);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists sources_set_updated_at on public.sources;
create trigger sources_set_updated_at
before update on public.sources
for each row execute function public.set_updated_at();

drop trigger if exists signals_set_updated_at on public.signals;
create trigger signals_set_updated_at
before update on public.signals
for each row execute function public.set_updated_at();

create or replace function public.write_audit_event()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  target_id uuid;
begin
  if tg_op = 'DELETE' then
    target_id := old.id;
  else
    target_id := new.id;
  end if;
  insert into public.audit_events (
    entity_type,
    entity_id,
    event_type,
    actor_id,
    before_state,
    after_state
  ) values (
    tg_table_name,
    target_id,
    tg_op,
    auth.uid(),
    case when tg_op in ('UPDATE', 'DELETE') then to_jsonb(old) else null end,
    case when tg_op in ('INSERT', 'UPDATE') then to_jsonb(new) else null end
  );
  if tg_op = 'DELETE' then
    return old;
  end if;
  return new;
end;
$$;

drop trigger if exists audit_sources on public.sources;
create trigger audit_sources
after insert or update or delete on public.sources
for each row execute function public.write_audit_event();

drop trigger if exists audit_signals on public.signals;
create trigger audit_signals
after insert or update or delete on public.signals
for each row execute function public.write_audit_event();

drop trigger if exists audit_scoring_versions on public.scoring_versions;
create trigger audit_scoring_versions
after insert or update or delete on public.scoring_versions
for each row execute function public.write_audit_event();

create or replace view public.signal_priority as
select
  s.*,
  round((
    s.strategic_impact * v.strategic_impact_weight +
    s.urgency * v.urgency_weight +
    s.actionability * v.actionability_weight +
    s.esmt_relevance * v.esmt_relevance_weight +
    s.evidence_confidence * v.evidence_confidence_weight
  ) / 5.0, 1) as calculated_score,
  coalesce(s.score_override, round((
    s.strategic_impact * v.strategic_impact_weight +
    s.urgency * v.urgency_weight +
    s.actionability * v.actionability_weight +
    s.esmt_relevance * v.esmt_relevance_weight +
    s.evidence_confidence * v.evidence_confidence_weight
  ) / 5.0, 1)) as effective_score,
  case
    when coalesce(s.score_override, round((s.strategic_impact * v.strategic_impact_weight + s.urgency * v.urgency_weight + s.actionability * v.actionability_weight + s.esmt_relevance * v.esmt_relevance_weight + s.evidence_confidence * v.evidence_confidence_weight) / 5.0, 1)) >= v.act_now_min then 'Act now'::priority_band
    when coalesce(s.score_override, round((s.strategic_impact * v.strategic_impact_weight + s.urgency * v.urgency_weight + s.actionability * v.actionability_weight + s.esmt_relevance * v.esmt_relevance_weight + s.evidence_confidence * v.evidence_confidence_weight) / 5.0, 1)) >= v.plan_min then 'Plan'::priority_band
    when coalesce(s.score_override, round((s.strategic_impact * v.strategic_impact_weight + s.urgency * v.urgency_weight + s.actionability * v.actionability_weight + s.esmt_relevance * v.esmt_relevance_weight + s.evidence_confidence * v.evidence_confidence_weight) / 5.0, 1)) >= v.monitor_min then 'Monitor'::priority_band
    else 'Archive'::priority_band
  end as priority_band
from public.signals s
cross join public.scoring_versions v
where v.active = true;

alter table public.sources enable row level security;
alter table public.signals enable row level security;
alter table public.signal_sources enable row level security;
alter table public.source_snapshots enable row level security;
alter table public.signal_comments enable row level security;
alter table public.audit_events enable row level security;
alter table public.scoring_versions enable row level security;

-- Replace these broad authenticated-read policies with ESMT role claims before production.
drop policy if exists "authenticated users read sources" on public.sources;
create policy "authenticated users read sources" on public.sources for select to authenticated using (true);
drop policy if exists "authenticated users read signals" on public.signals;
create policy "authenticated users read signals" on public.signals for select to authenticated using (true);
drop policy if exists "authenticated users read signal sources" on public.signal_sources;
create policy "authenticated users read signal sources" on public.signal_sources for select to authenticated using (true);
drop policy if exists "authenticated users read scoring" on public.scoring_versions;
create policy "authenticated users read scoring" on public.scoring_versions for select to authenticated using (true);
drop policy if exists "authenticated users read comments" on public.signal_comments;
create policy "authenticated users read comments" on public.signal_comments for select to authenticated using (true);
drop policy if exists "authors insert comments" on public.signal_comments;
create policy "authors insert comments" on public.signal_comments for insert to authenticated with check (author_id = auth.uid());

-- Do not add anonymous write policies. Admin/reviewer mutation policies must use
-- verified role claims and should be tested separately before deployment.
