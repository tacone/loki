CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
-- CREATE EXTENSION IF NOT EXISTS "pg_cron";

DO $$
BEGIN
IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'auth_user') then
  DROP owned BY auth_user;
  DROP ROLE IF EXISTS auth_user;
END IF;
CREATE ROLE auth_user LOGIN PASSWORD 'authpassword';

GRANT CONNECT ON DATABASE postgres TO auth_user;
END
$$;

CREATE SCHEMA IF NOT EXISTS auth AUTHORIZATION auth_user;
GRANT usage ON SCHEMA auth TO auth_user;


-- auth.users definition
CREATE TABLE auth.users (
	instance_id uuid NULL,
	id uuid NOT NULL,
	aud varchar(255) NULL,
	"role" varchar(255) NULL,
	email varchar(255) NULL,
	encrypted_password varchar(255) NULL,
	confirmed_at timestamptz NULL,
	invited_at timestamptz NULL,
	confirmation_token varchar(255) NULL,
	confirmation_sent_at timestamptz NULL,
	recovery_token varchar(255) NULL,
	recovery_sent_at timestamptz NULL,
	email_change_token varchar(255) NULL,
	email_change varchar(255) NULL,
	email_change_sent_at timestamptz NULL,
	last_sign_in_at timestamptz NULL,
	raw_app_meta_data jsonb NULL,
	raw_user_meta_data jsonb NULL,
	is_super_admin bool NULL,
	created_at timestamptz NULL,
	updated_at timestamptz NULL,
	CONSTRAINT users_pkey PRIMARY KEY (id)
);
CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, email);
CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);
-- auth.refresh_tokens definition
CREATE TABLE auth.refresh_tokens (
	instance_id uuid NULL,
	id bigserial NOT NULL,
	"token" varchar(255) NULL,
	user_id varchar(255) NULL,
	revoked bool NULL,
	created_at timestamptz NULL,
	updated_at timestamptz NULL,
	CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id)
);
CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);
CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);
CREATE INDEX refresh_tokens_token_idx ON auth.refresh_tokens USING btree (token);
-- auth.instances definition
CREATE TABLE auth.instances (
	id uuid NOT NULL,
	uuid uuid NULL,
	raw_base_config text NULL,
	created_at timestamptz NULL,
	updated_at timestamptz NULL,
	CONSTRAINT instances_pkey PRIMARY KEY (id)
);
-- auth.audit_log_entries definition
CREATE TABLE auth.audit_log_entries (
	instance_id uuid NULL,
	id uuid NOT NULL,
	payload json NULL,
	created_at timestamptz NULL,
	CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id)
);
CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);
-- auth.schema_migrations definition
CREATE TABLE auth.schema_migrations (
	"version" varchar(255) NOT NULL,
	CONSTRAINT schema_migrations_pkey PRIMARY KEY ("version")
);
INSERT INTO auth.schema_migrations (version)
VALUES  ('20171026211738'),
        ('20171026211808'),
        ('20171026211834'),
        ('20180103212743'),
        ('20180108183307'),
        ('20180119214651'),
        ('20180125194653');
-- auth.identities definition
CREATE TABLE auth.identities (
	id uuid NOT NULL,
	access_key text NOT NULL,
	secret_key text NOT NULL,
	user_token text DEFAULT NULL,
	user_id uuid NOT NULL,
	CONSTRAINT identities_pkey PRIMARY KEY (id)
);
-- auth.templates definition
CREATE TABLE auth.templates
(
	id uuid NOT NULL,
	aud varchar(255),
	type varchar(50),
	subject text,
	url text DEFAULT '/',
  base_url varchar(255),
  url_template text,
  CONSTRAINT templates_pkey PRIMARY KEY (id)
);

GRANT ALL PRIVILEGES ON SCHEMA auth TO auth_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA auth TO auth_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA auth TO auth_user;
ALTER USER auth_user SET search_path = "$user",auth,public;
