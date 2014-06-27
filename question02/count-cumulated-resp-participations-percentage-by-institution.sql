-- AUTHORS WITH MULTIPLE PARTICIPATIONS
-- Q2. Who are the authors that have participated
--     in more than 1, 2, 3, or 4 assessment reports
--     while holding at least 1 of the 3 elected roles in the IPCC
--     in each assessment report of participation
--     (Coordinating Lead Author, Lead Author, Review Editor)?

USE giec

-- RESP = authors with a role of responsibility (LA, CLA or RE)
--        in EVERY assessment report of participation

-- FOR EACH INSTITUTION,
-- count the percentage of RESP authors who contributed to:
-- * 1+ assessment reports
-- * 2+ assessment reports
-- * 3+ assessment reports
-- * 4+ assessment reports
-- * 5  assessment reports
-- relative to the total number of RESP authors who contributed
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
  ) AS 'Percentage of Total RESP Authors',
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
                AND author_id NOT IN (
                  -- NOT RESP
                  SELECT author_id
                  FROM
                  (
                    SELECT author_id, ar
                    FROM
                    (
                      SELECT author_id, ar
                      FROM participations
                      GROUP BY author_id, ar
                    ) distinct_ar_participations
                    WHERE NOT EXISTS (
                      SELECT role
                      FROM participations
                      WHERE distinct_ar_participations.author_id = participations.author_id
                      AND distinct_ar_participations.ar = participations.ar
                      AND participations.role <> 'CA'
                    )
                  ) not_resp_distinct_ar_participations
                  GROUP BY author_id
                ) -- not_resp
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
            AND author_id NOT IN (
              -- NOT RESP
              SELECT author_id
              FROM
              (
                SELECT author_id, ar
                FROM
                (
                  SELECT author_id, ar
                  FROM participations
                  GROUP BY author_id, ar
                ) distinct_ar_participations
                WHERE NOT EXISTS (
                  SELECT role
                  FROM participations
                  WHERE distinct_ar_participations.author_id = participations.author_id
                  AND distinct_ar_participations.ar = participations.ar
                  AND participations.role <> 'CA'
                )
              ) not_resp_distinct_ar_participations
              GROUP BY author_id
            ) -- not_resp
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
