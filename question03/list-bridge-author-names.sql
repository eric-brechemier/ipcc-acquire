-- BRIDGE AUTHORS
-- Q3. Who are the authors that have participated in
-- more than one working group (what we call bridge authors)?

USE giec

SELECT
  total_wg AS 'Total WG',
  CONCAT( 'WG', cumulated_wg ) AS 'Cumulated WG',
  CONCAT( first_name, ' ', last_name ) AS 'Bridge Author Name'
FROM
  (
    SELECT
      author_id,
      COUNT( DISTINCT wg ) AS total_wg,
      GROUP_CONCAT(
        DISTINCT wg
        ORDER BY wg
        SEPARATOR '+'
      ) AS cumulated_wg
    FROM participations
    GROUP BY author_id
    HAVING total_wg > 1
  ) bridge_authors,
  authors
WHERE authors.id = author_id
ORDER BY total_wg DESC, cumulated_wg, last_name
;
