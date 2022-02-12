--! Previous: -
--! Hash: sha1:2420a9a32121ea4d394a77f40941e9a264256f22

DROP TABLE IF EXISTS submissions CASCADE;

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

COMMENT ON TABLE public.submissions IS 'A person''s submission to the survey';

COMMENT ON COLUMN public.submissions.id IS 'An unique incremental ID';
COMMENT ON COLUMN public.submissions.name IS 'The person full name';
COMMENT ON COLUMN public.submissions.email_address IS 'The person unverified email address';
COMMENT ON COLUMN public.submissions.age IS 'The person age';
COMMENT ON COLUMN public.submissions.gender IS 'The person gender';
COMMENT ON COLUMN public.submissions.country IS 'The country of origin';
COMMENT ON COLUMN public.submissions.experience_rating IS 'A rating from 1 to 5';
COMMENT ON COLUMN public.submissions.suggested_improvements IS 'A short opinion';
COMMENT ON COLUMN public.submissions.referrer IS 'The URL of the referring page';
COMMENT ON COLUMN public.submissions.created_at IS 'The date/time of the submission';
