-- BRIDGE AUTHORS
-- Q3. Who are the authors that have participated in
-- more than one working group (what we call bridge authors)?

USE giec

-- For each author, compute working group membership ratios,
-- a value that indicates the relative belonging to:
--
-- * Working Group I
-- wg1 = WG1 / (WG1 + WG2 + WG3)
--
-- * Working Group II
-- wg2 = WG2 / (WG1 + WG2+ WG3)
--
-- * Working Group III
-- wg3 = WG3 / (WG1 + WG2 + WG3)
--
-- * Bridge of Working Groups I+II
-- 2 x min(wg1, wg2)
--
-- * Bridge of Working Groups II+III
-- 2 x min(wg2, wg3)
--
-- * Bridge of Working Groups I+III
-- 2 x min(wg1, wg3)
--
-- * Bridge of Working Groups I+II+III
-- 3 x min(wg1, wg2, wg3)
--
-- ordered by the latter ratio (descending),
-- then by total participations (descending),
-- then by last name and first name

SELECT
  first_name AS 'First Name',
  last_name AS 'Last Name',
  bridge123 AS 'WG I+II+III',
  bridge12 AS 'WG I+II',
  bridge23 AS 'WG II+III',
  bridge13 AS 'WG I+III',
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
      2 * least(wg1, wg2) AS bridge12,
      2 * least(wg2, wg3) AS bridge23,
      2 * least(wg1, wg3) AS bridge13,
      3 * least(wg1, wg2, wg3) AS bridge123
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
  ) AS bridge_participations
WHERE
  authors.id = bridge_participations.author_id
ORDER BY
  bridge123 DESC,
  total DESC,
  last_name,
  first_name
