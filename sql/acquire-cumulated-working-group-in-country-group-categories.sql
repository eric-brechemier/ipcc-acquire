-- export the sets of authors grouped by cumulated working group in each
-- country group to which the country of their mandating institution belongs

USE 'giec';

-- set limit for the size of a string concatenated with GROUP_CONCAT to a
-- value larger than the number of authors (<10,000) times the size of
-- an identifier + separator (<10) multiplied by 2 for good measure.
SET group_concat_max_len=200000;

SELECT
  country_group_working_groups.name 'category',
  CONCAT(
    '[',
      GROUP_CONCAT(
        DISTINCT country_group_working_groups.author_id
        ORDER BY country_group_working_groups.author_id
        SEPARATOR '|'
      ),
    ']'
  ) 'authors',
  COUNT(
    DISTINCT country_group_working_groups.author_id
  ) 'total_authors'
FROM
  (
    SELECT
      CONCAT(
        groupings.symbol,
        ' - ',
        'WG',
        GROUP_CONCAT(
          DISTINCT participations.wg
          ORDER BY participations.wg
          SEPARATOR '+'
        )
      ) 'name',
      participations.author_id
    FROM
      groupings,
      institutions,
      participations
    WHERE
          groupings.country_id = institutions.country_id
      AND institutions.id = participations.institution_id
    GROUP BY
      groupings.symbol,
      participations.author_id
  ) AS country_group_working_groups
GROUP BY country_group_working_groups.name
ORDER BY country_group_working_groups.name
;
