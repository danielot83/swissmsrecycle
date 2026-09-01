-- ============================================================
-- SwissMS Recycle — schema (v2)
-- Run this in Supabase: SQL Editor → New query → paste → Run
--
-- If you already ran the old schema.sql, this file is safe to
-- run again — it only creates what's missing and adds new
-- columns without touching data you already have.
-- ============================================================

-- ---------- Profiles ----------
-- One row per user, filled in right after sign up. Holds the
-- info that should show up on their listings (name, institution).
create table if not exists profiles (
  id uuid references auth.users on delete cascade primary key,
  full_name text,
  organization text,           -- company / university
  email text,
  created_at timestamptz default now()
);

alter table profiles add column if not exists email text;

alter table profiles enable row level security;

drop policy if exists "Logged in users can read profiles" on profiles;
create policy "Logged in users can read profiles"
on profiles for select
using (auth.role() = 'authenticated');

drop policy if exists "Users can insert their own profile" on profiles;
create policy "Users can insert their own profile"
on profiles for insert
with check (auth.uid() = id);

drop policy if exists "Users can update their own profile" on profiles;
create policy "Users can update their own profile"
on profiles for update
using (auth.uid() = id);

-- ---------- Listings ----------
create table if not exists listings (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now(),
  user_id uuid references auth.users not null,
  type text not null check (type in ('offer', 'request')),
  title text not null,
  description text,
  category text,                -- Instrument / Column / Consumable / Standard / Spare part / Other
  brand text,                    -- manufacturer, e.g. Waters, Thermo, Agilent, Bruker, Sciex
  model text,                    -- model name/number
  condition text,                -- New / Like new / Good / Fair / Needs repair / For parts
  location text,
  organization text,             -- lab / university, shown + filterable
  contact_email text,
  construction_year int,
  photo_url text,
  status text default 'open' check (status in ('open', 'closed'))
);

-- If you already had the old, simpler listings table, this adds
-- the new columns on top of it without losing existing rows.
alter table listings add column if not exists category text;
alter table listings add column if not exists brand text;
alter table listings add column if not exists model text;
alter table listings add column if not exists condition text;
alter table listings add column if not exists location text;
alter table listings add column if not exists organization text;
alter table listings add column if not exists contact_email text;
alter table listings add column if not exists construction_year int;
alter table listings add column if not exists photo_url text;

alter table listings enable row level security;

drop policy if exists "Logged in users can read the board" on listings;
create policy "Logged in users can read the board"
on listings for select
using (auth.role() = 'authenticated');

drop policy if exists "Logged in users can post" on listings;
create policy "Logged in users can post"
on listings for insert
with check (auth.uid() = user_id);

drop policy if exists "Owners can update their own listing" on listings;
create policy "Owners can update their own listing"
on listings for update
using (auth.uid() = user_id);

drop policy if exists "Owners can delete their own listing" on listings;
create policy "Owners can delete their own listing"
on listings for delete
using (auth.uid() = user_id);

alter publication supabase_realtime add table listings;

-- ---------- Storage bucket for listing photos ----------
-- Run this part once. If it complains the bucket already exists,
-- that's fine — skip that line and run the rest.
insert into storage.buckets (id, name, public)
values ('listing-photos', 'listing-photos', true)
on conflict (id) do nothing;

drop policy if exists "Anyone can view listing photos" on storage.objects;
create policy "Anyone can view listing photos"
on storage.objects for select
using (bucket_id = 'listing-photos');

drop policy if exists "Logged in users can upload listing photos" on storage.objects;
create policy "Logged in users can upload listing photos"
on storage.objects for insert
with check (bucket_id = 'listing-photos' and auth.role() = 'authenticated');
