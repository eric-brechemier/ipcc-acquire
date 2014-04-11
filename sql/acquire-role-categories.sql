-- export the sets of authors for each role

USE 'giec';

-- set limit for the size of a string concatenated with GROUP_CONCAT to a
-- value larger than the number of authors (<10,000) times the size of
-- an identifier + separator (<10) multiplied by 2 for good measure.
SET group_concat_max_len=200000;

SELECT
  roles.name 'category',
  CONCAT(
    '[',
      GROUP_CONCAT(
        DISTINCT roles.author_id
        ORDER BY roles.author_id
        SEPARATOR '|'
      ),
    ']'
  ) 'authors',
  COUNT(
    DISTINCT roles.author_id
  ) 'total_authors'
FROM
  (
    SELECT
      roles.name 'name',
      participations.author_id 'author_id'
    FROM
      participations,
      roles
    WHERE
      participations.role = roles.symbol
    GROUP BY participations.role, participations.author_id
  ) AS roles
GROUP BY roles.name
ORDER BY roles.name
;
