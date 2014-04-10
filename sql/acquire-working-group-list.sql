-- export the list of distinct working group numbers

USE 'giec';

(
  SELECT
    'Any WG' AS 'name',
    '' AS 'value'
)
UNION
(
  SELECT
    CONCAT('WG',working_groups.number) AS 'name',
    working_groups.number AS 'value'
  FROM
    (
      SELECT DISTINCT number
      FROM working_groups
    ) working_groups
  ORDER BY value
)
;
