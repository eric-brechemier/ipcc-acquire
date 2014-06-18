-- export the sets of authors grouped by cumulated role in each country group
-- to which the country of their mandating institution belongs

-- Any author with multiple roles is assigned to the cumulated role
-- category named 'Multiple Roles (MULTI)'.

USE 'giec';

-- set limit for the size of a string concatenated with GROUP_CONCAT to a
-- value larger than the number of authors (<10,000) times the size of
-- an identifier + separator (<10) multiplied by 2 for good measure.
SET group_concat_max_len=200000;

SELECT
  country_group_roles.name 'category',
  CONCAT(
    '[',
      GROUP_CONCAT(
        DISTINCT country_group_roles.author_id
        ORDER BY country_group_roles.author_id
        SEPARATOR '|'
      ),
    ']'
  ) 'authors',
  COUNT(
    DISTINCT country_group_roles.author_id
  ) 'total_authors'
FROM
  (
    SELECT
      CONCAT(
        groupings.symbol,
        ' - ',
        IF(
          COUNT(DISTINCT participations.role) > 1,
          'Multiple Roles',
          roles.name
        )
      ) 'name',
      participations.author_id
    FROM
      groupings,
      institution_countries,
      participations,
      roles
    WHERE
          participations.institution_country_id = institution_countries.id
      AND institution_countries.country_id = groupings.country_id
      AND participations.role = roles.symbol
    GROUP BY
      groupings.symbol,
      participations.author_id
  ) AS country_group_roles
GROUP BY country_group_roles.name
ORDER BY country_group_roles.name
;
