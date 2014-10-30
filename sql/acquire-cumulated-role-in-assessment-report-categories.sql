-- export the sets of authors grouped by cumulated role
-- in each assessment report

-- Any author with multiple roles is assigned to the cumulated role
-- category named 'Multiple Roles (MULTI)'.

-- set limit for the size of a string concatenated with GROUP_CONCAT to a
-- value larger than the number of authors (<10,000) times the size of
-- an identifier + separator (<10) multiplied by 2 for good measure.
SET group_concat_max_len=200000;

SELECT
  ar_roles.name 'category',
  CONCAT(
    '[',
      GROUP_CONCAT(
        DISTINCT ar_roles.author_id
        ORDER BY ar_roles.author_id
        SEPARATOR '|'
      ),
    ']'
  ) 'authors',
  COUNT(
    DISTINCT ar_roles.author_id
  ) 'total_authors'
FROM
  (
    SELECT
      CONCAT(
        'AR',
        participations.ar,
        ' - ',
        IF(
          COUNT(DISTINCT participations.role) > 1,
          'Multiple Roles',
          roles.name
        )
      ) 'name',
      participations.author_id
    FROM
      participations,
      roles
    WHERE
      participations.role = roles.symbol
    GROUP BY
      participations.ar,
      participations.author_id
  ) AS ar_roles
GROUP BY ar_roles.name
ORDER BY ar_roles.name
;
