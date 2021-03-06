-- AUTHORS WITH MULTIPLE PARTICIPATIONS
-- Q2. Who are the authors that have participated
--     in more than 1, 2, 3, or 4 assessment reports
--     while holding at least 1 of the 3 elected roles in the IPCC
--     in each assessment report of participation
--     (Coordinating Lead Author, Lead Author, Review Editor)?

-- RESP = authors with a role of responsibility (LA, CLA or RE)
--        in EVERY assessment report of participation

-- FOR EACH COUNTRY,
-- count the percentage of RESP authors who contributed to:
-- * 1+ assessment reports
-- * 2+ assessment reports
-- * 3+ assessment reports
-- * 4+ assessment reports
-- * 5  assessment reports
-- relative to the total number of RESP authors who contributed
-- to a number of assessment reports in the same range
-- for any given COUNTRY

SELECT
  CONCAT(
    '≥',
    total_participations_by_country.cumulated_ar_participations,
    'AR'
  ) AS 'Cumulated AR',
  (
    100 * total_participations_by_country.total_authors
    / total_participations_by_any_country.total_authors
  ) AS 'Percentage of Total RESP Authors',
  countries.name AS 'Country'
FROM
  (
    SELECT
      cumulated_assessment_reports.total AS cumulated_ar_participations,
      country_id,
      SUM(
        countries_total_participations.total_authors
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
  (
    SELECT
      cumulated_assessment_reports.total AS cumulated_ar_participations,
      COUNT(
        countries_distinct_author_ar_participations.author_id
      ) AS total_authors
    FROM
      (
        SELECT id AS total
        FROM assessment_reports
      ) cumulated_assessment_reports,
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
            GROUP BY country_id, author_id, ar
          ) countries_distinct_author_distinct_ar_participations
        GROUP BY country_id, author_id
      ) countries_distinct_author_ar_participations
    WHERE
      countries_distinct_author_ar_participations.total_ar_participations
      >=
      cumulated_assessment_reports.total
    GROUP BY cumulated_assessment_reports.total
  ) total_participations_by_any_country,
  countries
WHERE countries.id = country_id
AND total_participations_by_country.cumulated_ar_participations
  = total_participations_by_any_country.cumulated_ar_participations
ORDER BY
  total_participations_by_country.cumulated_ar_participations,
  total_participations_by_country.total_authors DESC,
  countries.name
;
