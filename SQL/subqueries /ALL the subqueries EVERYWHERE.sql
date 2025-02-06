-- ALL the subqueries EVERYWHERE
-- In soccer leagues, games are played at different stages. Winning teams progress from one stage to the next, until they reach the final stage. In each stage, the stakes become higher than the previous one. The match table includes data about the different stages that each match took place in.

-- In this lesson, you will build a final query across 3 exercises that will contain three subqueries -- one in the SELECT clause, one in the FROM clause, and one in the WHERE clause. In the final exercise, your query will extract data examining the average goals scored in each stage of a match. Does the average number of goals scored change as the stakes get higher from one stage to the next?

-- Extract the average number of home and away team goals in two SELECT subqueries.
-- Calculate the average home and away goals for the specific stage in the main query.
-- Filter both subqueries and the main query so that only data from the 2012/2013 season is included.
-- Group the query by the m.stage column.

SELECT 
	-- Select the stage and average goals for each stage
	m.stage,
    ROUND(AVG(m.home_goal + m.away_goal),2) AS avg_goals,
    -- Select the average overall goals for the 2012/2013 season
    ROUND((SELECT AVG(home_goal + away_goal) 
           FROM match 
           WHERE season = '2012/2013'),2) AS overall
FROM match AS m
-- Filter for the 2012/2013 season
WHERE season = '2012/2013'
-- Group by stage
GROUP BY m.stage;

-- Calculate the average home goals and average away goals from the match table for each stage in the FROM clause subquery.
-- Add a subquery to the WHERE clause that calculates the overall average home goals.
-- Filter the main query for stages where the average home goals is higher than the overall average.
-- Select the stage and avg_goals columns from the s subquery into the main query.

SELECT 
	-- Select the stage and average goals from the subquery
	stage,
	ROUND(s.avg_goals, 2) AS avg_goals
FROM 
	-- Select the stage and average goals in 2012/2013
	(SELECT
		stage,
         AVG(home_goal + away_goal) AS avg_goals
	 FROM match
	 WHERE season = '2012/2013'
	 GROUP BY stage) AS s
WHERE 
	-- Filter the main query using the subquery
	s.avg_goals > (SELECT AVG(home_goal + away_goal) 
                    FROM match WHERE season = '2012/2013');


-- Create a subquery in SELECT that yields the average goals scored in the 2012/2013 season. Name the new column overall_avg.
-- Create a subquery in FROM that calculates the average goals scored in each stage during the 2012/2013 season.
-- Filter the main query for stages where the average goals exceeds the overall average in 2012/2013.

SELECT 
	-- Select the stage and average goals from s
	stage,
    ROUND(s.avg_goals, 2) AS avg_goal,
    -- Select the overall average for 2012/2013
    (SELECT AVG(home_goal + away_goal) FROM match WHERE season = '2012/2013') AS overall_avg
FROM 
	-- Select the stage and average goals in 2012/2013 from match
	(SELECT
		 stage,
         AVG(home_goal + away_goal) AS avg_goals
	 FROM match
	 WHERE season = '2012/2013'
	 GROUP BY stage) AS s
WHERE 
	-- Filter the main query using the subquery
	s.avg_goals > (SELECT AVG(home_goal + away_goal) 
                    FROM match WHERE season = '2012/2013');