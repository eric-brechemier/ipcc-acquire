-- BRIDGE AUTHORS
-- Q4. Are there particular chapters of the IPCC
-- where these bridge authors tend to aggregate
-- (i.e. around particular themes)?

-- FOR EACH BRIDGE AUTHOR,
-- list the distinct pairs of chapters in distinct working groups
-- (data to be imported in Table 2 Net as CSV,
--  then in Gephi to create a network)

SELECT
  CONCAT( 'WG', cumulated_wg ) 'Cumulated Working Group',
  CONCAT( first_name, ' ', last_name ) AS 'Bridge Author Name',
  CONCAT(
    'AR',
    participations1.ar,
    '.WG',
    participations1.wg,
    '.',
    participations1.chapter
  ) AS 'Chapter 1',
  CONCAT(
    'AR',
    participations2.ar,
    '.WG',
    participations2.wg,
    '.',
    participations2.chapter
  ) AS 'Chapter 2'
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
  participations AS participations1,
  participations AS participations2
WHERE bridge_authors.author_id = authors.id
AND bridge_authors.author_id = participations1.author_id
AND bridge_authors.author_id = participations2.author_id
AND participations1.wg < participations2.wg
AND (
  participations1.chapter < participations2.chapter
  OR participations1.ar < participations2.ar
)
ORDER BY
  total_wg DESC,
  cumulated_wg,
  authors.last_name,
  participations1.wg,
  participations1.chapter,
  participations1.ar,
  participations2.wg,
  participations2.chapter,
  participations2.ar
;
