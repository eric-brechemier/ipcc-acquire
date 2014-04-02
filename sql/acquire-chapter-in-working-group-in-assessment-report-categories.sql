-- export the sets of authors who contributed to each chapter
-- of each assessment report for each working group

USE 'giec';

-- set limit for the size of a string concatenated with GROUP_CONCAT to a
-- value larger than the number of authors (<10,000) times the size of
-- an identifier + separator (<10) multiplied by 2 for good measure.
SET group_concat_max_len=200000;

SELECT
  chapters.name 'category',
  CONCAT(
    '[',
      GROUP_CONCAT(
        DISTINCT chapters.author_id
        ORDER BY chapters.author_id
        SEPARATOR '|'
      ),
    ']'
  ) 'authors',
  COUNT(
    DISTINCT chapters.author_id
  ) 'total_authors'
FROM
  (
    SELECT
      GROUP_CONCAT(
        DISTINCT CONCAT(ar,'.',wg,'.',chapter)
        ORDER BY wg, chapter
        SEPARATOR '|'
      ) 'name',
      author_id
    FROM participations
    GROUP BY ar, wg, chapter, author_id
  ) AS chapters
GROUP BY chapters.name
ORDER BY chapters.name
;
