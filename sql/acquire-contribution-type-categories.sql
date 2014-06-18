-- export the sets of authors for each contribution type

USE 'giec';

-- set limit for the size of a string concatenated with GROUP_CONCAT to a
-- value larger than the number of authors (<10,000) times the size of
-- an identifier + separator (<10) multiplied by 2 for good measure.
SET group_concat_max_len=200000;

SELECT
  contribution_type.name 'category',
  CONCAT(
    '[',
      GROUP_CONCAT(
        DISTINCT contribution_type.author_id
        ORDER BY contribution_type.author_id
        SEPARATOR '|'
      ),
    ']'
  ) 'authors',
  COUNT(
    DISTINCT contribution_type.author_id
  ) 'total_authors'
FROM
  (
    SELECT
      CONCAT(
        'AR', participations.ar,
        '.WG', participations.wg,
        '.', participations.role,
        '.AT', institution_countries.institution_id,
        '.OF', institution_countries.country_id,
        '.x', COUNT(participations.author_id)
      ) 'name',
      author_id
    FROM
      participations,
      institution_countries
    WHERE
      participations.institution_country_id = institution_countries.id
    GROUP BY
      participations.ar,
      participations.wg,
      participations.role,
      institution_countries.institution_id,
      institution_countries.country_id,
      participations.author_id
  ) AS contribution_type
GROUP BY contribution_type.name
ORDER BY contribution_type.name
;
