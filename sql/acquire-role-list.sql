-- export the list of distinct roles

USE 'giec';

(
  SELECT
    'Any Role' AS 'name',
    '' AS 'value'
)
UNION
(
  SELECT
    name AS 'name',
    id AS 'value'
  FROM roles
  ORDER BY value
)
;
