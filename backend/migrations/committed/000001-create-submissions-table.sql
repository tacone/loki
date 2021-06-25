--! Previous: -
--! Hash: sha1:2420a9a32121ea4d394a77f40941e9a264256f22
--! AllowInvalidHash

create schema if not exists app;
create schema if not exists protected;


DROP TABLE IF EXISTS submissions;

CREATE TABLE submissions (
	id serial NOT NULL,
	"name" varchar NOT NULL,
	email_address varchar NOT NULL,
	age int4 NULL,
	gender varchar NULL,
	country varchar NULL,
	experience_rating int4 NULL,
	suggested_improvements varchar NULL,
	referrer varchar NULL,
	created_at date NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT "PK_10b3be95b8b2fb1e482e07d706b" PRIMARY KEY (id)
);

COMMENT ON TABLE submissions IS 'A person''s submission to the survey';

COMMENT ON COLUMN submissions.id IS 'An unique incremental ID';
COMMENT ON COLUMN submissions.name IS 'The person full name';
COMMENT ON COLUMN submissions.email_address IS 'The person unverified email address';
COMMENT ON COLUMN submissions.age IS 'The person age';
COMMENT ON COLUMN submissions.gender IS 'The person gender';
COMMENT ON COLUMN submissions.country IS 'The country of origin';
COMMENT ON COLUMN submissions.experience_rating IS 'A rating from 1 to 5';
COMMENT ON COLUMN submissions.suggested_improvements IS 'A short opinion';
COMMENT ON COLUMN submissions.referrer IS 'The URL of the referring page';
COMMENT ON COLUMN submissions.created_at IS 'The date/time of the submission';
