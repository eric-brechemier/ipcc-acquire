-- AUTHORS WITH MULTIPLE PARTICIPATIONS
-- Q2. Who are the authors that have participated
--     in more than 1, 2, 3, or 4 assessment reports
--     while holding at least 1 of the 3 elected roles in the IPCC
--     in each assessment report of participation
--     (Coordinating Lead Author, Lead Author, Review Editor)?

-- RESP = authors with a role of responsibility (LA, CLA or RE)
--        in EVERY assessment report of participation

-- IN EACH WORKING GROUP,
-- count the RESP authors who contributed to:
-- * 1+ assessment reports
-- * 2+ assessment reports
-- * 3+ assessment reports
-- * 4+ assessment reports
-- * 5  assessment reports

SELECT
  CONCAT(
    '≥',
    cumulated_assessment_reports.total,
    'AR'
  ) AS 'Cumulated AR',
  SUM(
    wg_total_participations.total_authors
  ) AS 'Total RESP Authors',
  CONCAT(
    'WG',
    wg
  ) AS 'Working Group'
FROM
  (
    SELECT id AS total
    FROM assessment_reports
  ) cumulated_assessment_reports,
  (
    SELECT
      total_ar_participations,
      COUNT(author_id) AS total_authors,
      wg
    FROM
    (
      SELECT
        wg,
        author_id,
        COUNT(ar) AS total_ar_participations
      FROM
      (
        SELECT wg, author_id, ar
        FROM participations
        WHERE author_id NOT IN (
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
        GROUP BY wg, author_id, ar
      ) wg_distinct_author_distinct_ar_participations
      GROUP BY wg, author_id
    ) wg_distinct_author_ar_participations
    GROUP BY wg, total_ar_participations
  ) wg_total_participations
WHERE
  wg_total_participations.total_ar_participations
  >=
  cumulated_assessment_reports.total
GROUP BY cumulated_assessment_reports.total, wg
ORDER BY cumulated_assessment_reports.total, wg
;
