-- INSTITUTION PARTICIPATION OVER TIME
-- Q.14. Which institutions have increased or decreased
--       the most in participation over time?

-- FOR EACH INSTITUTION, in each Assessment Report,
-- list authors and their roles

SELECT
  institutions.name AS 'Institution',
  CONCAT( 'AR', participations.ar ) AS 'AR',
  CONCAT( authors.first_name, ' ', authors.last_name ) AS 'Author',
  GROUP_CONCAT(
    DISTINCT participations.role
    ORDER BY participations.role
    SEPARATOR ', '
  ) AS 'Roles'
FROM
  participations,
  institution_countries,
  institutions,
  authors
WHERE participations.institution_country_id = institution_countries.id
AND institution_countries.institution_id = institutions.id
AND participations.author_id = authors.id
GROUP BY institutions.id, participations.ar, participations.author_id
ORDER BY institutions.name, participations.ar, authors.last_name
;
