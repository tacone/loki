-- ----------------------------------------------------
-- Setup the extensions
-- ----------------------------------------------------


create extension if not exists "uuid-ossp";

-- ----------------------------------------------------
-- Utility Functions
-- ----------------------------------------------------

-- we need an advisory lock to create the functions

begin;
select pg_advisory_xact_lock(2142616474639426746); -- random 64-bit signed ('bigint') lock number

create or replace function uuid_timestamp(id uuid) returns timestamptz as $$
  select timestamp with time zone 'epoch' +
      (((('x' || lpad(split_part(id::text, '-', 1), 16, '0'))::bit(64)::bigint) +
      (('x' || lpad(split_part(id::text, '-', 2), 16, '0'))::bit(64)::bigint << 32) +
      ((('x' || lpad(split_part(id::text, '-', 3), 16, '0'))::bit(64)::bigint&4095) << 48) - 122192928000000000) / 10000000 ) * interval '1 second';
$$ language sql
  immutable
  returns null on null input;
commit;

-- ----------------------------------------------------
-- Triggers
-- ----------------------------------------------------

create or replace function trigger_set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- ----------------------------------------------------
-- Tables
-- ----------------------------------------------------

drop table if exists feeds cascade;

create table feeds (
  id uuid primary key not null default uuid_generate_v1mc(),
  name text not null,
  url text not null unique,
  created_at timestamptz not null default now()
);

drop table if exists downloads cascade;

create table downloads (
  id uuid primary key not null default uuid_generate_v1mc(),
  "feed_id" uuid not null references feeds(id) on delete cascade,
  blob text not null,
  content json not null,
  created_at timestamptz default now()
);


create or replace view "stale_feeds" as
select * from downloads d where created_at <= now() - interval '1 minute seconds';

comment on view "stale_feeds" is '@omit';

drop table if exists items cascade;

create table items (
  --"id" uuid primary key default uuid_generate_v1mc(),
  "id" uuid generated always as (md5(feed_id::text || link::text)::uuid) stored primary key,
  "feed_id" uuid not null references feeds(id) on delete cascade,
  "title" text not null,
  "link" text not null,
  "date" timestamptz not null,
  "summary" text not null,
  "content" text,
  "author" text,
  "created_at" timestamptz default now(),
  "updated_at" timestamptz default now()
);

create trigger set_timestamp before update on items
for each row execute procedure trigger_set_updated_at();

drop function if exists import_items(uuid);
create or replace function import_items (download_id uuid) returns "items" as $$
  insert into items (
    "feed_id",
    "title",
    "link",
    "date",
    "summary",
    "content",
    "author"
  ) select
      feed_id,
      items ->> 'title' title,
      items ->> 'link' link,
      (items->> 'date')::timestamptz,
      items ->> 'summary' "summary",
      items -> 'content:encoded' ->> '#' "content",
      items ->> 'author' author
  from
    downloads d,
    json_array_elements(d."content" -> 'items') as items
  where d.id = download_id
  on conflict (id) do update set
      title = excluded.title,
      link = excluded.link,
      date = excluded.date,
      summary = excluded.summary,
      content = excluded.content,
      author = excluded.author
  returning *;
$$ language sql volatile;


