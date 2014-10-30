-- export the sets of authors grouped by country groups
-- to which the country of their mandating institutions belong

-- set limit for the size of a string concatenated with GROUP_CONCAT to a
-- value larger than the number of authors (<10,000) times the size of
-- an identifier + separator (<10) multiplied by 2 for good measure.
SET group_concat_max_len=200000;

SELECT
  country_groups.name 'category',
  CONCAT(
    '[',
      GROUP_CONCAT(
        DISTINCT country_groups.author_id
        ORDER BY country_groups.author_id
        SEPARATOR '|'
      ),
    ']'
  ) 'authors',
  COUNT(
    DISTINCT country_groups.author_id
  ) 'total_authors'
FROM
  (
    SELECT
      groupings.symbol 'name',
      participations.author_id 'author_id'
    FROM
      participations,
      institution_countries,
      groupings
    WHERE
          participations.institution_country_id = institution_countries.id
      AND institution_countries.country_id = groupings.country_id
  ) AS country_groups
GROUP BY country_groups.name
ORDER BY country_groups.name
;
