-- BRIDGE AUTHORS
-- Q5. What kind of roles do the authors who participate
-- in more than one working group occupy?

-- For each author, compute:
-- * for roles of responsibility (CLA+LA+RE),
--   the ratio of participations with these roles on total participations
-- * for each role,
--   the ratio of participations with this role on total participations
--
-- together with:
-- * the number of distinct roles of participations
-- * the number of distinct working groups of participations
-- * the number of distinct assessment reports of participations
-- * the total number of participations
--
-- ordered by, using decreasing order of magnitude:
-- * distinct working groups
-- * ratio of roles of responsibility
-- * ratio of CLA, LA, RE, CA
-- * total participations
-- * distinct roles, distinct assessment reports
-- * (in alphabetical order) last name, first name

SELECT
  authors.first_name AS 'First Name',
  authors.last_name AS 'Last Name',
  distinct_working_groups.total AS 'Distinct WG',
  ratios.responsibility AS 'Responsibility Roles',
  ratios.cla AS 'CLA',
  ratios.la AS 'LA',
  ratios.re AS 'RE',
  ratios.ca AS 'CA',
  distinct_roles.total AS 'Distinct Roles',
  distinct_assessment_reports.total AS 'Distinct AR',
  ratios.total_participations AS 'Total Participations'
FROM
  authors
  JOIN
  (
    SELECT
      total_participations.author_id,
      (
        IFNULL(responsibility_roles.total,0)
        / total_participations.total
      ) AS responsibility,
      (
        IFNULL(cla_roles.total,0)
        / total_participations.total
      ) AS cla,
      (
        IFNULL(la_roles.total,0)
        / total_participations.total
      ) AS la,
      (
        IFNULL(re_roles.total,0)
        / total_participations.total
      ) AS re,
      (
        IFNULL(ca_roles.total,0)
        / total_participations.total
      ) AS ca,
      total_participations.total AS total_participations
    FROM
      (
        SELECT author_id, COUNT(*) AS total
        FROM participations
        GROUP BY author_id
      ) AS total_participations
      LEFT JOIN
      (
        SELECT author_id, COUNT(*) AS total
        FROM participations
        WHERE role IN ('CLA', 'LA', 'RE')
        GROUP BY author_id
      ) AS responsibility_roles
      ON total_participations.author_id = responsibility_roles.author_id
      LEFT JOIN
      (
        SELECT author_id, COUNT(*) AS 'total'
        FROM participations
        WHERE role = 'CLA'
        GROUP BY author_id
      ) AS cla_roles
      ON total_participations.author_id = cla_roles.author_id
      LEFT JOIN
      (
        SELECT author_id, COUNT(*) AS 'total'
        FROM participations
        WHERE role = 'LA'
        GROUP BY author_id
      ) AS la_roles
      ON total_participations.author_id = la_roles.author_id
      LEFT JOIN
      (
        SELECT author_id, COUNT(*) AS 'total'
        FROM participations
        WHERE role = 'RE'
        GROUP BY author_id
      ) AS re_roles
      ON total_participations.author_id = re_roles.author_id
      LEFT JOIN
      (
        SELECT author_id, COUNT(*) AS 'total'
        FROM participations
        WHERE role = 'CA'
        GROUP BY author_id
      ) AS ca_roles
      ON total_participations.author_id = ca_roles.author_id
  ) AS ratios
  ON authors.id = ratios.author_id
  JOIN
  (
    SELECT author_id, COUNT(DISTINCT role) AS 'total'
    FROM participations
    GROUP BY author_id
  ) AS distinct_roles
  ON authors.id = distinct_roles.author_id
  JOIN
  (
    SELECT author_id, COUNT(DISTINCT wg) AS 'total'
    FROM participations
    GROUP BY author_id
  ) AS distinct_working_groups
  ON authors.id = distinct_working_groups.author_id
  JOIN
  (
    SELECT author_id, COUNT(DISTINCT ar) AS 'total'
    FROM participations
    GROUP BY author_id
  ) AS distinct_assessment_reports
  ON authors.id = distinct_assessment_reports.author_id
ORDER BY
  distinct_working_groups.total DESC,
  ratios.responsibility DESC,
  ratios.cla DESC,
  ratios.la DESC,
  ratios.re DESC,
  ratios.ca DESC,
  ratios.total_participations DESC,
  distinct_roles.total DESC,
  distinct_assessment_reports.total DESC,
  authors.last_name,
  authors.first_name
;
