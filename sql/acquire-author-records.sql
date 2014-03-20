USE 'giec';
SELECT
  authors.id 'id',
  authors.first_name 'first_name',
  authors.last_name 'last_name',
  CONCAT(
    '[',
    GROUP_CONCAT(
      DISTINCT participations.contributions
      ORDER BY participations.ar
      SEPARATOR '|'
    ),
    ']'
  ) 'contributions',
  COUNT(
    DISTINCT participations.contributions
  ) 'total_contributions',
  CONCAT(
    '[',
    GROUP_CONCAT(
      DISTINCT participations.role
      ORDER BY participations.role
      SEPARATOR '|'
    ),
    ']'
  ) 'roles',
  CONCAT(
    '[',
    GROUP_CONCAT(
      DISTINCT participations.chapters
      ORDER BY participations.chapters
      SEPARATOR '|'
    ),
    ']'
  ) 'chapters',
  CONCAT(
    '[',
    GROUP_CONCAT(
      DISTINCT participations.wg
      ORDER BY participations.wg
      SEPARATOR '|'
    ),
    ']'
  ) 'working_groups',
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
      DISTINCT institutions.name
      ORDER BY institutions.name
      SEPARATOR '|'
    ),
    ']'
  ) 'institutions',
  CONCAT(
    '[',
    GROUP_CONCAT(
      DISTINCT countries.name
      ORDER BY countries.name
      SEPARATOR '|'
    ),
    ']'
  ) 'countries'
FROM
  authors,
  (
    SELECT
      author_id,
      ar,
      wg,
      role,
      GROUP_CONCAT(
        DISTINCT CONCAT(ar,'.',wg,'.',chapter,'.',role)
        ORDER BY wg, chapter, role
        SEPARATOR '|'
      ) 'contributions',
      GROUP_CONCAT(
        DISTINCT CONCAT(ar,'.',wg,'.',chapter)
        ORDER BY wg, chapter
        SEPARATOR '|'
      ) 'chapters',
      institution_id
    FROM participations
    GROUP BY author_id, ar
  ) AS participations,
  (
    SELECT
      id,
      name,
      country_id
    FROM institutions
  ) AS institutions,
  (
    SELECT
      id,
      name
    FROM countries
  ) AS countries
WHERE
  authors.id = participations.author_id
  AND institutions.id = participations.institution_id
  AND countries.id = institutions.country_id
GROUP BY authors.id
;
