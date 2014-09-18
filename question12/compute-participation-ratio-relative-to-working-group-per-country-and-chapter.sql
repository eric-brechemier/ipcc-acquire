-- FRENCH AUTHORS
-- Q12. Where are French authors on the IPCC?
-- To which chapters do they contribute the most?

USE giec

-- FOR EACH country,
-- FOR EACH chapter of each working group's assessment report,
-- compute the percentage of
-- participations from the country in this chapter
-- relative to
-- the total participation of this country in this working group
-- in the same assessment report.

SELECT
  countries.name AS 'Country',
  participations.ar AS 'AR',
  participations.wg AS 'WG',
  participations.chapter AS 'Chapter',
  COUNT(participations.id) AS 'Chapter Participation',
  country_wg_participations.total AS 'WG Participation',
  (
    COUNT(participations.id)
    / country_wg_participations.total
    * 100
  ) AS 'Percentage'
FROM
  countries,
  institution_countries,
  participations,
  (
    SELECT
      countries.id AS country_id,
      participations.ar AS ar,
      participations.wg AS wg,
      COUNT(participations.id) AS total
    FROM
      countries,
      institution_countries,
      participations
    WHERE
      countries.id = institution_countries.country_id
      AND participations.institution_country_id = institution_countries.id
    GROUP BY
      countries.id,
      participations.ar,
      participations.wg
  ) AS country_wg_participations
WHERE
  countries.id = institution_countries.country_id
  AND participations.institution_country_id = institution_countries.id
  AND countries.id = country_wg_participations.country_id
  AND participations.ar = country_wg_participations.ar
  AND participations.wg = country_wg_participations.wg
GROUP BY
  countries.id,
  participations.ar,
  participations.wg,
  participations.chapter
ORDER BY
  countries.name,
  participations.ar,
  participations.wg,
  Percentage DESC
;
