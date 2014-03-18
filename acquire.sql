USE 'giec';
SELECT
  authors.id 'id',
  authors.first_name 'first_name',
  authors.last_name 'last_name',
  GROUP_CONCAT(
    DISTINCT participations.ar
    ORDER BY participations.ar
    SEPARATOR ','
  ) 'assessment_reports',
  participations.working_groups,
  participations.chapters,
  participations.roles
FROM
  authors,
  (
    SELECT
      author_id,
      ar,
      GROUP_CONCAT(
        DISTINCT CONCAT(ar,'.',wg)
        ORDER BY wg
        SEPARATOR ','
      ) 'working_groups',
      GROUP_CONCAT(
        DISTINCT CONCAT(ar,'.',wg,'.',chapter)
        ORDER BY wg, chapter
        SEPARATOR ','
      ) 'chapters',
      GROUP_CONCAT(
        DISTINCT CONCAT(ar,'.',wg,'.',chapter,'.',role)
        ORDER BY wg, chapter, role
        SEPARATOR ','
      ) 'roles'
    FROM participations
    GROUP BY author_id, ar
  ) AS participations
WHERE
  authors.id = participations.author_id
GROUP BY authors.id
;
