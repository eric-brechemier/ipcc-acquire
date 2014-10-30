-- export the list of publication years of assessment reports

SELECT
  CONCAT('AR',id) 'name',
  year
FROM
  assessment_reports
ORDER BY id;
