-- COUNTRY PARTICIPATION OVER TIME
-- Q.13. Which countries have increased their participation in the IPCC
--       and which have decreased their participation over time?

USE giec

-- FOR EACH COUNTRY, in each Assessment Report,
-- list authors and their roles

SELECT
  countries.name AS 'Country',
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
  countries,
  authors
WHERE participations.institution_country_id = institution_countries.id
AND institution_countries.country_id = countries.id
AND participations.author_id = authors.id
GROUP BY countries.id, participations.ar, participations.author_id
ORDER BY countries.id, participations.ar, authors.last_name
;
