USE 'giec';
SELECT
  working_groups.name 'category',
  CONCAT(
    '[',
      GROUP_CONCAT(
        DISTINCT working_groups.author_id
        ORDER BY working_groups.author_id
        SEPARATOR '|'
      ),
    ']'
  ) 'authors',
  COUNT(
    DISTINCT working_groups.author_id
  ) 'total_authors'
FROM
(
  SELECT
    CONCAT(
      'WG',
      GROUP_CONCAT(
        DISTINCT wg
        ORDER BY wg
        SEPARATOR '+'
      )
    ) name,
    author_id
  FROM participations
  GROUP BY author_id
) AS working_groups
GROUP BY working_groups.name
ORDER BY working_groups.name
;
