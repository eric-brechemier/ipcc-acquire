-- AUTHORS WITH MULTIPLE PARTICIPATIONS
-- Q2. Who are the authors that have participated
--     in more than 1, 2, 3, or 4 assessment reports
--     while holding at least 1 of the 3 elected roles in the IPCC
--     in each assessment report of participation
--     (Coordinating Lead Author, Lead Author, Review Editor)?

USE giec

-- RESP = authors with a role of responsibility (LA, CLA or RE)
--        in EVERY assessment report of participation

-- Count the RESP authors who contributed to:
-- * 1+ assessment reports
-- * 2+ assessment reports
-- * 3+ assessment reports
-- * 4+ assessment reports
-- * 5  assessment reports

SELECT
  CONCAT(
    resp_total_participations1.total_ar_participations,
    '+'
  ) AS 'Cumulated AR',
  SUM(resp_total_participations2.total_authors) AS 'Total RESP Authors'
FROM
(
  SELECT
    total_ar_participations,
    COUNT(author_id) AS total_authors
  FROM
  (
    SELECT
      author_id,
      COUNT(ar) AS total_ar_participations
    FROM
    (
      SELECT author_id, ar
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
      GROUP BY author_id, ar
    ) resp_distinct_ar_participations
    GROUP BY author_id
  ) resp_ar_participations
  GROUP BY total_ar_participations
) resp_total_participations1,
(
  SELECT
    total_ar_participations,
    COUNT(author_id) AS total_authors
  FROM
  (
    SELECT
      author_id,
      COUNT(ar) AS total_ar_participations
    FROM
    (
      SELECT author_id, ar
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
      GROUP BY author_id, ar
    ) resp_distinct_ar_participations
    GROUP BY author_id
  ) resp_ar_participations
  GROUP BY total_ar_participations
) resp_total_participations2
WHERE
  resp_total_participations2.total_ar_participations
  >=
  resp_total_participations1.total_ar_participations
GROUP BY resp_total_participations1.total_ar_participations
ORDER BY resp_total_participations1.total_ar_participations
;
