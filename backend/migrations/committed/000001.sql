--! Previous: -
--! Hash: sha1:96b3ed263ff66be3b20d8987f03c180e5416ff1d

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
