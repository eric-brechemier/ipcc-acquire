USE 'giec';
-- set limit for the size of a string concatenated with GROUP_CONCAT to a
-- value larger than the number of authors (<10,000) times the size of
-- an identifier + separator (<10) multiplied by 2 for good measure.
SET group_concat_max_len=200000;
SELECT
  CONCAT(
    'AR',
    ar_working_groups.ar,
    ' ',
    ar_working_groups.wg_name
  ) 'category',
  CONCAT(
    '[',
      GROUP_CONCAT(
        DISTINCT ar_working_groups.author_id
        ORDER BY ar_working_groups.author_id
        SEPARATOR '|'
      ),
    ']'
  ) 'authors',
  COUNT(
    DISTINCT ar_working_groups.author_id
  ) 'total_authors'
FROM
(
  SELECT
    ar,
    CONCAT(
      'WG',
      GROUP_CONCAT(
        DISTINCT wg
        ORDER BY wg
        SEPARATOR '+'
      )
    ) wg_name,
    author_id
  FROM participations
  GROUP BY ar, author_id
) AS ar_working_groups
GROUP BY ar_working_groups.ar, ar_working_groups.wg_name
ORDER BY ar_working_groups.ar, ar_working_groups.wg_name
;
