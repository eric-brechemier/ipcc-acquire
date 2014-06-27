-- AUTHORS WITH MULTIPLE PARTICIPATIONS
-- Q1. Who are the authors that have participated
--     in more than 1, 2, 3, or 4 assessment reports?

USE giec

-- FOR EACH COUNTRY
-- count the authors who contributed to:
-- * 1+ assessment reports
-- * 2+ assessment reports
-- * 3+ assessment reports
-- * 4+ assessment reports
-- * 5  assessment reports

SELECT
  CONCAT('≥',total_ar,'AR') AS 'Cumulated AR',
  total_authors AS 'Total Authors',
  countries.name AS 'Country'
FROM
  (
    SELECT
      cumulated_assessment_reports.total AS total_ar,
      country_id,
      SUM( countries_total_participations.total_authors ) AS total_authors
    FROM
      (
        SELECT id AS total
        FROM assessment_reports
      ) cumulated_assessment_reports,
      (
        SELECT
          total_ar_participations,
          COUNT(author_id) AS total_authors,
          country_id
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
        ) countries_distinct_author_ar_participations
        GROUP BY country_id, total_ar_participations
      ) countries_total_participations
    WHERE
      countries_total_participations.total_ar_participations
      >=
      cumulated_assessment_reports.total
    GROUP BY cumulated_assessment_reports.total, country_id
  ) total_participations_by_country,
  countries
WHERE countries.id = country_id
ORDER BY total_ar, total_authors DESC, countries.name
;
