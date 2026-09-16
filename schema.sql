-- Morena Rides V5 Supabase schema
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  role text not null default 'rider' check (role in ('rider','driver','admin')),
  phone text,
  vehicle text,
  is_online boolean default false,
  lat double precision,
  lng double precision,
  updated_at timestamptz default now()
);

create table if not exists public.rides (
  id uuid primary key default gen_random_uuid(),
  rider_id uuid references public.profiles(id),
  driver_id uuid references public.profiles(id),
  pickup_text text not null,
  destination_text text not null,
  pickup_lat double precision,
  pickup_lng double precision,
  destination_lat double precision,
  destination_lng double precision,
  distance_km numeric(8,2) not null,
  fare numeric(10,2) not null,
  payment_method text not null check(payment_method in ('Cash','EFT')),
  status text not null default 'requested' check(status in ('requested','accepted','arrived','in_progress','completed','cancelled')),
  created_at timestamptz default now(),
  accepted_at timestamptz,
  completed_at timestamptz
);

alter table public.profiles enable row level security;
alter table public.rides enable row level security;

-- V5 TEST/DEVELOPMENT policies. Tighten these before public launch.
drop policy if exists "profiles readable" on public.profiles;
create policy "profiles readable" on public.profiles for select using (true);

drop policy if exists "profiles self insert" on public.profiles;
create policy "profiles self insert" on public.profiles for insert with check (auth.uid()=id);

drop policy if exists "profiles self update" on public.profiles;
create policy "profiles self update" on public.profiles for update using (auth.uid()=id);

drop policy if exists "rides readable" on public.rides;
create policy "rides readable" on public.rides for select using (true);

drop policy if exists "riders create rides" on public.rides;
create policy "riders create rides" on public.rides for insert with check (auth.uid()=rider_id);

drop policy if exists "ride participants update" on public.rides;
create policy "ride participants update" on public.rides for update using (auth.uid()=rider_id or auth.uid()=driver_id or driver_id is null);

-- Realtime publication (safe to run repeatedly only if tables are not already members).
do $$ begin
  alter publication supabase_realtime add table public.profiles;
exception when duplicate_object then null; end $$;
do $$ begin
  alter publication supabase_realtime add table public.rides;
exception when duplicate_object then null; end $$;
