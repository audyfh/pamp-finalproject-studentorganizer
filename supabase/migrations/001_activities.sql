-- Migration: Tabel Activities (Fitur 4 - Kegiatan Mahasiswa)
-- Acuan: docs/SRS.md §5.3

create table if not exists public.activities (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name text not null check (length(trim(name)) > 0),
  activity_date date not null,
  start_time time not null,
  end_time time not null,
  location text not null,
  organizer text not null,
  description text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (end_time > start_time)
);

-- Fungsi & trigger updated_at otomatis
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_activities_updated on public.activities;
create trigger trg_activities_updated
  before update on public.activities
  for each row execute function public.set_updated_at();

-- Index untuk query daftar kegiatan per user
create index if not exists activities_user_date_idx
  on public.activities (user_id, activity_date);

-- Row Level Security
alter table public.activities enable row level security;

drop policy if exists "own rows" on public.activities;
create policy "own rows" on public.activities
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());
