-- AUTHORS WITH MULTIPLE PARTICIPATIONS
-- Q1. Who are the authors that have participated
--     in more than 1, 2, 3, or 4 assessment reports?

USE giec

-- IN EACH INSTITUTION
-- count the authors who contributed to:
-- * 1 assessment reports
-- * 2 assessment reports
-- * 3 assessment reports
-- * 4 assessment reports
-- * 5 assessment reports

SELECT
  total_ar_participations AS 'Total AR',
  COUNT(author_id) AS 'Total Authors',
  institutions.name AS 'Institution'
FROM
  (
    SELECT
      institution_id,
      author_id,
      COUNT(ar) AS total_ar_participations
    FROM
    (
      SELECT institution_id, author_id, ar
      FROM
        participations,
        institution_countries,
        institutions
      WHERE
        participations.institution_country_id =
          institution_countries.id
        AND institution_countries.institution_id = institutions.id
      GROUP BY institution_id, author_id, ar
    ) institutions_distinct_author_distinct_ar_participations
    GROUP BY institution_id, author_id
  ) institutions_distinct_author_ar_participations,
  institutions
WHERE
  institution_id = institutions.id
GROUP BY institution_id, total_ar_participations
ORDER BY institutions.name, total_ar_participations
;
