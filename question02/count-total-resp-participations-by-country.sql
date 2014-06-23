-- AUTHORS WITH MULTIPLE PARTICIPATIONS
-- Q2. Who are the authors that have participated
--     in more than 1, 2, 3, or 4 assessment reports
--     while holding at least 1 of the 3 elected roles in the IPCC
--     in each assessment report of participation
--     (Coordinating Lead Author, Lead Author, Review Editor)?

USE giec

-- RESP = authors with a role of responsibility (LA, CLA or RE)
--        in EVERY assessment report of participation

-- IN EACH COUNTRY
-- count the RESP authors who contributed to:
-- * 1 assessment reports
-- * 2 assessment reports
-- * 3 assessment reports
-- * 4 assessment reports
-- * 5 assessment reports

SELECT
  total_ar_participations AS 'Total AR',
  COUNT(author_id) AS 'Total Authors',
  countries.name AS 'Country'
FROM
  (
    SELECT
      country_id,
      author_id,
      COUNT(ar) AS total_ar_participations
    FROM
    (
      SELECT country_id, author_id, ar
      FROM
        (
          SELECT author_id, ar, institution_country_id
          FROM participations
          WHERE author_id NOT IN (
            -- NOT RESP
            SELECT author_id
            FROM
            (
              SELECT author_id, ar
              FROM
              (
                SELECT author_id, ar
                FROM participations
                GROUP BY author_id, ar
              ) distinct_ar_participations
              WHERE NOT EXISTS (
                SELECT role
                FROM participations
                WHERE distinct_ar_participations.author_id = participations.author_id
                AND distinct_ar_participations.ar = participations.ar
                AND participations.role <> 'CA'
              )
            ) not_resp_distinct_ar_participations
            GROUP BY author_id
          ) -- not_resp
          GROUP BY author_id, ar
        ) resp_distinct_ar_participations,
        institution_countries
      WHERE
        resp_distinct_ar_participations.institution_country_id =
          institution_countries.id
      GROUP BY country_id, author_id, ar
    ) countries_distinct_author_distinct_ar_participations
    GROUP BY country_id, author_id
  ) countries_distinct_author_ar_participations,
  countries
WHERE
  country_id = countries.id
GROUP BY country_id, total_ar_participations
ORDER BY countries.name, total_ar_participations
;
