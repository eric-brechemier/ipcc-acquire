-- export the sets of authors for each discipline in each working group

USE 'giec';

-- set limit for the size of a string concatenated with GROUP_CONCAT to a
-- value larger than the number of authors (<10,000) times the size of
-- an identifier + separator (<10) multiplied by 2 for good measure.
SET group_concat_max_len=200000;

SELECT
  disciplines.name 'category',
  CONCAT(
    '[',
      GROUP_CONCAT(
        DISTINCT disciplines.author_id
        ORDER BY disciplines.author_id
        SEPARATOR '|'
      ),
    ']'
  ) 'authors',
  COUNT(
    DISTINCT disciplines.author_id
  ) 'total_authors'
FROM
  (
    SELECT
      CONCAT('WG', participations.wg, ' - ', chapter_types.name) 'name',
      participations.author_id 'author_id'
    FROM
      participations,
      chapters,
      chapter_chapter_types,
      chapter_types
    WHERE
      participations.chapter = chapters.number
      AND chapters.id = chapter_chapter_types.chapter_id
      AND chapter_chapter_types.chapter_type_id = chapter_types.id
    GROUP BY participations.wg, chapters.id, participations.author_id
  ) AS disciplines
GROUP BY disciplines.name
ORDER BY disciplines.name
;
