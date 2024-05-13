SELECT name, (victories+defeats+draws) AS matches, victories, defeats, draws, (score_victories+score_draws) AS score
FROM teams
         LEFT JOIN
         -- Victories
         (SELECT teamHome AS team_ID, victories_Home+victories_away AS victories,
                 score_victories_home + score_victories_away AS score_victories
          FROM (
                   SELECT teams.id AS teamHome,
                          COALESCE(victoriesHome,0) AS victories_Home,
                          COALESCE(victoriesHome,0)*3 AS score_victories_home
                   FROM (
                            SELECT team_1, COUNT(*) as victoriesHome
                            FROM matches
                            WHERE team_1_goals > team_2_goals
                            GROUP BY team_1) As tb1
                            FULL OUTER JOIN teams
                                            ON teams.id = tb1.team_1) AS V1
                   INNER JOIN (
              SELECT teams.id AS team_away,
                     COALESCE(victoriesaway,0) AS victories_away,
                     COALESCE(victoriesaway,0)*3 AS score_victories_away
              FROM (
                       SELECT team_2, COUNT(*) as victoriesaway
                       FROM matches
                       WHERE team_1_goals < team_2_goals
                       GROUP BY team_2) As tb2
                       FULL OUTER JOIN teams
                                       ON teams.id = tb2.team_2) AS V2
                              ON v1.teamHome = v2.team_away) Vic
     ON teams.id = Vic.team_id
         LEFT JOIN
         -- Draws
         (SELECT teamHome AS team_ID, draws_Home+draws_away AS draws, score_draws_home + score_draws_away AS score_draws
          FROM (
                   SELECT teams.id AS teamHome,
                          COALESCE(drawsHome,0) AS draws_Home,
                          COALESCE(drawsHome,0)*1 AS score_draws_home
                   FROM (
                            SELECT team_1, COUNT(*) as drawsHome
                            FROM matches
                            WHERE team_1_goals = team_2_goals
                            GROUP BY team_1) As tb1
                            FULL OUTER JOIN teams
                                            ON teams.id = tb1.team_1) AS E1
                   INNER JOIN (
              SELECT teams.id AS team_away,
                     COALESCE(drawsaway,0) AS draws_away,
                     COALESCE(drawsaway,0)*1 AS score_draws_away
              FROM (
                       SELECT team_2, COUNT(*) as drawsaway
                       FROM matches
                       WHERE team_1_goals = team_2_goals
                       GROUP BY team_2) As tb2
                       FULL OUTER JOIN teams
                                       ON teams.id = tb2.team_2) AS E2
                              ON E1.teamHome = E2.team_away) AS Draws
     ON teams.id = Draws.team_ID
         LEFT JOIN
         -- Defeats
         (SELECT teamHome AS team_ID, defeats_Home+defeats_away AS defeats
          FROM (
                   SELECT teams.id AS teamHome,
                          COALESCE(defeatsHome,0) AS defeats_Home
                   FROM (
                            SELECT team_1, COUNT(*) as defeatsHome
                            FROM matches
                            WHERE team_1_goals < team_2_goals
                            GROUP BY team_1) As tb1
                            FULL OUTER JOIN teams
                                            ON teams.id = tb1.team_1) AS D1
                   INNER JOIN (
              SELECT teams.id AS team_away,
                     COALESCE(defeatsaway,0) AS defeats_away
              FROM (
                       SELECT team_2, COUNT(*) as defeatsaway
                       FROM matches
                       WHERE team_1_goals > team_2_goals
                       GROUP BY team_2) As tb2
                       FULL OUTER JOIN teams
                                       ON teams.id = tb2.team_2) AS D2
                              ON D1.teamHome = D2.team_away) AS Def
     ON teams.id = Def.team_ID
ORDER BY 6 DESC;
