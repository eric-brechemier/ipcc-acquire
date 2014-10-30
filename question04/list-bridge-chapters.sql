-- BRIDGE AUTHORS
-- Q4. Are there particular chapters of the IPCC
-- where these bridge authors tend to aggregate
-- (i.e. around particular themes)?

-- FOR BRIDGE AUTHORS AS A WHOLE,
-- list the distinct pairs of chapters in distinct working groups
-- with the number of occurrences,
-- and the chapter title, AR and working group of each title

(
  SELECT
    LOWER(
      CONCAT(
        'AR',
        participations1.ar,
        '.WG',
        participations1.wg,
        '.',
        participations1.chapter
      )
    ) AS 'Label',
    'Chapter 1' AS 'Type',
    COUNT(*) AS 'Occurrences Count',
    chapters1.title AS 'Chapter Title',
    CONCAT( 'AR', chapters1.ar ) AS 'AR',
    CONCAT( 'WG', chapters1.wg ) AS 'WG'
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
    participations AS participations1,
    participations AS participations2,
    chapters AS chapters1
  WHERE bridge_authors.author_id = participations1.author_id
  AND bridge_authors.author_id = participations2.author_id
  AND chapters1.ar = participations1.ar
  AND chapters1.wg = participations1.wg
  AND chapters1.number = participations1.chapter
  AND participations1.wg < participations2.wg
  AND (
    participations1.chapter < participations2.chapter
    OR participations1.ar < participations2.ar
  )
  GROUP BY
    participations1.ar,
    participations1.wg,
    participations1.chapter
  ORDER BY Label
)
UNION
(
  SELECT
    LOWER(
      CONCAT(
        'AR',
        participations2.ar,
        '.WG',
        participations2.wg,
        '.',
        participations2.chapter
      )
    ) AS 'Label',
    'Chapter 2' AS 'Type',
    COUNT(*) AS 'Occurrences Count',
    chapters2.title AS 'Chapter Title',
    CONCAT( 'AR', chapters2.ar ) AS 'AR',
    CONCAT( 'WG', chapters2.wg ) AS 'WG'
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
    participations AS participations1,
    participations AS participations2,
    chapters AS chapters2
  WHERE bridge_authors.author_id = participations1.author_id
  AND bridge_authors.author_id = participations2.author_id
  AND chapters2.ar = participations2.ar
  AND chapters2.wg = participations2.wg
  AND chapters2.number = participations2.chapter
  AND participations1.wg < participations2.wg
  AND (
    participations1.chapter < participations2.chapter
    OR participations1.ar < participations2.ar
  )
  GROUP BY
    participations2.ar,
    participations2.wg,
    participations2.chapter
  ORDER BY Label
)
;
