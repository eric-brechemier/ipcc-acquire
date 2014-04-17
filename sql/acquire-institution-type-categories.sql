-- export the sets of authors for each type of institution

USE 'giec';

-- set limit for the size of a string concatenated with GROUP_CONCAT to a
-- value larger than the number of authors (<10,000) times the size of
-- an identifier + separator (<10) multiplied by 2 for good measure.
SET group_concat_max_len=200000;

SELECT
  institution_types.name 'category',
  CONCAT(
    '[',
      GROUP_CONCAT(
        DISTINCT institution_types.author_id
        ORDER BY institution_types.author_id
        SEPARATOR '|'
      ),
    ']'
  ) 'authors',
  COUNT(
    DISTINCT institution_types.author_id
  ) 'total_authors'
FROM
  (
    SELECT
      institution_types.name 'name',
      participations.author_id 'author_id'
    FROM
      participations,
      institutions,
      institution_types
    WHERE
      participations.institution_id = institutions.id
      AND institutions.type_id = institution_types.id
    GROUP BY institution_types.id, participations.author_id
  ) AS institution_types
GROUP BY institution_types.name
ORDER BY institution_types.name
;
