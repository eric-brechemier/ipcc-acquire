-- BRIDGE AUTHORS
-- Q3. Who are the authors that have participated in
-- more than one working group (what we call bridge authors)?

USE giec

-- For each author, compute working group membership ratios,
-- a value that indicates the relative belonging to:
--
-- * Bridge of Working Groups II+III vs Working Group I
-- (wg2 + wg3) - wg1
--
-- * Bridge of Working Groups I+III vs Working Group II
-- (wg1 + wg3) - wg2
--
-- * Bridge of Working Groups I+II vs Working Group III
-- (wg1 + wg2) - wg3
--
-- * Bridge of Working Groups I+II+III vs Individual Working Groups
-- 1 -
-- (
--    abs( 2 * wg1 - (wg2 + wg3) )
--  + abs( 2 * wg2 - (wg1 + wg3) )
--  + abs( 2 * wg3 - (wg1 + wg2) )
-- ) / 2
--
-- with:
--  * wg1, the proportion of participations in Working Group 1,
--  * wg2, the proportion of participations in Working Group 2,
--  * wg3, the proportion of participations in Working Group 3,
--
-- having (proportion = count / total),
--
-- ordered by the latter ratio (descending),
-- then by total participations (descending),
-- then by last name and first name

SELECT
  first_name AS 'First Name',
  last_name AS 'Last Name',
  center AS 'WG I+II+III',
  (+wg1 +wg2 -wg3) AS 'WG I+II',
  (-wg1 +wg2 +wg3) AS 'WG II+III',
  (+wg1 -wg2 +wg3) AS 'WG I+III',
  wg1 AS 'WG I',
  wg2 AS 'WG II',
  wg3 AS 'WG III',
  total AS 'Participations'
FROM
  authors,
  (
    SELECT
      author_id,
      total,
      wg1,
      wg2,
      wg3,
      (
        1 -
        (
            ABS( 2 * wg1 - (wg2 + wg3) )
          + ABS( 2 * wg2 - (wg1 + wg3) )
          + ABS( 2 * wg3 - (wg1 + wg2) )
        ) / 2
      ) AS center
    FROM
      (
        SELECT
          total_participations.author_id,
          IFNULL(WG1,0) / total AS wg1,
          IFNULL(WG2,0) / total AS wg2,
          IFNULL(WG3,0) / total AS wg3,
          total
        FROM
          (
            SELECT author_id, COUNT(id) as total
            FROM participations
            GROUP BY author_id
          ) AS total_participations

          LEFT JOIN
          (
            SELECT author_id, COUNT(id) AS WG1
            FROM participations
            WHERE wg = 1
            GROUP BY author_id
          ) AS wg1_participations
          ON total_participations.author_id = wg1_participations.author_id

          LEFT JOIN
          (
            SELECT author_id, COUNT(id) AS WG2
            FROM participations
            WHERE wg = 2
            GROUP BY author_id
          ) AS wg2_participations
          ON total_participations.author_id = wg2_participations.author_id

          LEFT JOIN
          (
            SELECT author_id, COUNT(id) AS WG3
            FROM participations
            WHERE wg = 3
            GROUP BY author_id
          ) AS wg3_participations
          ON total_participations.author_id = wg3_participations.author_id
      ) AS wg_participations
  ) AS normal_participations
WHERE
  authors.id = normal_participations.author_id
ORDER BY
  center DESC,
  total DESC,
  last_name,
  first_name
