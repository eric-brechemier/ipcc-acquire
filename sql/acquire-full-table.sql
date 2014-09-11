-- export the list of participations for use as a spreadsheet 'Full Table'

-- This export aims to produce data as similar as possible to the
-- original spreadsheet, to avoid disruption.
-- One difference is that role are now sorted by rank.

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
--           in no visible order (maybe temporal order)
--   institution - name of the institution (unique in an AR)
--   institution_type - name of institution type (unique in an AR)
--   country - name of the country (unique in an AR)
--   groupings - list of codes of country groups for the country,
--               separated with ', ', in no particular order

USE giec;

SELECT
  authors.id AS 'id',
  authors.first_name AS 'first_name',
  authors.last_name AS 'last_name',
  participations.ar AS 'AR',
  participations.wg AS 'WG',
  GROUP_CONCAT(
    CONCAT(
      'wg',
      participations.wg,
      '.',
      participations.chapter
    )
    ORDER BY
      participations.wg,
      participations.chapter
    SEPARATOR '|'
  ) AS 'chapters',
  GROUP_CONCAT(
    DISTINCT participations.role
    ORDER BY roles.rank
    SEPARATOR ','
  ) AS 'Role',
  institutions.name AS 'Institution',
  institution_types.name AS 'Institution Type',
  countries.name AS 'Country',
  country_groups.symbols AS 'groupings'
FROM
  participations,
  authors,
  roles,
  institution_countries,
  institutions,
  institution_types,
  countries,
  (
    SELECT
      country_id,
      GROUP_CONCAT(
        symbol
        ORDER BY symbol
        SEPARATOR ', '
      ) AS 'symbols'
    FROM groupings
    GROUP BY country_id
  ) AS country_groups
WHERE
      participations.author_id = authors.id
  AND participations.role = roles.symbol
  AND participations.institution_country_id = institution_countries.id
  AND institution_countries.institution_id = institutions.id
  AND institutions.institution_type_id = institution_types.id
  AND institution_countries.country_id = countries.id
  AND countries.id = country_groups.country_id
GROUP BY
  participations.ar,
  participations.author_id
ORDER BY
  authors.last_name,
  authors.first_name,
  participations.ar;
