-- export the sets of authors for each country of mandating institutions

-- set limit for the size of a string concatenated with GROUP_CONCAT to a
-- value larger than the number of authors (<10,000) times the size of
-- an identifier + separator (<10) multiplied by 2 for good measure.
SET group_concat_max_len=200000;

SELECT
  countries.name 'category',
  CONCAT(
    '[',
      GROUP_CONCAT(
        DISTINCT countries.author_id
        ORDER BY countries.author_id
        SEPARATOR '|'
      ),
    ']'
  ) 'authors',
  COUNT(
    DISTINCT countries.author_id
  ) 'total_authors'
FROM
  (
    SELECT
      countries.name 'name',
      participations.author_id 'author_id'
    FROM
      participations,
      institution_countries,
      countries
    WHERE
      participations.institution_country_id = institution_countries.id
      AND institution_countries.country_id = countries.id
    GROUP BY countries.id, participations.author_id
  ) AS countries
GROUP BY countries.name
ORDER BY countries.name
;
