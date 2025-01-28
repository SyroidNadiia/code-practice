-- Create a query that left joins team to match in order to get the identity of the home team. This becomes the subquery in the next step.

SELECT 
	m.id, 
    t.team_long_name AS hometeam
-- Left join team to match
FROM match AS m
LEFT JOIN team as t
ON m.hometeam_id = team_api_id;

-- Add a second subquery to the FROM statement to get the away team name, changing only the hometeam_id. Left join both subqueries to the match table on the id column.

SELECT
	m.date,
    -- Get the home and away team names
    home.hometeam,
    away.awayteam,
    m.home_goal,
    m.away_goal
FROM match AS m

-- Join the home subquery to the match table
LEFT JOIN (
  SELECT match.id, team.team_long_name AS hometeam
  FROM match
  LEFT JOIN team
  ON match.hometeam_id = team.team_api_id) AS home
ON home.id = m.id

-- Join the away subquery to the match table
LEFT JOIN (
  SELECT match.id, team.team_long_name AS awayteam
  FROM match
  LEFT JOIN team
  -- Get the away team ID in the subquery
  ON match.awayteam_id = team.team_api_id) AS away
ON away.id = m.id;


-- Get team names with correlated subqueries
-- Using a correlated subquery in the SELECT statement, match the team_api_id column from team to the hometeam_id from match.

SELECT
    m.date,
   (SELECT team_long_name
    FROM team AS t
    -- Connect the team to the match table
    WHERE m.hometeam_id = t.team_api_id) AS hometeam
FROM match AS m;


-- Create a second correlated subquery in SELECT, yielding the away team's name.
-- Select the home and away goal columns from match in the main query.

SELECT
    m.date,
    (SELECT team_long_name
     FROM team AS t
     WHERE t.team_api_id = m.hometeam_id) AS hometeam,
    -- Connect the team to the match table
    (SELECT team_long_name
     FROM team AS t
     WHERE m.awayteam_id = t.team_api_id) AS awayteam,
    -- Select home and away goals
     m.home_goal,
     m.away_goal
FROM match AS m;


-- Select id from match and team_long_name from team. Join these two tables together on hometeam_id in match and team_api_id in team.

SELECT 
	-- Select match id and team long name
    m.id, 
    t.team_long_name AS hometeam
FROM match AS m
-- Join team to match using team_api_id and hometeam_id
LEFT JOIN team AS t 
ON m.hometeam_id = t.team_api_id;

-- Declare the query from the previous step as a common table expression. SELECT everything from the CTE into the main query. Your results will not change at this step!

-- Declare the home CTE
WITH home AS (
	SELECT m.id, t.team_long_name AS hometeam
	FROM match AS m
	LEFT JOIN team AS t 
	ON m.hometeam_id = t.team_api_id)
-- Select everything from home
SELECT *
FROM home;

-- Let's declare the second CTE, away. Join it to the first CTE on the id column.
-- The date, home_goal, and away_goal columns have been added to the CTEs. SELECT them into the main query.

WITH home AS (
  SELECT m.id, m.date, 
  		 t.team_long_name AS hometeam, m.home_goal
  FROM match AS m
  LEFT JOIN team AS t 
  ON m.hometeam_id = t.team_api_id),
-- Declare and set up the away CTE
away AS (
  SELECT m.id, m.date, 
  		 t.team_long_name AS awayteam, m.away_goal
  FROM match AS m
  LEFT JOIN team AS t 
  ON m.awayteam_id = t.team_api_id)
-- Select date, home_goal, and away_goal
SELECT 
	home.date,
    home.hometeam,
    away.awayteam,
    home.home_goal,
    away.away_goal
-- Join away and home on the id column
FROM home
INNER JOIN away
ON home.id = away.id;