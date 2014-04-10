-- export the list of distinct roles

USE 'giec';

SELECT
  CONCAT(name, ' (', symbol, ')') AS 'name',
  id AS 'value'
FROM roles
ORDER BY value
;
