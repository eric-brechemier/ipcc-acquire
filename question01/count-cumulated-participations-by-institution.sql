-- AUTHORS WITH MULTIPLE PARTICIPATIONS
-- Q1. Who are the authors that have participated
--     in more than 1, 2, 3, or 4 assessment reports?

USE giec

-- FOR EACH INSTITUTION,
-- count the authors who contributed to:
-- * 1+ assessment reports
-- * 2+ assessment reports
-- * 3+ assessment reports
-- * 4+ assessment reports
-- * 5  assessment reports

SELECT
  CONCAT('≥',total_ar,'AR') AS 'Cumulated AR',
  total_authors AS 'Total Authors',
  institutions.name AS 'Institution'
FROM
  (
    SELECT
      cumulated_assessment_reports.total AS total_ar,
      institution_id,
      SUM(
        institutions_total_participations.total_authors
      ) AS total_authors
    FROM
      (
        SELECT id AS total
        FROM assessment_reports
      ) cumulated_assessment_reports,
      (
        SELECT
          total_ar_participations,
          COUNT(author_id) AS total_authors,
          institution_id
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
              institution_countries
            WHERE
              participations.institution_country_id = institution_countries.id
            GROUP BY institution_id, author_id, ar
          ) institutions_distinct_author_distinct_ar_participations
          GROUP BY institution_id, author_id
        ) institutions_distinct_author_ar_participations
        GROUP BY institution_id, total_ar_participations
      ) institutions_total_participations
    WHERE
      institutions_total_participations.total_ar_participations
      >=
      cumulated_assessment_reports.total
    GROUP BY cumulated_assessment_reports.total, institution_id
  ) total_participations_by_institution,
  institutions
WHERE institutions.id = institution_id
ORDER BY total_ar, total_authors DESC, institutions.name
;
