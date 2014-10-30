-- export the sets of authors for each type of institution

(
  SELECT
    'Any Institution Type' AS 'name',
    '' AS 'value'
)
UNION
(
  SELECT
    name AS 'name',
    id AS 'value'
  FROM institution_types
  ORDER BY value
)
;
