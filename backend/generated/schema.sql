--
-- PostgreSQL database dump
--

-- Dumped from database version 13.2
-- Dumped by pg_dump version 13.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: app; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA app;


--
-- Name: protected; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA protected;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: submissions; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.submissions (
    id integer NOT NULL,
    name character varying NOT NULL,
    email_address character varying NOT NULL,
    age integer,
    gender character varying,
    country character varying,
    experience_rating integer,
    suggested_improvements character varying,
    referrer character varying,
    created_at date DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: TABLE submissions; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON TABLE app.submissions IS 'A person''s submission to the survey';


--
-- Name: COLUMN submissions.id; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON COLUMN app.submissions.id IS 'An unique incremental ID';


--
-- Name: COLUMN submissions.name; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON COLUMN app.submissions.name IS 'The person full name';


--
-- Name: COLUMN submissions.email_address; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON COLUMN app.submissions.email_address IS 'The person unverified email address';


--
-- Name: COLUMN submissions.age; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON COLUMN app.submissions.age IS 'The person age';


--
-- Name: COLUMN submissions.gender; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON COLUMN app.submissions.gender IS 'The person gender';


--
-- Name: COLUMN submissions.country; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON COLUMN app.submissions.country IS 'The country of origin';


--
-- Name: COLUMN submissions.experience_rating; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON COLUMN app.submissions.experience_rating IS 'A rating from 1 to 5';


--
-- Name: COLUMN submissions.suggested_improvements; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON COLUMN app.submissions.suggested_improvements IS 'A short opinion';


--
-- Name: COLUMN submissions.referrer; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON COLUMN app.submissions.referrer IS 'The URL of the referring page';


--
-- Name: COLUMN submissions.created_at; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON COLUMN app.submissions.created_at IS 'The date/time of the submission';


--
-- Name: age_stats; Type: VIEW; Schema: app; Owner: -
--

CREATE VIEW app.age_stats AS
 SELECT s2.age AS value,
    (count(*))::integer AS count,
    (((count(*))::double precision * (100)::double precision) / ((1 + tot_mem.total_members))::double precision) AS ratio
   FROM app.submissions s2,
    ( SELECT (count(*))::integer AS total_members
           FROM app.submissions s3) tot_mem
  GROUP BY s2.age, tot_mem.total_members
  ORDER BY ((count(*))::integer) DESC;


--
-- Name: VIEW age_stats; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON VIEW app.age_stats IS '@omit';


--
-- Name: country_stats; Type: VIEW; Schema: app; Owner: -
--

CREATE VIEW app.country_stats AS
 SELECT s2.country AS value,
    (count(*))::integer AS count,
    (((count(*))::double precision * (100)::double precision) / (tot_mem.total_members)::double precision) AS ratio
   FROM app.submissions s2,
    ( SELECT (count(*))::integer AS total_members
           FROM app.submissions s3) tot_mem
  GROUP BY s2.country, tot_mem.total_members
  ORDER BY ((count(*))::integer) DESC;


--
-- Name: VIEW country_stats; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON VIEW app.country_stats IS '@omit';


--
-- Name: experience_rating_stats; Type: VIEW; Schema: app; Owner: -
--

CREATE VIEW app.experience_rating_stats AS
 SELECT s2.experience_rating AS value,
    (count(*))::integer AS count,
    (((count(*))::double precision * (100)::double precision) / (tot_mem.total_members)::double precision) AS ratio
   FROM app.submissions s2,
    ( SELECT (count(*))::integer AS total_members
           FROM app.submissions s3) tot_mem
  GROUP BY s2.experience_rating, tot_mem.total_members
  ORDER BY ((count(*))::integer) DESC;


--
-- Name: VIEW experience_rating_stats; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON VIEW app.experience_rating_stats IS '@omit';


--
-- Name: gender_stats; Type: VIEW; Schema: app; Owner: -
--

CREATE VIEW app.gender_stats AS
 SELECT s2.gender AS value,
    (count(*))::integer AS count,
    (((count(*))::double precision * (100)::double precision) / (tot_mem.total_members)::double precision) AS ratio
   FROM app.submissions s2,
    ( SELECT (count(*))::integer AS total_members
           FROM app.submissions s3) tot_mem
  GROUP BY s2.gender, tot_mem.total_members
  ORDER BY ((count(*))::integer) DESC;


--
-- Name: VIEW gender_stats; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON VIEW app.gender_stats IS '@omit';


--
-- Name: submissions_statistics_view; Type: VIEW; Schema: app; Owner: -
--

CREATE VIEW app.submissions_statistics_view AS
 SELECT a.age,
    c.country,
    e.experience_rating,
    g.gender,
    t.total_submissions
   FROM ( SELECT array_agg(age_stats.*) AS age
           FROM app.age_stats) a,
    ( SELECT array_agg(country_stats.*) AS country
           FROM app.country_stats) c,
    ( SELECT array_agg(experience_rating_stats.*) AS experience_rating
           FROM app.experience_rating_stats) e,
    ( SELECT array_agg(gender_stats.*) AS gender
           FROM app.gender_stats) g,
    ( SELECT (count(*))::integer AS total_submissions
           FROM app.submissions) t;


--
-- Name: VIEW submissions_statistics_view; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON VIEW app.submissions_statistics_view IS '
@omit
@name submissions_statistics
';


--
-- Name: submissions_statistics(); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.submissions_statistics() RETURNS app.submissions_statistics_view
    LANGUAGE sql STABLE
    AS $$
  SELECT *
  FROM submissions_statistics_view
  LIMIT 1
$$;


--
-- Name: submissions_id_seq; Type: SEQUENCE; Schema: app; Owner: -
--

CREATE SEQUENCE app.submissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: app; Owner: -
--

ALTER SEQUENCE app.submissions_id_seq OWNED BY app.submissions.id;


--
-- Name: submissions id; Type: DEFAULT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.submissions ALTER COLUMN id SET DEFAULT nextval('app.submissions_id_seq'::regclass);


--
-- Name: submissions PK_10b3be95b8b2fb1e482e07d706b; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.submissions
    ADD CONSTRAINT "PK_10b3be95b8b2fb1e482e07d706b" PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

