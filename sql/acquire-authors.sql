-- export the list of authors, ordered by author id
SELECT
  authors.id 'id',
  authors.first_name 'first_name',
  authors.last_name 'last_name',
  CONCAT(
    '[',
    GROUP_CONCAT(
      contributions.contribution_code
      ORDER BY
        contributions.contribution_code
      SEPARATOR '|'
    ),
    ']'
  ) 'contributions',
  COUNT(
    contributions.contribution_code
  ) AS 'total_contributions'
FROM
  authors,
  (
    SELECT
      participations.author_id AS 'author_id',
      CONCAT(
        participations.ar,
        '.',
        participations.wg,
        '.',
        participations.chapter,
        '.',
        roles.id,
        '.',
        institution_countries.country_id,
        '.',
        institutions.institution_type_id,
        '.',
        institutions.id
      ) AS 'contribution_code'
    FROM
      (
        SELECT
          author_id,
          ar,
          wg,
          chapter,
          role AS role_symbol,
          institution_country_id
        FROM participations
      ) AS participations,
      (
        SELECT
          id,
          symbol
        FROM roles
      ) AS roles,
      institution_countries,
      institutions
    WHERE
        participations.role_symbol = roles.symbol
    AND participations.institution_country_id = institution_countries.id
    AND institution_countries.institution_id = institutions.id
  ) AS contributions
WHERE authors.id = contributions.author_id
GROUP BY authors.id
ORDER BY authors.id
;
