-- AUTHORS WITH MULTIPLE PARTICIPATIONS
-- Q1. Who are the authors that have participated
--     in more than 1, 2, 3, or 4 assessment reports?

-- IN EACH ECO (Economic) COUNTRY GROUP,
-- count the authors who contributed to:
-- * 1 assessment reports
-- * 2 assessment reports
-- * 3 assessment reports
-- * 4 assessment reports
-- * 5 assessment reports

SELECT
  total_ar_participations AS 'Total AR Participations',
  total_authors AS 'Total Authors',
  groups.name AS 'ECO Country Group'
FROM
  (
    SELECT
      total_ar_participations,
      COUNT(author_id) AS total_authors,
      group_symbol
    FROM
    (
      SELECT
        group_symbol,
        author_id,
        COUNT(ar) AS total_ar_participations
      FROM
      (
        SELECT group_symbol, author_id, ar
        FROM
          participations,
          institution_countries,
          (
            SELECT
              country_id AS id,
              group_symbol
            FROM
              groupings,
              (
                SELECT symbol AS group_symbol
                FROM groups
                WHERE type = 'ECo'
              ) eco_country_groups
            WHERE groupings.symbol = eco_country_groups.group_symbol
          ) eco_countries
        WHERE
          participations.institution_country_id = institution_countries.id
          AND institution_countries.country_id = eco_countries.id
        GROUP BY group_symbol, author_id, ar
      ) eco_distinct_author_distinct_ar_participations
      GROUP BY group_symbol, author_id
    ) eco_distinct_author_ar_participations
    GROUP BY group_symbol, total_ar_participations
  ) eco_total_participations,
  groups
WHERE groups.symbol = group_symbol
ORDER BY total_ar_participations, total_authors DESC, groups.name
;
