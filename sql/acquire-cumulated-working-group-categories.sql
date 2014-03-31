-- export the sets of authors in each cumulated working group

-- A cumulated working group is the set of authors who contributed
-- to the same working groups, and no others. With 3 working groups,
-- there are 7 cumulated working groups corresponding to:
-- * authors who worked in a single working group: WG1, WG2, WG3
-- * authors who worked in just two groups: WG1+2, WG1+3, WG2+3
-- * authors who working in all three groups: WG1+2+3

USE 'giec';
-- set limit for the size of a string concatenated with GROUP_CONCAT to a
-- value larger than the number of authors (<10,000) times the size of
-- an identifier + separator (<10) multiplied by 2 for good measure.
SET group_concat_max_len=200000;
SELECT
  working_groups.name 'category',
  CONCAT(
    '[',
      GROUP_CONCAT(
        DISTINCT working_groups.author_id
        ORDER BY working_groups.author_id
        SEPARATOR '|'
      ),
    ']'
  ) 'authors',
  COUNT(
    DISTINCT working_groups.author_id
  ) 'total_authors'
FROM
(
  SELECT
    CONCAT(
      'WG',
      GROUP_CONCAT(
        DISTINCT wg
        ORDER BY wg
        SEPARATOR '+'
      )
    ) name,
    author_id
  FROM participations
  GROUP BY author_id
) AS working_groups
GROUP BY working_groups.name
ORDER BY working_groups.name
;
