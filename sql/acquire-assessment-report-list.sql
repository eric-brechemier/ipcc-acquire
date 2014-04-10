-- export the list of assessment reports

USE 'giec';

(
  SELECT
    'Any AR' AS 'name',
    '' AS 'value'
)
UNION
(
  SELECT
    id AS 'name',
    id AS 'value'
  FROM assessment_reports
  ORDER BY value
)
;
