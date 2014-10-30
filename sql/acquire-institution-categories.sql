-- export the sets of authors mandated by each institution

-- set limit for the size of a string concatenated with GROUP_CONCAT to a
-- value larger than the number of authors (<10,000) times the size of
-- an identifier + separator (<10) multiplied by 2 for good measure.
SET group_concat_max_len=200000;

SELECT
  institutions.name 'category',
  CONCAT(
    '[',
      GROUP_CONCAT(
        DISTINCT institutions.author_id
        ORDER BY institutions.author_id
        SEPARATOR '|'
      ),
    ']'
  ) 'authors',
  COUNT(
    DISTINCT institutions.author_id
  ) 'total_authors'
FROM
  (
    SELECT
      institutions.name 'name',
      participations.author_id 'author_id'
    FROM
      participations,
      institution_countries,
      institutions
    WHERE
          participations.institution_country_id =
            institution_countries.id
      AND institution_countries.institution_id = institutions.id
    GROUP BY institutions.id, participations.author_id
  ) AS institutions
GROUP BY institutions.name
ORDER BY institutions.name
;
