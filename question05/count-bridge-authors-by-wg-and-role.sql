-- BRIDGE AUTHORS
-- Q5. What kind of roles do the authors who participate
-- in more than one working group occupy?

-- In each cumulated working group,
-- count the total number of bridge authors
-- IN EACH ROLE

SELECT
  CONCAT( 'WG ', wg ) AS 'WG',
  COUNT( participations.author_id ) AS 'Total Bridge Authors',
  roles.name AS 'Role'
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
  roles
WHERE bridge_authors.author_id = participations.author_id
AND participations.role = roles.symbol
GROUP BY wg, roles.id
ORDER BY wg, `Total Bridge Authors` DESC
;
