-- export the list of countries

(
  SELECT
    'Any Country' AS 'name',
    '' AS 'value'
)
UNION
(
  SELECT
    name AS 'name',
    id AS 'value'
  FROM countries
  ORDER BY value
)
;
