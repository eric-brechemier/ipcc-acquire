-- BRIDGE AUTHORS
-- Q4. Are there particular chapters of the IPCC
-- where these bridge authors tend to aggregate
-- (i.e. around particular themes)?

USE giec

-- FOR EACH BRIDGE AUTHOR,
-- list the name,
-- countries, institution types, total AR participations, chapters
-- (with multiple values separated by semicolons)

SELECT
  CONCAT( first_name, ' ', last_name ) AS 'Bridge Author Name',
  GROUP_CONCAT(
    DISTINCT countries.name
    ORDER BY countries.name
    SEPARATOR ';'
  ) AS 'Countries',
  GROUP_CONCAT(
    DISTINCT institution_types.name
    ORDER BY institution_types.name
    SEPARATOR ';'
  ) AS 'Institution Types',
  COUNT(
    DISTINCT participations.ar
  ) AS 'Total AR Participations',
  GROUP_CONCAT(
    DISTINCT participations.chapter
    ORDER BY participations.chapter
    SEPARATOR ';'
  ) AS 'Chapters'
FROM
  (
    SELECT
      author_id,
      COUNT( DISTINCT wg ) AS total_wg,
      GROUP_CONCAT(
        DISTINCT wg
        ORDER BY wg
        SEPARATOR '+'
      ) AS cumulated_wg
    FROM participations
    GROUP BY author_id
    HAVING total_wg > 1
  ) bridge_authors,
  authors,
  (
    SELECT
      author_id,
      institution_country_id,
      ar,
      LOWER(
        CONCAT(
          'AR',
          ar,
          '.WG',
          wg,
          '.',
          chapter
        )
      ) AS chapter
    FROM participations
  ) participations,
  institution_countries,
  countries,
  institutions,
  institution_types
WHERE bridge_authors.author_id = authors.id
AND bridge_authors.author_id = participations.author_id
AND participations.institution_country_id = institution_countries.id
AND institution_countries.country_id = countries.id
AND institution_countries.institution_id = institutions.id
AND institutions.institution_type_id = institution_types.id
GROUP BY bridge_authors.author_id
ORDER BY authors.last_name, authors.first_name
;
