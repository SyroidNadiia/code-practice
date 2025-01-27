-- Add a subquery to the SELECT clause
-- Subqueries in SELECT statements generate a single value that allow you to pass an aggregate value down a data frame. This is useful for performing calculations on data within your database.

-- In the following exercise, you will construct a query that calculates the average number of goals per match in each country's league.

-- In the subquery, select the average total goals by adding home_goal and away_goal.
-- Filter the results so that only the average of goals in the 2013/2014 season is calculated.
-- In the main query, select the average total goals by adding home_goal and away_goal. This calculates the average goals for each league.
-- Filter the results in the main query the same way you filtered the subquery. Group the query by the league name.

SELECT 
	l.name AS league,
    -- Select and round the league's total goals
    ROUND(AVG(home_goal + m.away_goal), 2) AS avg_goals,
    -- Select & round the average total goals for the season
    (SELECT ROUND(AVG(home_goal + away_goal), 2) 
     FROM match
     WHERE season = '2013/2014') AS overall_avg
FROM league AS l
LEFT JOIN match AS m
ON l.country_id = m.country_id
-- Filter for the 2013/2014 season
WHERE season = '2013/2014'
GROUP BY l.name;


-- Select the average goals scored in a match for each league in the main query.
-- Select the average goals scored in a match overall for the 2013/2014 season in the subquery.
-- Subtract the subquery from the average number of goals calculated for each league.
-- Filter the main query so that only games from the 2013/2014 season are included.

SELECT
	-- Select the league name and average goals scored
	l.name AS league,
	ROUND(AVG(m.home_goal + m.away_goal),2) AS avg_goals,
    -- Subtract the overall average from the league average
	ROUND(AVG(m.home_goal + m.away_goal) - 
		(SELECT AVG(home_goal + away_goal)
		 FROM match 
         WHERE season = '2013/2014'),2) AS diff
FROM league AS l
LEFT JOIN match AS m
ON l.country_id = m.country_id
-- Only include 2013/2014 results
WHERE season = '2013/2014'
GROUP BY l.name;