-- export the sets of authors who contributed to each assessment report

USE 'giec';
-- set limit for the size of a string concatenated with GROUP_CONCAT to a
-- value larger than the number of authors (<10,000) times the size of
-- an identifier + separator (<10) multiplied by 2 for good measure.
SET group_concat_max_len=200000;

SELECT
  assessment_reports.name 'category',
  CONCAT(
    '[',
      GROUP_CONCAT(
        DISTINCT assessment_reports.author_id
        ORDER BY assessment_reports.author_id
        SEPARATOR '|'
      ),
    ']'
  ) 'authors',
  COUNT(
    DISTINCT assessment_reports.author_id
  ) 'total_authors'
FROM
  (
    SELECT
      CONCAT('AR',ar) 'name',
      author_id
    FROM participations
    GROUP BY ar, author_id
  ) AS assessment_reports
GROUP BY assessment_reports.name
ORDER BY assessment_reports.name
;
