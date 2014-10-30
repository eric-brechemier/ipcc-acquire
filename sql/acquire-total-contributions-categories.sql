-- export authors grouped by total number of contributions

-- set limit for the size of a string concatenated with GROUP_CONCAT to a
-- value larger than the number of authors (<10,000) times the size of
-- an identifier + separator (<10) multiplied by 2 for good measure.
SET group_concat_max_len=200000;

SELECT
  CONCAT(
    contributions.total,
    IF(
      contributions.total = 1,
      ' contribution',
      ' contributions'
    )
  ) 'category',
  CONCAT(
    '[',
      GROUP_CONCAT(
        DISTINCT contributions.author_id
        ORDER BY contributions.author_id
        SEPARATOR '|'
      ),
    ']'
  ) 'authors',
  COUNT(
    DISTINCT contributions.author_id
  ) 'total_authors'
FROM
  (
    SELECT
      total_contributions.total 'total',
      author_contributions.author_id 'author_id'
    FROM
      (
        SELECT DISTINCT COUNT(id) 'total'
        FROM participations
        GROUP BY author_id
      ) AS total_contributions
      ,
      (
        SELECT
          COUNT(id) 'total',
          author_id
        FROM participations
        GROUP BY author_id
      ) AS author_contributions
    WHERE
      author_contributions.total >= total_contributions.total
  ) AS contributions
GROUP BY contributions.total
ORDER BY contributions.total
;
