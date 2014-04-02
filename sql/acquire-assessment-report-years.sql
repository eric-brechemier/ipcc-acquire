-- export the list of publication years of assessment reports

USE 'giec';

SELECT
  id 'ar',
  year
FROM
  assessment_reports
ORDER BY id;
