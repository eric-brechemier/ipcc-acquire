-- AUTHORS WITH MULTIPLE PARTICIPATIONS
-- Q1. Who are the authors that have participated
--     in more than 1, 2, 3, or 4 assessment reports?

-- FOR EACH INSTITUTION,
-- count the percentage of authors who contributed to:
-- * 1+ assessment reports
-- * 2+ assessment reports
-- * 3+ assessment reports
-- * 4+ assessment reports
-- * 5  assessment reports
-- relative to the total number of authors who contributed
-- to a number of assessment reports in the same range
-- for any given INSTITUTION

SELECT
  CONCAT(
    '≥',
    total_participations_by_institution.cumulated_ar_participations,
    'AR'
  ) AS 'Cumulated AR',
  (
    100 * total_participations_by_institution.total_authors
    / total_participations_by_any_institution.total_authors
  ) AS 'Percentage of Total Authors',
  institutions.name AS 'Institution'
FROM
  (
    SELECT
      cumulated_assessment_reports.total AS cumulated_ar_participations,
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
  (
    SELECT
      cumulated_assessment_reports.total AS cumulated_ar_participations,
      COUNT(
        institutions_distinct_author_ar_participations.author_id
      ) AS total_authors
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
      ) institutions_distinct_author_ar_participations
    WHERE
      institutions_distinct_author_ar_participations.total_ar_participations
      >=
      cumulated_assessment_reports.total
    GROUP BY cumulated_assessment_reports.total
  ) total_participations_by_any_institution,
  institutions
WHERE institutions.id = institution_id
AND total_participations_by_institution.cumulated_ar_participations
  = total_participations_by_any_institution.cumulated_ar_participations
ORDER BY
  total_participations_by_institution.cumulated_ar_participations,
  total_participations_by_institution.total_authors DESC,
  institutions.name
;
