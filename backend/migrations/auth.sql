-- login

create extension if not exists "pgcrypto";

-- after schema creation and before function creation

alter default privileges revoke execute on functions from public;

drop type if exists app.jwt_token cascade;
create type app.jwt_token as (
  role text,
  person_id integer,
  exp bigint
);

-- create or replace function app.current_user() returns app.person as $$
--     select *
--     from app.person
--     where id = nullif(current_setting('jwt.claims.person_id', true), '')::integer;
-- $$ language sql stable;

--- roles

DO $$
BEGIN
if exists (select 1 from pg_roles where rolname = 'app_user') then
  drop owned by app_user;
  drop role if exists app_user;
end if;
if exists (select 1 from pg_roles where rolname = 'anon') then
  drop owned by anon;
  drop role if exists anon;
end if;
if exists (select 1 from pg_roles where rolname = 'authenticated') then
  drop owned by authenticated;
  drop role if exists authenticated;
end if;
END
$$;

DO $$
BEGIN
-- TODO! Get the password from the environment
create role app_user login password 'app_user_password';

create role anon;
create role authenticated;

grant anon to app_user;
grant authenticated to app_user;

grant connect on database postgres to app_user;
grant usage on schema app to app_user;
END
$$;


-- grant usage on schema app to anon, authenticated;

-- grant select on table app.person to anon, authenticated;
-- grant update, delete on table app.person to authenticated;



