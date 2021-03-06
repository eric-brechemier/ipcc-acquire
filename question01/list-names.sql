-- AUTHORS WITH MULTIPLE PARTICIPATIONS
-- Q1. Who are the authors that have participated
--     in more than 1, 2, 3, or 4 assessment reports?

SELECT
  COUNT(
    DISTINCT participations.ar
  ) AS 'Total AR',
  CONCAT(
    authors.first_name,
    ' ',
    authors.last_name
  ) AS 'Author Name'
FROM authors, participations
WHERE authors.id = participations.author_id
GROUP BY participations.author_id
ORDER BY `Total AR` DESC, authors.last_name
;
