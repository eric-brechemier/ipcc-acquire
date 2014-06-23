-- AUTHORS WITH MULTIPLE PARTICIPATIONS
-- Q1. Who are the authors that have participated
--     in more than 1, 2, 3, or 4 assessment reports?

USE giec

-- IN EACH WORKING GROUP,
-- count the authors who contributed to:
-- * 1+ assessment reports
-- * 2+ assessment reports
-- * 3+ assessment reports
-- * 4+ assessment reports
-- * 5  assessment reports

SELECT
  CONCAT(
    cumulated_assessment_reports.total,
    '+'
  ) AS 'Cumulated AR',
  SUM(
    wg_total_participations.total_authors
  ) AS 'Total Authors',
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
