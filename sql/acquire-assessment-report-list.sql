-- export the list of assessment reports

(
  SELECT
    'Any AR' AS 'name',
    '' AS 'value'
)
UNION
(
  SELECT
    CONCAT('AR',id) AS 'name',
    id AS 'value'
  FROM assessment_reports
  ORDER BY value
)
;
