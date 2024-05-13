
WITH ranked_teams AS (
    SELECT position, team,
           ROW_NUMBER() OVER (ORDER BY position) AS rank_asc,
           ROW_NUMBER() OVER (ORDER BY position DESC) AS rank_desc
    FROM league
)
SELECT CONCAT('Podium: ', team) AS name
FROM ranked_teams
WHERE rank_asc <= 3

UNION ALL

SELECT CONCAT('Demoted: ', team) AS name
FROM ranked_teams
WHERE rank_desc <= 2;
