-- export the list of participations for use as a spreadsheet 'Full Table'

-- The original spreadsheet listed AR participations:
-- 1 row per Author per AR,
-- ordered by last name, then first name, then AR
--   id - author id
--   first_name - author first name
--   last_name - author last name
--   AR - AR number
--   WG - WG number
--   chapters - list separated with '|',
--              in the format 'wg{WG}.{CHAPTER}'
--              with WG the working group number
--              and CHAPTER the chapter number or code
--   roles - list of role codes, separated with ','
--           in no particular order (maybe temporal order)
--   institution - name of the institution (unique in an AR)
--   institution_type - name of institution type (unique in an AR)
--   country - name of the country (unique in an AR)
--   groupings - list of codes of country groups for the country,
--               separated with ', ', in no particular order

-- In this version, each participation is exported as a separate row,
-- which leaves only the groupings column as a multivalued field.

USE giec;

SELECT
  authors.id AS 'id',
  authors.first_name AS 'first_name',
  authors.last_name AS 'last_name',
  participations.ar AS 'AR',
  participations.wg AS 'WG',
  participations.chapter AS 'Chapter',
  participations.role AS 'Role',
  institutions.name AS 'Institution',
  institution_types.name AS 'Institution Type',
  countries.name AS 'Country',
  GROUP_CONCAT(
    DISTINCT groupings.symbol
    ORDER BY groupings.symbol
    SEPARATOR ', '
  ) AS 'groupings'
FROM
  participations,
  authors,
  institution_countries,
  institutions,
  institution_types,
  countries,
  groupings
WHERE
      participations.author_id = authors.id
  AND participations.institution_country_id = institution_countries.id
  AND institution_countries.institution_id = institutions.id
  AND institution_countries.country_id = countries.id
  AND countries.id = groupings.country_id
GROUP BY participations.id
ORDER BY
  authors.last_name,
  authors.first_name,
  participations.ar;
