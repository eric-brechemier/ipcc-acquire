-- BRIDGE AUTHORS
-- Q5. What kind of roles do the authors who participate
-- in more than one working group occupy?

USE giec

-- LIST BRIDGE AUTHORS IN EACH ROLE

SELECT
  roles.name AS 'Role',
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
  roles
WHERE bridge_authors.author_id = authors.id
AND bridge_authors.author_id = participations.author_id
AND participations.role = roles.symbol
GROUP BY roles.id, authors.id
ORDER BY roles.id, authors.last_name
;
