-- COUNTRY PARTICIPATION OVER TIME
-- Q.13. Which countries have increased their participation in the IPCC
--       and which have decreased their participation over time?

-- FOR EACH COUNTRY
-- count the total of authors in each Assessment Report

SELECT
  countries.name AS 'Country',
  CONCAT( 'AR', participations.ar ) AS 'AR',
  COUNT( DISTINCT participations.author_id ) AS 'Total Authors'
FROM
  participations,
  institution_countries,
  countries
WHERE participations.institution_country_id = institution_countries.id
AND institution_countries.country_id = countries.id
GROUP BY countries.id, participations.ar
ORDER BY countries.id, participations.ar
;
