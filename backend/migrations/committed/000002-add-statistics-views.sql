--! Previous: sha1:2420a9a32121ea4d394a77f40941e9a264256f22
--! Hash: sha1:99269923d11933c08fffa372ad5369215150484d
--! Message: add-statistics-views

DROP VIEW IF EXISTS age_stats CASCADE;
CREATE VIEW age_stats AS
SELECT "age" AS "name",  COUNT(*)::integer AS count, (COUNT(*)::float*100/(1+total_members)) AS percentage
FROM submissions s2 ,
	(SELECT COUNT(*)::integer AS total_members FROM submissions s3) tot_mem
GROUP BY "age", total_members
ORDER BY "count" desc;

comment on view age_stats is '@omit';

DROP VIEW IF EXISTS country_stats CASCADE;
CREATE VIEW country_stats AS
SELECT "country" AS "name",  COUNT(*)::integer AS count, (COUNT(*)::float*100/total_members) AS percentage
FROM submissions s2 ,
	(SELECT COUNT(*)::integer AS total_members FROM submissions s3) tot_mem
GROUP BY "country", total_members
ORDER BY "count" desc;

comment on view country_stats is '@omit';

DROP VIEW IF EXISTS experience_rating_stats CASCADE;
CREATE VIEW experience_rating_stats AS
SELECT "experience_rating" AS "name",  COUNT(*)::integer AS count, (COUNT(*)::float*100/total_members) AS percentage
FROM submissions s2 ,
	(SELECT COUNT(*)::integer AS total_members FROM submissions s3) tot_mem
GROUP BY "experience_rating", total_members
ORDER BY "count" desc;

comment on view experience_rating_stats is '@omit';

DROP VIEW IF EXISTS gender_stats CASCADE;
CREATE VIEW gender_stats AS
SELECT gender AS "name", COUNT(*)::integer AS count, (COUNT(*)::float*100/total_members) AS percentage
FROM submissions s2 ,
	(SELECT COUNT(*)::integer AS total_members FROM submissions s3) tot_mem
GROUP BY gender, total_members
ORDER BY "count" desc;

comment on view gender_stats is '@omit';

DROP VIEW IF EXISTS "statistics" CASCADE;
CREATE VIEW "statistics" AS
SELECT * FROM
( SELECT array_agg(age_stats) AS age FROM age_stats) a,
( SELECT array_agg(country_stats) AS country FROM country_stats) c,
( SELECT array_agg(experience_rating_stats) AS experience_rating FROM experience_rating_stats) e,
( SELECT array_agg(gender_stats) AS gender FROM gender_stats) g,
( SELECT COUNT(*)::integer as total_submissions FROM submissions) t;
