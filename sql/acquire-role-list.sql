-- export the list of distinct roles

USE 'giec';

SELECT
  CONCAT(name, ' (', symbol, ')') 'name',
  id 'value'
FROM roles
ORDER BY value
;
