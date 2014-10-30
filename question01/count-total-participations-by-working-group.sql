-- AUTHORS WITH MULTIPLE PARTICIPATIONS
-- Q1. Who are the authors that have participated
--     in more than 1, 2, 3, or 4 assessment reports?

-- IN EACH WORKING GROUP,
-- count the authors who contributed to:
-- * 1 assessment reports
-- * 2 assessment reports
-- * 3 assessment reports
-- * 4 assessment reports
-- * 5 assessment reports

SELECT
  total_ar_participations AS 'Total AR Participations',
  COUNT( author_id ) AS 'Total Authors',
  CONCAT( 'WG', wg ) AS 'Working Group'
FROM
  (
    SELECT
      wg,
      COUNT(ar) AS total_ar_participations,
      author_id
    FROM
    (
      SELECT wg, author_id, ar
      FROM participations
      GROUP BY wg, author_id, ar
    ) wg_distinct_author_distinct_ar_participations
    GROUP BY wg, author_id
  ) wg_distinct_author_ar_participations
GROUP BY
  total_ar_participations,
  wg
ORDER BY
  total_ar_participations,
  `Total Authors` DESC,
  wg
;
