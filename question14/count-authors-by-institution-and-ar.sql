-- INSTITUTION PARTICIPATION OVER TIME
-- Q.14. Which institutions have increased or decreased
--       the most in participation over time?

-- FOR EACH INSTITUTION
-- count the total of authors in each Assessment Report

SELECT
  institutions.name AS 'Institution',
  CONCAT( 'AR', participations.ar ) AS 'AR',
  COUNT( DISTINCT participations.author_id ) AS 'Total Authors'
FROM
  participations,
  institution_countries,
  institutions
WHERE participations.institution_country_id = institution_countries.id
AND institution_countries.institution_id = institutions.id
GROUP BY institutions.id, participations.ar
ORDER BY institutions.name, participations.ar
;
