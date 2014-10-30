-- BRIDGE AUTHORS
-- Q3. Who are the authors that have participated in
-- more than one working group (what we call bridge authors)?

-- LIST BRIDGE AUTHORS IN EACH INSTITUTION

SELECT
  institutions.name AS 'Institution',
  CONCAT( 'WG', cumulated_wg ) AS 'Cumulated WG',
  CONCAT( first_name, ' ', last_name ) AS 'Bridge Author Name'
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
  participations,
  institution_countries,
  institutions
WHERE bridge_authors.author_id = authors.id
AND bridge_authors.author_id = participations.author_id
AND participations.institution_country_id = institution_countries.id
AND institution_countries.institution_id = institutions.id
GROUP BY institutions.id, authors.id
ORDER BY institutions.name, total_wg DESC, cumulated_wg, last_name
;
