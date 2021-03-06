-- export the list of distinct institutions
-- (in current version of the database, there are different records
-- for different countries where a single international institution is based)

(
  SELECT
    'Any Institution' AS 'name',
    '' AS 'value'
)
UNION
(
  SELECT
    name AS 'name',
    id AS 'value'
  FROM institutions
  ORDER BY id
)
;
