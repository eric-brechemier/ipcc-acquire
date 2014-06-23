-- BRIDGE AUTHORS
-- Q3. Who are the authors that have participated in
-- more than one working group (what we call bridge authors)?

USE giec

-- IN EACH ECO (Economic) COUNTRY GROUP
-- count the total number of bridge authors

SELECT
  eco_country_groups.name AS 'ECO Country Group',
  COUNT( bridge_authors.author_id ) AS 'Total Bridge Authors'
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
  participations,
  institution_countries,
  groupings country_country_group,
  (
    SELECT id, symbol, name
    FROM groups
    WHERE type = 'ECO'
  ) eco_country_groups
WHERE bridge_authors.author_id = participations.author_id
AND participations.institution_country_id = institution_countries.id
AND institution_countries.country_id = country_country_group.country_id
AND country_country_group.symbol = eco_country_groups.symbol
GROUP BY eco_country_groups.id
ORDER BY `Total Bridge Authors` DESC, `ECO Country Group`
;
