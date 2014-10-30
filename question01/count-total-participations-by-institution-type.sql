-- AUTHORS WITH MULTIPLE PARTICIPATIONS
-- Q1. Who are the authors that have participated
--     in more than 1, 2, 3, or 4 assessment reports?

-- IN EACH TYPE OF INSTITUTION,
-- count the authors who contributed to:
-- * 1 assessment reports
-- * 2 assessment reports
-- * 3 assessment reports
-- * 4 assessment reports
-- * 5 assessment reports

SELECT
  total_ar_participations AS 'Total AR Participations',
  total_authors AS 'Total Authors',
  institution_types.name AS 'Institution Type'
FROM
  (
    SELECT
      total_ar_participations,
      COUNT(author_id) AS total_authors,
      institution_type_id
    FROM
    (
      SELECT
        institution_type_id,
        author_id,
        COUNT(ar) AS total_ar_participations
      FROM
      (
        SELECT institution_type_id, author_id, ar
        FROM
          participations,
          institution_countries,
          institutions
        WHERE
          participations.institution_country_id = institution_countries.id
          AND institution_countries.institution_id = institutions.id
        GROUP BY institution_type_id, author_id, ar
      ) institution_types_distinct_author_distinct_ar_participations
      GROUP BY institution_type_id, author_id
    ) institution_types_distinct_author_ar_participations
    GROUP BY institution_type_id, total_ar_participations
  ) institution_types_total_participations,
  institution_types
WHERE institution_types.id = institution_type_id
ORDER BY total_ar_participations, total_authors DESC, institution_types.name
;
