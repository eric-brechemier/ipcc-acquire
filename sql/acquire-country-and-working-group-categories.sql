-- export the sets of authors for each country of mandating institution,
-- grouped by cumulated working group

USE 'giec';

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
      CONCAT(
        countries.name,
        ' - ',
        participations.cumulated_working_group
      ) 'name',
      participations.author_id 'author_id'
    FROM
      (
        SELECT
          id,
          CONCAT(
            'WG',
            GROUP_CONCAT(
              DISTINCT wg
              ORDER BY wg
              SEPARATOR '+'
            )
          ) 'cumulated_working_group',
          author_id,
          institution_id
        FROM participations
        GROUP BY author_id
      ) AS participations,
      institutions,
      countries
    WHERE
      participations.institution_id = institutions.id
      AND institutions.country_id = countries.id
    GROUP BY countries.name, participations.author_id
  ) AS countries
GROUP BY countries.name
ORDER BY countries.name
;
