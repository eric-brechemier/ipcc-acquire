-- export the sets of authors grouped by cumulated working group
-- for each type of their mandating institutions

USE 'giec';

-- set limit for the size of a string concatenated with GROUP_CONCAT to a
-- value larger than the number of authors (<10,000) times the size of
-- an identifier + separator (<10) multiplied by 2 for good measure.
SET group_concat_max_len=200000;

SELECT
  institution_type_working_groups.name 'category',
  CONCAT(
    '[',
      GROUP_CONCAT(
        DISTINCT institution_type_working_groups.author_id
        ORDER BY institution_type_working_groups.author_id
        SEPARATOR '|'
      ),
    ']'
  ) 'authors',
  COUNT(
    DISTINCT institution_type_working_groups.author_id
  ) 'total_authors'
FROM
  (
    SELECT
      CONCAT(
        institution_types.name,
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
      institution_types,
      institutions,
      participations
    WHERE
          institution_types.id = institutions.type_id
      AND institutions.id = participations.institution_id
    GROUP BY
      institution_types.id,
      participations.author_id
  ) AS institution_type_working_groups
GROUP BY institution_type_working_groups.name
ORDER BY institution_type_working_groups.name
;
