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
-- Name: forum_example; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA forum_example;


--
-- Name: forum_example_private; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA forum_example_private;


--
-- Name: post_topic; Type: TYPE; Schema: forum_example; Owner: -
--

CREATE TYPE forum_example.post_topic AS ENUM (
    'discussion',
    'inspiration',
    'help',
    'showcase'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: person; Type: TABLE; Schema: forum_example; Owner: -
--

CREATE TABLE forum_example.person (
    id integer NOT NULL,
    first_name text NOT NULL,
    last_name text,
    about text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT person_first_name_check CHECK ((char_length(first_name) < 80)),
    CONSTRAINT person_last_name_check CHECK ((char_length(last_name) < 80))
);


--
-- Name: TABLE person; Type: COMMENT; Schema: forum_example; Owner: -
--

COMMENT ON TABLE forum_example.person IS 'A user of the forum.';


--
-- Name: COLUMN person.id; Type: COMMENT; Schema: forum_example; Owner: -
--

COMMENT ON COLUMN forum_example.person.id IS 'The primary unique identifier for the person.';


--
-- Name: COLUMN person.first_name; Type: COMMENT; Schema: forum_example; Owner: -
--

COMMENT ON COLUMN forum_example.person.first_name IS 'The person’s first name.';


--
-- Name: COLUMN person.last_name; Type: COMMENT; Schema: forum_example; Owner: -
--

COMMENT ON COLUMN forum_example.person.last_name IS 'The person’s last name.';


--
-- Name: COLUMN person.about; Type: COMMENT; Schema: forum_example; Owner: -
--

COMMENT ON COLUMN forum_example.person.about IS 'A short description about the user, written by the user.';


--
-- Name: COLUMN person.created_at; Type: COMMENT; Schema: forum_example; Owner: -
--

COMMENT ON COLUMN forum_example.person.created_at IS 'The time this person was created.';


--
-- Name: person_full_name(forum_example.person); Type: FUNCTION; Schema: forum_example; Owner: -
--

CREATE FUNCTION forum_example.person_full_name(person forum_example.person) RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select trim(concat(person.first_name, ' ', person.last_name))
$$;


--
-- Name: FUNCTION person_full_name(person forum_example.person); Type: COMMENT; Schema: forum_example; Owner: -
--

COMMENT ON FUNCTION forum_example.person_full_name(person forum_example.person) IS 'A person’s full name which is a concatenation of their first and last name.';


--
-- Name: post; Type: TABLE; Schema: forum_example; Owner: -
--

CREATE TABLE forum_example.post (
    id integer NOT NULL,
    author_id integer NOT NULL,
    headline text NOT NULL,
    body text,
    topic forum_example.post_topic,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT post_headline_check CHECK ((char_length(headline) < 280))
);


--
-- Name: TABLE post; Type: COMMENT; Schema: forum_example; Owner: -
--

COMMENT ON TABLE forum_example.post IS 'A forum post written by a user.';


--
-- Name: COLUMN post.id; Type: COMMENT; Schema: forum_example; Owner: -
--

COMMENT ON COLUMN forum_example.post.id IS 'The primary key for the post.';


--
-- Name: COLUMN post.author_id; Type: COMMENT; Schema: forum_example; Owner: -
--

COMMENT ON COLUMN forum_example.post.author_id IS 'The id of the author user.';


--
-- Name: COLUMN post.headline; Type: COMMENT; Schema: forum_example; Owner: -
--

COMMENT ON COLUMN forum_example.post.headline IS 'The title written by the user.';


--
-- Name: COLUMN post.body; Type: COMMENT; Schema: forum_example; Owner: -
--

COMMENT ON COLUMN forum_example.post.body IS 'The main body text of our post.';


--
-- Name: COLUMN post.topic; Type: COMMENT; Schema: forum_example; Owner: -
--

COMMENT ON COLUMN forum_example.post.topic IS 'The topic this has been posted in.';


--
-- Name: COLUMN post.created_at; Type: COMMENT; Schema: forum_example; Owner: -
--

COMMENT ON COLUMN forum_example.post.created_at IS 'The time this post was created.';


--
-- Name: person_latest_post(forum_example.person); Type: FUNCTION; Schema: forum_example; Owner: -
--

CREATE FUNCTION forum_example.person_latest_post(person forum_example.person) RETURNS forum_example.post
    LANGUAGE sql STABLE
    AS $$
    select post.*
    from forum_example.post
    where post.author_id = person.id
    order by post.created_at desc
    limit 1
$$;


--
-- Name: FUNCTION person_latest_post(person forum_example.person); Type: COMMENT; Schema: forum_example; Owner: -
--

COMMENT ON FUNCTION forum_example.person_latest_post(person forum_example.person) IS 'Get’s the latest post written by the person.';


--
-- Name: post_summary(forum_example.post, integer, text); Type: FUNCTION; Schema: forum_example; Owner: -
--

CREATE FUNCTION forum_example.post_summary(post forum_example.post, length integer DEFAULT 50, omission text DEFAULT '…'::text) RETURNS text
    LANGUAGE sql STABLE
    AS $$
    select case
        when post.body is null then null
        else concat(substr(post.body, 0, length), omission)
    end
$$;


--
-- Name: FUNCTION post_summary(post forum_example.post, length integer, omission text); Type: COMMENT; Schema: forum_example; Owner: -
--

COMMENT ON FUNCTION forum_example.post_summary(post forum_example.post, length integer, omission text) IS 'A truncated version of the body for summaries.';


--
-- Name: search_posts(text); Type: FUNCTION; Schema: forum_example; Owner: -
--

CREATE FUNCTION forum_example.search_posts(search text) RETURNS SETOF forum_example.post
    LANGUAGE sql STABLE
    AS $$
  select post.*
  from forum_example.post as post
  where position(search in post.headline) > 0 or position(search in post.body) > 0
$$;


--
-- Name: set_updated_at(); Type: FUNCTION; Schema: forum_example_private; Owner: -
--

CREATE FUNCTION forum_example_private.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    begin
        new.updated_at := current_timestamp;
        return new;
    end;
$$;


--
-- Name: submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.submissions (
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
-- Name: TABLE submissions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.submissions IS 'A person''s submission to the survey';


--
-- Name: COLUMN submissions.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.submissions.id IS 'An unique incremental ID';


--
-- Name: COLUMN submissions.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.submissions.name IS 'The person full name';


--
-- Name: COLUMN submissions.email_address; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.submissions.email_address IS 'The person unverified email address';


--
-- Name: COLUMN submissions.age; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.submissions.age IS 'The person age';


--
-- Name: COLUMN submissions.gender; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.submissions.gender IS 'The person gender';


--
-- Name: COLUMN submissions.country; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.submissions.country IS 'The country of origin';


--
-- Name: COLUMN submissions.experience_rating; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.submissions.experience_rating IS 'A rating from 1 to 5';


--
-- Name: COLUMN submissions.suggested_improvements; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.submissions.suggested_improvements IS 'A short opinion';


--
-- Name: COLUMN submissions.referrer; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.submissions.referrer IS 'The URL of the referring page';


--
-- Name: COLUMN submissions.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.submissions.created_at IS 'The date/time of the submission';


--
-- Name: age_stats; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.age_stats AS
 SELECT s2.age AS value,
    (count(*))::integer AS count,
    (((count(*))::double precision * (100)::double precision) / ((1 + tot_mem.total_members))::double precision) AS ratio
   FROM public.submissions s2,
    ( SELECT (count(*))::integer AS total_members
           FROM public.submissions s3) tot_mem
  GROUP BY s2.age, tot_mem.total_members
  ORDER BY ((count(*))::integer) DESC;


--
-- Name: VIEW age_stats; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.age_stats IS '@omit';


--
-- Name: country_stats; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.country_stats AS
 SELECT s2.country AS value,
    (count(*))::integer AS count,
    (((count(*))::double precision * (100)::double precision) / (tot_mem.total_members)::double precision) AS ratio
   FROM public.submissions s2,
    ( SELECT (count(*))::integer AS total_members
           FROM public.submissions s3) tot_mem
  GROUP BY s2.country, tot_mem.total_members
  ORDER BY ((count(*))::integer) DESC;


--
-- Name: VIEW country_stats; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.country_stats IS '@omit';


--
-- Name: experience_rating_stats; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.experience_rating_stats AS
 SELECT s2.experience_rating AS value,
    (count(*))::integer AS count,
    (((count(*))::double precision * (100)::double precision) / (tot_mem.total_members)::double precision) AS ratio
   FROM public.submissions s2,
    ( SELECT (count(*))::integer AS total_members
           FROM public.submissions s3) tot_mem
  GROUP BY s2.experience_rating, tot_mem.total_members
  ORDER BY ((count(*))::integer) DESC;


--
-- Name: VIEW experience_rating_stats; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.experience_rating_stats IS '@omit';


--
-- Name: gender_stats; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.gender_stats AS
 SELECT s2.gender AS value,
    (count(*))::integer AS count,
    (((count(*))::double precision * (100)::double precision) / (tot_mem.total_members)::double precision) AS ratio
   FROM public.submissions s2,
    ( SELECT (count(*))::integer AS total_members
           FROM public.submissions s3) tot_mem
  GROUP BY s2.gender, tot_mem.total_members
  ORDER BY ((count(*))::integer) DESC;


--
-- Name: VIEW gender_stats; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.gender_stats IS '@omit';


--
-- Name: submissions_statistics_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.submissions_statistics_view AS
 SELECT a.age,
    c.country,
    e.experience_rating,
    g.gender,
    t.total_submissions
   FROM ( SELECT array_agg(age_stats.*) AS age
           FROM public.age_stats) a,
    ( SELECT array_agg(country_stats.*) AS country
           FROM public.country_stats) c,
    ( SELECT array_agg(experience_rating_stats.*) AS experience_rating
           FROM public.experience_rating_stats) e,
    ( SELECT array_agg(gender_stats.*) AS gender
           FROM public.gender_stats) g,
    ( SELECT (count(*))::integer AS total_submissions
           FROM public.submissions) t;


--
-- Name: VIEW submissions_statistics_view; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW public.submissions_statistics_view IS '
@omit
@name submissions_statistics
';


--
-- Name: submissions_statistics(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.submissions_statistics() RETURNS public.submissions_statistics_view
    LANGUAGE sql STABLE
    AS $$
  SELECT *
  FROM submissions_statistics_view
  LIMIT 1
$$;


--
-- Name: person_id_seq; Type: SEQUENCE; Schema: forum_example; Owner: -
--

CREATE SEQUENCE forum_example.person_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_id_seq; Type: SEQUENCE OWNED BY; Schema: forum_example; Owner: -
--

ALTER SEQUENCE forum_example.person_id_seq OWNED BY forum_example.person.id;


--
-- Name: post_id_seq; Type: SEQUENCE; Schema: forum_example; Owner: -
--

CREATE SEQUENCE forum_example.post_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: post_id_seq; Type: SEQUENCE OWNED BY; Schema: forum_example; Owner: -
--

ALTER SEQUENCE forum_example.post_id_seq OWNED BY forum_example.post.id;


--
-- Name: person_account; Type: TABLE; Schema: forum_example_private; Owner: -
--

CREATE TABLE forum_example_private.person_account (
    person_id integer NOT NULL,
    email text NOT NULL,
    password_hash text NOT NULL,
    CONSTRAINT person_account_email_check CHECK ((email ~* '^.+@.+\..+$'::text))
);


--
-- Name: TABLE person_account; Type: COMMENT; Schema: forum_example_private; Owner: -
--

COMMENT ON TABLE forum_example_private.person_account IS 'Private information about a person’s account.';


--
-- Name: COLUMN person_account.person_id; Type: COMMENT; Schema: forum_example_private; Owner: -
--

COMMENT ON COLUMN forum_example_private.person_account.person_id IS 'The id of the person associated with this account.';


--
-- Name: COLUMN person_account.email; Type: COMMENT; Schema: forum_example_private; Owner: -
--

COMMENT ON COLUMN forum_example_private.person_account.email IS 'The email address of the person.';


--
-- Name: COLUMN person_account.password_hash; Type: COMMENT; Schema: forum_example_private; Owner: -
--

COMMENT ON COLUMN forum_example_private.person_account.password_hash IS 'An opaque hash of the person’s password.';


--
-- Name: submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.submissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.submissions_id_seq OWNED BY public.submissions.id;


--
-- Name: person id; Type: DEFAULT; Schema: forum_example; Owner: -
--

ALTER TABLE ONLY forum_example.person ALTER COLUMN id SET DEFAULT nextval('forum_example.person_id_seq'::regclass);


--
-- Name: post id; Type: DEFAULT; Schema: forum_example; Owner: -
--

ALTER TABLE ONLY forum_example.post ALTER COLUMN id SET DEFAULT nextval('forum_example.post_id_seq'::regclass);


--
-- Name: submissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions ALTER COLUMN id SET DEFAULT nextval('public.submissions_id_seq'::regclass);


--
-- Name: person person_pkey; Type: CONSTRAINT; Schema: forum_example; Owner: -
--

ALTER TABLE ONLY forum_example.person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);


--
-- Name: post post_pkey; Type: CONSTRAINT; Schema: forum_example; Owner: -
--

ALTER TABLE ONLY forum_example.post
    ADD CONSTRAINT post_pkey PRIMARY KEY (id);


--
-- Name: person_account person_account_email_key; Type: CONSTRAINT; Schema: forum_example_private; Owner: -
--

ALTER TABLE ONLY forum_example_private.person_account
    ADD CONSTRAINT person_account_email_key UNIQUE (email);


--
-- Name: person_account person_account_pkey; Type: CONSTRAINT; Schema: forum_example_private; Owner: -
--

ALTER TABLE ONLY forum_example_private.person_account
    ADD CONSTRAINT person_account_pkey PRIMARY KEY (person_id);


--
-- Name: submissions PK_10b3be95b8b2fb1e482e07d706b; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT "PK_10b3be95b8b2fb1e482e07d706b" PRIMARY KEY (id);


--
-- Name: person person_updated_at; Type: TRIGGER; Schema: forum_example; Owner: -
--

CREATE TRIGGER person_updated_at BEFORE UPDATE ON forum_example.person FOR EACH ROW EXECUTE FUNCTION forum_example_private.set_updated_at();


--
-- Name: post post_updated_at; Type: TRIGGER; Schema: forum_example; Owner: -
--

CREATE TRIGGER post_updated_at BEFORE UPDATE ON forum_example.post FOR EACH ROW EXECUTE FUNCTION forum_example_private.set_updated_at();


--
-- Name: post post_author_id_fkey; Type: FK CONSTRAINT; Schema: forum_example; Owner: -
--

ALTER TABLE ONLY forum_example.post
    ADD CONSTRAINT post_author_id_fkey FOREIGN KEY (author_id) REFERENCES forum_example.person(id);


--
-- Name: person_account person_account_person_id_fkey; Type: FK CONSTRAINT; Schema: forum_example_private; Owner: -
--

ALTER TABLE ONLY forum_example_private.person_account
    ADD CONSTRAINT person_account_person_id_fkey FOREIGN KEY (person_id) REFERENCES forum_example.person(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

