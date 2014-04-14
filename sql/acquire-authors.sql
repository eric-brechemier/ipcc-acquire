-- export the list of authors, ordered by author id
USE 'giec';

SELECT
  authors.id 'id',
  authors.first_name 'first_name',
  authors.last_name 'last_name',
  CONCAT(
    '[',
    GROUP_CONCAT(
      cumulated_contributions.cumulated_contributions_code
      ORDER BY
        cumulated_contributions.cumulated_contributions_code
      SEPARATOR '|'
    ),
    ']'
  ) 'contributions',
  SUM(
    cumulated_contributions.cumulated_contributions_number
  ) AS 'total_contributions'
FROM
  authors,
  (
    SELECT
      contributions.author_id AS 'author_id',
      CONCAT(
        contributions.contribution_code,
        '.x',
        COUNT(contributions.contribution_code)
      ) AS 'cumulated_contributions_code',
      COUNT(
        contributions.contribution_code
      ) AS 'cumulated_contributions_number'
    FROM
      (
        SELECT
          participations.author_id AS 'author_id',
          CONCAT(
            participations.ar,
            '.',
            participations.wg,
            '.',
            roles.id,
            '.',
            institutions.id,
            '.',
            institution_countries.country_id
          ) AS 'contribution_code'
        FROM
          (
            SELECT
              author_id,
              ar,
              wg,
              role AS role_symbol,
              institution_id AS institution_country_id
            FROM participations
          ) AS participations,
          (
            SELECT
              id,
              symbol
            FROM roles
          ) AS roles,
          (
            SELECT
              id,
              name AS institution_name,
              country_id
            FROM institutions
          ) AS institution_countries,
          (
            SELECT
              MIN(id) AS 'id',
              name
            FROM institutions
            GROUP BY name
          ) AS institutions
        WHERE
            participations.role_symbol = roles.symbol
        AND participations.institution_country_id = institution_countries.id
        AND institution_countries.institution_name = institutions.name
      ) AS contributions
    GROUP BY
      contributions.author_id,
      contributions.contribution_code
  ) AS cumulated_contributions
WHERE authors.id = cumulated_contributions.author_id
GROUP BY authors.id
ORDER BY authors.id
;
