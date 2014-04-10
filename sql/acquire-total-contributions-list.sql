-- export the list of distinct total number of contributions values

USE 'giec';

SELECT
  contributions.total AS 'name',
  contributions.total AS 'value'
FROM
  (
    SELECT DISTINCT COUNT(id) 'total'
    FROM participations
    GROUP BY author_id
  ) contributions
ORDER BY contributions.total
;
