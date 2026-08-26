-- UI Playground Pro: safe schema + migration
create extension if not exists pgcrypto;

create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null default 'Untitled Playground',
  code jsonb not null default '{"html":"","css":"","js":""}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.projects add column if not exists user_id uuid references auth.users(id) on delete cascade;
alter table public.projects add column if not exists name text not null default 'Untitled Playground';
alter table public.projects add column if not exists code jsonb not null default '{"html":"","css":"","js":""}'::jsonb;
alter table public.projects add column if not exists created_at timestamptz not null default now();
alter table public.projects add column if not exists updated_at timestamptz not null default now();

-- Repair null/invalid code values.
update public.projects
set code = '{"html":"","css":"","js":""}'::jsonb
where code is null or jsonb_typeof(code) <> 'object';

alter table public.projects enable row level security;

drop policy if exists "Users can read own projects" on public.projects;
drop policy if exists "Users can insert own projects" on public.projects;
drop policy if exists "Users can update own projects" on public.projects;
drop policy if exists "Users can delete own projects" on public.projects;

create policy "Users can read own projects" on public.projects
for select using (auth.uid() = user_id);
create policy "Users can insert own projects" on public.projects
for insert with check (auth.uid() = user_id);
create policy "Users can update own projects" on public.projects
for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Users can delete own projects" on public.projects
for delete using (auth.uid() = user_id);

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists projects_updated_at on public.projects;
create trigger projects_updated_at
before update on public.projects
for each row execute function public.set_updated_at();

