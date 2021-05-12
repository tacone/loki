--
-- PostgreSQL database dump
--

-- Dumped from database version 13.2
-- Dumped by pg_dump version 13.2

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

SET default_tablespace = '';

SET default_table_access_method = heap;

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
-- Name: submissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions ALTER COLUMN id SET DEFAULT nextval('public.submissions_id_seq'::regclass);


--
-- Name: submissions PK_10b3be95b8b2fb1e482e07d706b; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT "PK_10b3be95b8b2fb1e482e07d706b" PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

