-- Run this once in Supabase Dashboard → SQL Editor

-- ── Checklist items ────────────────────────────────────────────────────────
create table if not exists wedding_checklist (
  id          text primary key,
  checked     boolean default false,
  checked_by  text    default null,
  updated_at  timestamptz default now()
);

alter table wedding_checklist enable row level security;

create policy "public read"   on wedding_checklist for select using (true);
create policy "public update" on wedding_checklist for update using (true);

insert into wedding_checklist (id) values
  ('venue-tents'), ('venue-lighting'), ('venue-tables'), ('venue-chairs'),
  ('venue-transport'), ('venue-linens'), ('venue-pa'),
  ('food-food'), ('food-beer'), ('food-cocktails'), ('food-whisky'),
  ('food-water'), ('food-soda'),
  ('mc-mc'), ('mc-raffle'), ('mc-auction'), ('mc-auction-items'),
  ('mc-shopping'), ('mc-fuel'), ('mc-vehicle'), ('mc-spa')
on conflict (id) do nothing;

alter publication supabase_realtime add table wedding_checklist;

-- ── Comments ───────────────────────────────────────────────────────────────
create table if not exists wedding_checklist_comments (
  id         uuid primary key default gen_random_uuid(),
  item_id    text not null references wedding_checklist(id),
  author     text not null,
  body       text not null,
  created_at timestamptz default now()
);

alter table wedding_checklist_comments enable row level security;

create policy "public read"   on wedding_checklist_comments for select using (true);
create policy "public insert" on wedding_checklist_comments for insert with check (true);
create policy "public delete" on wedding_checklist_comments for delete using (true);

alter publication supabase_realtime add table wedding_checklist_comments;
