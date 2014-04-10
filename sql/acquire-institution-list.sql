-- export the list of distinct institutions
-- (in current version of the database, there are different records
-- for different countries where a single international institution is based)

USE 'giec';

(
  SELECT
    'Any Institution' AS 'name',
    '' AS 'value'
)
UNION
(
  SELECT
    name AS 'name',
    MIN(id) AS 'value'
  FROM institutions
  GROUP BY name
  ORDER BY value
)
;
