-- export the list of distinct institutions
-- (in current version of the database, there are different records
-- for different countries where a single international institution is based)

USE 'giec';

SELECT
  name,
  MIN(id) 'value'
FROM institutions
GROUP BY name
ORDER BY value
;
