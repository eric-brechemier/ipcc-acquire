-- export the list of countries

USE 'giec';

SELECT
  name AS 'name',
  id AS 'value'
FROM countries
ORDER BY value;
