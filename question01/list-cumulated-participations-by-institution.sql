-- AUTHORS WITH MULTIPLE PARTICIPATIONS
-- Q1. Who are the authors that have participated
--     in more than 1, 2, 3, or 4 assessment reports?

USE giec

-- FOR EACH INSTITUTION,
-- list the authors who contributed to:
-- * 1+ assessment reports
-- * 2+ assessment reports
-- * 3+ assessment reports
-- * 4+ assessment reports
-- * 5  assessment reports

SELECT
  CONCAT('≥',cumulated_ar,'AR') AS 'Cumulated AR',
  institutions.name AS 'Institution',
  CONCAT( authors.first_name, ' ', authors.last_name ) AS 'Author',
  total_ar_participations
FROM
  (
    SELECT
      cumulated_assessment_reports.total AS cumulated_ar,
      institution_id,
      author_id,
      total_ar_participations
    FROM
      (
        SELECT id AS total
        FROM assessment_reports
      ) cumulated_assessment_reports,
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
            institution_countries
          WHERE
            participations.institution_country_id = institution_countries.id
          GROUP BY institution_id, author_id, ar
        ) institutions_distinct_author_distinct_ar_participations
        GROUP BY institution_id, author_id
      ) institutions_total_participations
    WHERE
      institutions_total_participations.total_ar_participations
      >=
      cumulated_assessment_reports.total
  ) total_participations_by_institution,
  institutions,
  authors
WHERE institutions.id = institution_id
AND authors.id = author_id
ORDER BY
  cumulated_ar DESC,
  institutions.name,
  total_ar_participations DESC,
  authors.last_name
;
