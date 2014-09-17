-- FRENCH AUTHORS
-- Q12. Where are French authors on the IPCC?
-- To which chapters do they contribute the most?

USE giec

-- FOR EACH country,
-- FOR EACH chapter of each working group's assessment report,
-- compute the percentage of
-- participations from the country in this chapter
-- relative to
-- the total of participations from all countries in this chapter
-- ordered by country name (ascending), AR (ascending), WG (ascending),
-- participation ratio (descending)

SELECT
  countries.name AS name,
  participations.ar AS AR,
  participations.wg AS WG,
  participations.chapter AS chapter,
  COUNT(participations.id) AS country_total,
  chapter_participations.total AS all_countries_total,
  (
    COUNT(participations.id)
    / chapter_participations.total
    * 100
  ) AS percentage
FROM
  countries,
  institution_countries,
  participations,
  (
    SELECT
      participations.ar AS ar,
      participations.wg AS wg,
      participations.chapter AS chapter,
      COUNT(participations.id) AS total
    FROM
      countries,
      institution_countries,
      participations
    WHERE
      countries.id = institution_countries.country_id
      AND participations.institution_country_id = institution_countries.id
    GROUP BY
      participations.ar,
      participations.wg,
      participations.chapter
  ) AS chapter_participations
WHERE
  countries.id = institution_countries.country_id
  AND participations.institution_country_id = institution_countries.id
  AND participations.ar = chapter_participations.ar
  AND participations.wg = chapter_participations.wg
  AND participations.chapter = chapter_participations.chapter
GROUP BY
  countries.id,
  participations.ar,
  participations.wg,
  participations.chapter
ORDER BY
  countries.name,
  participations.ar,
  participations.wg,
  percentage DESC
;
