-- AUTHORS WITH MULTIPLE PARTICIPATIONS
-- Q1. Who are the authors that have participated
--     in more than 1, 2, 3, or 4 assessment reports?

-- Count the authors who contributed to:
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
  SUM(total_participations.total_authors) AS 'Total Authors'
FROM
(
  SELECT id AS total
  FROM assessment_reports
) cumulated_assessment_reports,
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
) total_participations
WHERE
  total_participations.total_ar_participations
  >=
  cumulated_assessment_reports.total
GROUP BY cumulated_assessment_reports.total
HAVING cumulated_assessment_reports.total >= 2
ORDER BY cumulated_assessment_reports.total
;
