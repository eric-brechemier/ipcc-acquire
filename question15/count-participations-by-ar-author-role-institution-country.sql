-- DIVERSITY
-- Q.15. What are the differences in diversity (by country and by institution)
--       between the working groups?

-- FOR EACH WMO REGION
-- FOR EACH COUNTRY
-- FOR EACH TYPE OF INSTITUTION
-- FOR EACH INSTITUTION
-- FOR EACH ROLE (SEPARATED)
-- FOR EACH AUTHOR (REPEATED BY ROLE, INSTITUTION...)
-- FOR EACH ASSESSMENT REPORT
-- count the total number of participations

SELECT
  country_groups.symbol AS 'WMO Region Symbol',
  countries.name AS 'Country Name',
  institution_types.symbol AS 'Institution Type Symbol',
  institutions.name AS 'Institution Name',
  roles.symbol AS 'Role Symbol',
  CONCAT( authors.first_name, ' ', authors.last_name ) AS 'Author Name',
  CONCAT( 'AR', participations.ar ) AS 'AR',
  COUNT( participations.id ) AS 'Total'
FROM
  groups AS country_groups,
  groupings AS country_country_groups,
  countries,
  institution_countries,
  institutions,
  institution_types,
  participations,
  roles,
  authors
WHERE country_groups.type = 'WMO'
AND country_groups.symbol = country_country_groups.symbol
AND country_country_groups.country_id = countries.id
AND countries.id = institution_countries.country_id
AND institution_countries.institution_id = institutions.id
AND institutions.institution_type_id = institution_types.id
AND institution_countries.id = participations.institution_country_id
AND participations.role = roles.symbol
AND participations.author_id = authors.id
GROUP BY
  country_groups.id,
  countries.id,
  institution_types.id,
  roles.id,
  authors.id,
  participations.ar
ORDER BY
  country_groups.symbol,
  countries.name,
  institution_types.symbol,
  institutions.name,
  roles.rank,
  authors.last_name,
  authors.first_name,
  participations.ar
;
