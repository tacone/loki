--! Previous: sha1:20bd94ba1b8150e24a449ab97bb3d9ca4082947c
--! Hash: sha1:0ff9d2993444030effc42e4bc16c467f9cf5fbd5
--! Message: create forum schema

-- users

drop table if exists forum_example.person cascade;
create table forum_example.person (
  id               serial primary key,
  first_name       text not null check (char_length(first_name) < 80),
  last_name        text check (char_length(last_name) < 80),
  about            text,
  created_at       timestamp default now()
);

comment on table forum_example.person is 'A user of the forum.';
comment on column forum_example.person.id is 'The primary unique identifier for the person.';
comment on column forum_example.person.first_name is 'The person’s first name.';
comment on column forum_example.person.last_name is 'The person’s last name.';
comment on column forum_example.person.about is 'A short description about the user, written by the user.';
comment on column forum_example.person.created_at is 'The time this person was created.';

-- posts

drop type if exists forum_example.post_topic cascade;
create type forum_example.post_topic as enum (
  'discussion',
  'inspiration',
  'help',
  'showcase'
);

drop table if exists forum_example.post cascade;
create table forum_example.post (
  id               serial primary key,
  author_id        integer not null references forum_example.person(id),
  headline         text not null check (char_length(headline) < 280),
  body             text,
  topic            forum_example.post_topic,
  created_at       timestamp default now()
);

comment on table forum_example.post is 'A forum post written by a user.';
comment on column forum_example.post.id is 'The primary key for the post.';
comment on column forum_example.post.headline is 'The title written by the user.';
comment on column forum_example.post.author_id is 'The id of the author user.';
comment on column forum_example.post.topic is 'The topic this has been posted in.';
comment on column forum_example.post.body is 'The main body text of our post.';
comment on column forum_example.post.created_at is 'The time this post was created.';

-- functions

create or replace function forum_example.person_full_name(person forum_example.person) returns text as $$
  select trim(concat(person.first_name, ' ', person.last_name))
$$ language sql stable;

comment on function forum_example.person_full_name(forum_example.person) is 'A person’s full name which is a concatenation of their first and last name.';

create or replace function forum_example.post_summary (
    post forum_example.post,
    length int default 50,
    omission text default '…'
) returns text as $$
    select case
        when post.body is null then null
        else concat(substr(post.body, 0, length), omission)
    end
$$ language sql stable;

comment on function forum_example.post_summary(forum_example.post, int, text) is 'A truncated version of the body for summaries.';

create or replace function forum_example.person_latest_post(person forum_example.person)
returns forum_example.post as $$
    select post.*
    from forum_example.post
    where post.author_id = person.id
    order by post.created_at desc
    limit 1
$$ language sql stable;

comment on function forum_example.person_latest_post(forum_example.person) is 'Get’s the latest post written by the person.';

-- search

create or replace function forum_example.search_posts(search text)
returns setof forum_example.post as $$
  select post.*
  from forum_example.post as post
  where position(search in post.headline) > 0 or position(search in post.body) > 0
$$ language sql stable;

-- triggers

alter table forum_example.person add column updated_at timestamp default now();
alter table forum_example.post add column updated_at timestamp default now();

create or replace function forum_example_private.set_updated_at()
returns trigger as $$
    begin
        new.updated_at := current_timestamp;
        return new;
    end;
$$ language plpgsql;

create trigger person_updated_at before update
on forum_example.person
    for each row
    execute procedure forum_example_private.set_updated_at();

create trigger post_updated_at before update
on forum_example.post
    for each row
    execute procedure forum_example_private.set_updated_at();

-- authorization

drop table if exists forum_example_private.person_account cascade;
create table forum_example_private.person_account (
    person_id   integer primary key references forum_example.person(id) on delete cascade,
    email       text not null unique check ( email ~* '^.+@.+\..+$' ),
    password_hash text not null
);

comment on table forum_example_private.person_account is 'Private information about a person’s account.';
comment on column forum_example_private.person_account.person_id is 'The id of the person associated with this account.';
comment on column forum_example_private.person_account.email is 'The email address of the person.';
comment on column forum_example_private.person_account.password_hash is 'An opaque hash of the person’s password.';
