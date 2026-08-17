-- Field Inspect: multi-user schema
-- Run this once in Supabase Dashboard -> SQL Editor -> New Query

create table if not exists inspections (
  id text primary key,
  date text not null,
  data jsonb not null,
  created_by uuid references auth.users(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index if not exists inspections_date_idx on inspections (date);

alter table inspections enable row level security;

-- Everyone on the team (any authenticated user) can read all inspections
create policy "authenticated users can read all inspections"
on inspections for select
to authenticated
using (true);

-- Any authenticated user can create an inspection (tagged as their own)
create policy "authenticated users can insert inspections"
on inspections for insert
to authenticated
with check (auth.uid() = created_by);

-- Any authenticated user can update any inspection (shared editing)
create policy "authenticated users can update any inspection"
on inspections for update
to authenticated
using (true);

-- Optional: allow deletes by anyone authenticated (comment out if you'd rather nobody deletes)
create policy "authenticated users can delete inspections"
on inspections for delete
to authenticated
using (true);
