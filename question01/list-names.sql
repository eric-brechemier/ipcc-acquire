-- AUTHORS WITH MULTIPLE PARTICIPATIONS
-- Q1. Who are the authors that have participated
--     in more than 1, 2, 3, or 4 assessment reports?

USE giec

SELECT
  total AS 'AR Participations',
  name AS 'Author Name'
FROM
(
  SELECT
    CONCAT( authors.first_name, ' ', authors.last_name ) AS name,
    COUNT( DISTINCT participations.ar ) AS total
  FROM authors, participations
  WHERE authors.id = participations.author_id
  GROUP BY participations.author_id
  ORDER BY total DESC, authors.last_name
) author_participations
;
