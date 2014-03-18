USE 'giec';
SELECT
  authors.id 'id',
  authors.first_name 'first_name',
  authors.last_name 'last_name',
  CONCAT(
    '[',
    GROUP_CONCAT(
      DISTINCT participations.ar
      ORDER BY participations.ar
      SEPARATOR '|'
    ),
    ']'
  ) 'assessment_reports',
  CONCAT(
    '[',
    GROUP_CONCAT(
      DISTINCT participations.working_groups
      ORDER BY participations.ar
      SEPARATOR '|'
    ),
    ']'
  ) 'working_groups',
  CONCAT(
    '[',
    GROUP_CONCAT(
      DISTINCT participations.chapters
      ORDER BY participations.ar
      SEPARATOR '|'
    ),
    ']'
  ) 'chapters',
  CONCAT(
    '[',
    GROUP_CONCAT(
      DISTINCT participations.roles
      ORDER BY participations.ar
      SEPARATOR '|'
    ),
    ']'
  ) 'roles',
  CONCAT(
    '[',
    GROUP_CONCAT(
      DISTINCT institutions.name
      ORDER BY institutions.name
      SEPARATOR '|'
    ),
    ']'
  ) 'institutions',
  CONCAT(
    '[',
    GROUP_CONCAT(
      DISTINCT institution_types.symbol
      ORDER BY institution_types.symbol
      SEPARATOR '|'
    ),
    ']'
  ) 'institution_type_symbols',
  CONCAT(
    '[',
    GROUP_CONCAT(
      DISTINCT countries.name
      ORDER BY countries.name
      SEPARATOR '|'
    ),
    ']'
  ) 'countries',
  CONCAT(
    '[',
    GROUP_CONCAT(
      DISTINCT groupings.symbol
      ORDER BY groupings.symbol
      SEPARATOR '|'
    ),
    ']'
  ) 'groupings_symbols'
FROM
  authors,
  (
    SELECT
      author_id,
      ar,
      GROUP_CONCAT(
        DISTINCT CONCAT(ar,'.',wg)
        ORDER BY wg
        SEPARATOR '|'
      ) 'working_groups',
      GROUP_CONCAT(
        DISTINCT CONCAT(ar,'.',wg,'.',chapter)
        ORDER BY wg, chapter
        SEPARATOR '|'
      ) 'chapters',
      GROUP_CONCAT(
        DISTINCT CONCAT(ar,'.',wg,'.',chapter,'.',role)
        ORDER BY wg, chapter, role
        SEPARATOR '|'
      ) 'roles',
      institution_id
    FROM participations
    GROUP BY author_id, ar
  ) AS participations,
  (
    SELECT
      id,
      name,
      type_id,
      country_id
    FROM institutions
  ) AS institutions,
  (
    SELECT
      id,
      symbol
    FROM institution_types
  ) AS institution_types,
  (
    SELECT
      id,
      name
    FROM countries
  ) AS countries,
  (
    SELECT
      country_id,
      symbol
    FROM groupings
  ) AS groupings
WHERE
  authors.id = participations.author_id
  AND institutions.id = participations.institution_id
  AND institutions.type_id = institution_types.id
  AND countries.id = institutions.country_id
  AND groupings.country_id = institutions.country_id
GROUP BY authors.id
;
