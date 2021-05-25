-- Add auth grants and functions

create or replace function forum_example.register_person (
    first_name text,
    last_name text,
    email text,
    password text
) returns forum_example.person as $$
declare
    person forum_example.person;
begin
    insert into forum_example.person (first_name, last_name)
    values (first_name, last_name)
    returning * into person;

    insert into forum_example_private.person_account (person_id, email, password_hash)
    values (person.id, email, crypt(password, gen_salt('bf')));

    return person;
end

$$ language plpgsql strict security definer;

-- login

create extension if not exists "pgcrypto";

drop type if exists forum_example.jwt_token cascade;
create type forum_example.jwt_token as (
  role text,
  person_id integer,
  exp bigint
);

create or replace function forum_example.current_person() returns forum_example.person as $$
    select *
    from forum_example.person
    where id = nullif(current_setting('jwt.claims.person_id', true), '')::integer;
$$ language sql stable;


create or replace function forum_example.authenticate (
    email text,
    password text
) returns forum_example.jwt_token as $$
declare
    account forum_example_private.person_account;
    _email text = email;
begin
    select a.* into account
    from forum_example_private.person_account as a
    where a.email = _email;

    if account.password_hash = crypt(password, account.password_hash) then
        return ('forum_example_person', account.person_id, extract(epoch from (now() + interval '2 days')))::forum_example.jwt_token;
    else
        return null;
    end if;
end;
$$ language plpgsql strict security definer;

comment on function forum_example.authenticate(text, text) is 'Creates a JWT token that will securely identify a person and give them certain permissions. This token expires in 2 days.';


--- roles

drop owned by forum_example_postgraphile;
drop role if exists forum_example_postgraphile;
create role forum_example_postgraphile login password 'xyz';

drop owned by forum_example_anonymous;
drop role if exists forum_example_anonymous;
create role forum_example_anonymous;
grant forum_example_anonymous to forum_example_postgraphile;

drop owned by forum_example_person;
drop role if exists forum_example_person;
create role forum_example_person;
grant forum_example_person to forum_example_postgraphile;

grant connect on database postgres to forum_example_postgraphile;
grant usage on schema forum_example to forum_example_postgraphile;


-- after schema creation and before function creation
alter default privileges revoke execute on functions from public;

grant usage on schema forum_example to forum_example_anonymous, forum_example_person;

grant select on table forum_example.person to forum_example_anonymous, forum_example_person;
grant update, delete on table forum_example.person to forum_example_person;

grant select on table forum_example.post to forum_example_anonymous, forum_example_person;
grant insert, update, delete on table forum_example.post to forum_example_person;
grant usage on sequence forum_example.post_id_seq to forum_example_person;

grant execute on function forum_example.person_full_name(forum_example.person) to forum_example_anonymous, forum_example_person;
grant execute on function forum_example.post_summary(forum_example.post, integer, text) to forum_example_anonymous, forum_example_person;
grant execute on function forum_example.person_latest_post(forum_example.person) to forum_example_anonymous, forum_example_person;
grant execute on function forum_example.search_posts(text) to forum_example_anonymous, forum_example_person;
grant execute on function forum_example.authenticate(text, text) to forum_example_anonymous, forum_example_person;
grant execute on function forum_example.current_person() to forum_example_anonymous, forum_example_person;

grant execute on function forum_example.register_person(text, text, text, text) to forum_example_anonymous;

-- policies

alter table forum_example.person enable row level security;
alter table forum_example.post enable row level security;

drop policy if exists select_person on forum_example.person;
create policy select_person on forum_example.person for select
  using (true);

drop policy if exists select_post on forum_example.post;
create policy select_post on forum_example.post for select
  using (true);

drop policy if exists update_person on forum_example.person;
create policy update_person on forum_example.person for update to forum_example_person
  using (id = nullif(current_setting('jwt.claims.person_id', true), '')::integer);

drop policy if exists delete_person on forum_example.person;
create policy delete_person on forum_example.person for delete to forum_example_person
  using (id = nullif(current_setting('jwt.claims.person_id', true), '')::integer);

drop policy if exists insert_post on forum_example.post;
create policy insert_post on forum_example.post for insert to forum_example_person
  with check (author_id = nullif(current_setting('jwt.claims.person_id', true), '')::integer);

drop policy if exists update_post on forum_example.post;
create policy update_post on forum_example.post for update to forum_example_person
  using (author_id = nullif(current_setting('jwt.claims.person_id', true), '')::integer);

drop policy if exists delete_post on forum_example.post;
create policy delete_post on forum_example.post for delete to forum_example_person
  using (author_id = nullif(current_setting('jwt.claims.person_id', true), '')::integer);

