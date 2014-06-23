-- AUTHORS WITH MULTIPLE PARTICIPATIONS
-- Q2. Who are the authors that have participated
--     in more than 1, 2, 3, or 4 assessment reports
--     while holding at least 1 of the 3 elected roles in the IPCC
--     in each assessment report of participation
--     (Coordinating Lead Author, Lead Author, Review Editor)?

USE giec

-- RESP = authors with a role of responsibility (LA, CLA or RE)
--        in EVERY assessment report of participation

SELECT
  COUNT(
    resp_distinct_ar_participations.ar
  ) AS 'AR Participations',
  CONCAT(
    authors.first_name,
    ' ',
    authors.last_name
  ) AS 'RESP Author Name'
FROM
  authors,
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
WHERE authors.id = resp_distinct_ar_participations.author_id
GROUP BY resp_distinct_ar_participations.author_id
ORDER BY `AR Participations` DESC, authors.last_name
;
