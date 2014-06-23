-- BRIDGE AUTHORS
-- Q4. Are there particular chapters of the IPCC
-- where these bridge authors tend to aggregate
-- (i.e. around particular themes)?

USE giec

-- LIST BRIDGE AUTHORS IN EACH TYPE OF CHAPTER

SELECT
  chapter_types.name AS 'Chapter Type',
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
  chapters,
  chapter_chapter_types,
  chapter_types
WHERE bridge_authors.author_id = authors.id
AND bridge_authors.author_id = participations.author_id
AND participations.ar = chapters.ar
AND participations.wg = chapters.wg
AND participations.chapter = chapters.number
AND chapters.id = chapter_chapter_types.chapter_id
AND chapter_chapter_types.chapter_type_id = chapter_types.id
GROUP BY chapter_types.id, authors.id
ORDER BY chapter_types.id DESC, authors.last_name
;
