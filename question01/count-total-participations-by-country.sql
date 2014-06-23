-- AUTHORS WITH MULTIPLE PARTICIPATIONS
-- Q1. Who are the authors that have participated
--     in more than 1, 2, 3, or 4 assessment reports?

USE giec

-- IN EACH COUNTRY
-- count the authors who contributed to:
-- * 1 assessment reports
-- * 2 assessment reports
-- * 3 assessment reports
-- * 4 assessment reports
-- * 5 assessment reports

SELECT
  total_ar_participations AS 'Total AR',
  COUNT(author_id) AS 'Total Authors',
  countries.name AS 'Country'
FROM
  (
    SELECT
      country_id,
      author_id,
      COUNT(ar) AS total_ar_participations
    FROM
    (
      SELECT country_id, author_id, ar
      FROM
        participations,
        institution_countries
      WHERE
        participations.institution_country_id = institution_countries.id
      GROUP BY country_id, author_id, ar
    ) countries_distinct_author_distinct_ar_participations
    GROUP BY country_id, author_id
  ) countries_distinct_author_ar_participations,
  countries
WHERE
  country_id = countries.id
GROUP BY country_id, total_ar_participations
ORDER BY countries.name, total_ar_participations
;
