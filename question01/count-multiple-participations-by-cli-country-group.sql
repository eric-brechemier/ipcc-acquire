-- AUTHORS WITH MULTIPLE PARTICIPATIONS
-- Q1. Who are the authors that have participated
--     in more than 1, 2, 3, or 4 assessment reports?

USE giec

-- IN EACH CLI (Climate) COUNTRY GROUP,
-- count the authors who contributed to:
-- * 1+ assessment reports
-- * 2+ assessment reports
-- * 3+ assessment reports
-- * 4+ assessment reports
-- * 5  assessment reports

SELECT
  CONCAT(total_ar,'+') AS 'Cumulated AR',
  total_authors AS 'Total Authors',
  groups.name AS 'CLI Country Group'
FROM
  (
    SELECT
      cumulated_assessment_reports.total AS total_ar,
      group_symbol,
      SUM( cli_total_participations.total_authors ) AS total_authors
    FROM
      (
        SELECT id AS total
        FROM assessment_reports
      ) cumulated_assessment_reports,
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
                    WHERE type = 'CLI'
                  ) cli_country_groups
                WHERE groupings.symbol = cli_country_groups.group_symbol
              ) cli_countries
            WHERE
              participations.institution_country_id = institution_countries.id
              AND institution_countries.country_id = cli_countries.id
            GROUP BY group_symbol, author_id, ar
          ) cli_distinct_author_distinct_ar_participations
          GROUP BY group_symbol, author_id
        ) cli_distinct_author_ar_participations
        GROUP BY group_symbol, total_ar_participations
      ) cli_total_participations
    WHERE
      cli_total_participations.total_ar_participations
      >=
      cumulated_assessment_reports.total
    GROUP BY cumulated_assessment_reports.total, group_symbol
  ) total_participations_by_cli_country,
  groups
WHERE groups.symbol = group_symbol
ORDER BY total_ar, groups.name
;
