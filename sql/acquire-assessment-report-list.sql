-- export the list of assessment reports

USE 'giec';

SELECT
  id 'name',
  id 'value'
FROM assessment_reports
ORDER BY value;
