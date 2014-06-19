-- AUTHORS WITH MULTIPLE PARTICIPATIONS
-- Q1. Who are the authors that have participated
--     in more than 1, 2, 3, or 4 assessment reports?

USE giec

-- Count the authors who contributed to:
-- * 1+ assessment reports
-- * 2+ assessment reports
-- * 3+ assessment reports
-- * 4+ assessment reports
-- * 5  assessment reports

SELECT
  total_participations1.total_ar_participations AS 'Cumulated AR',
  SUM(total_participations2.total_authors) AS 'Total Authors'
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
      GROUP BY author_id, ar
    ) distinct_ar_participations
    GROUP BY author_id
  ) ar_participations
  GROUP BY total_ar_participations
) total_participations1,
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
      GROUP BY author_id, ar
    ) distinct_ar_participations
    GROUP BY author_id
  ) ar_participations
  GROUP BY total_ar_participations
) total_participations2
WHERE
  total_participations2.total_ar_participations
  >=
  total_participations1.total_ar_participations
GROUP BY total_participations1.total_ar_participations
;
