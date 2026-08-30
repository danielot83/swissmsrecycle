-- ============================================================
-- SwissMS Recycle — schema
-- Run this in Supabase: SQL Editor → New query → paste → Run
-- ============================================================

create table if not exists listings (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now(),
  user_id uuid references auth.users not null,
  type text not null check (type in ('offer', 'request')),
  title text not null,
  description text,
  lab_name text,
  status text default 'open' check (status in ('open', 'closed'))
);

-- Row Level Security: only logged-in users can read or write,
-- and only the person who posted a listing can edit/delete it.
alter table listings enable row level security;

create policy "Logged in users can read the board"
on listings for select
using (auth.role() = 'authenticated');

create policy "Logged in users can post"
on listings for insert
with check (auth.uid() = user_id);

create policy "Owners can update their own listing"
on listings for update
using (auth.uid() = user_id);

create policy "Owners can delete their own listing"
on listings for delete
using (auth.uid() = user_id);

-- Realtime: so the board updates live for everyone without a refresh
alter publication supabase_realtime add table listings;
