USE 'giec';
SELECT
  authors.id 'id',
  authors.first_name 'first_name',
  authors.last_name 'last_name',
  GROUP_CONCAT(
    DISTINCT participations.ar
    ORDER BY participations.ar
    SEPARATOR ','
  ) 'assessment_reports'
FROM
  authors,
  participations
WHERE
  authors.id = participations.author_id
GROUP BY authors.id
;
