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
    id 'name',
    id 'value'
  FROM assessment_reports
  ORDER BY value
)
;
