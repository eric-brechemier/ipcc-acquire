-- export the list of distinct working group numbers

USE 'giec';

SELECT
  working_groups.number 'name',
  working_groups.number 'value'
FROM
  (
    SELECT DISTINCT number
    FROM working_groups
  ) working_groups
ORDER BY value
;
