-- Clean up with CTEs
-- In chapter 2, you generated a list of countries and the number of matches in each country with more than 10 total goals. The query in that exercise utilized a subquery in the FROM statement in order to filter the matches before counting them in the main query. Below is the query you created:

-- SELECT
--   c.name AS country,
--   COUNT(sub.id) AS matches
-- FROM country AS c
-- INNER JOIN (
--   SELECT country_id, id 
--   FROM match
--   WHERE (home_goal + away_goal) >= 10) AS sub
-- ON c.id = sub.country_id
-- GROUP BY country;
-- You can list one (or more) subqueries as common table expressions (CTEs) by declaring them ahead of your main query, which is an excellent tool for organizing information and placing it in a logical order.

-- In this exercise, let's rewrite a similar query using a CTE.

-- Complete the syntax to declare your CTE.
-- Select the country_id and match id from the match table in your CTE.
-- Left join the CTE to the league table using country_id.

-- Set up your CTE
WITH match_list AS (
    SELECT 
  		country_id, 
  		id
    FROM match
    WHERE (home_goal + away_goal) >= 10)
-- Select league and count of matches from the CTE
SELECT
    l.name AS league,
    COUNT(match_list.id) AS matches
FROM league AS l
-- Join the CTE to the league table
LEFT JOIN match_list ON l.id = match_list.country_id
GROUP BY l.name;

-- Declare your CTE, where you create a list of all matches with the league name.
-- Select the league, date, home, and away goals from the CTE.
-- Filter the main query for matches with 10 or more goals.

-- Set up your CTE
WITH match_list AS (
  -- Select the league, date, home, and away goals
    SELECT 
  		l.name AS league, 
     	m.date, 
  		m.home_goal, 
  		m.away_goal,
       (m.home_goal + m.away_goal) AS total_goals
    FROM match AS m
    LEFT JOIN league as l ON m.country_id = l.id)
-- Select the league, date, home, and away goals from the CTE
SELECT league, date, home_goal, away_goal
FROM match_list
-- Filter by total goals
WHERE total_goals >= 10;

-- Declare a CTE that calculates the total goals from matches in August of the 2013/2014 season.
-- Left join the CTE onto the league table using country_id from the match_list CTE.
-- Filter the list on the inner subquery to only select matches in August of the 2013/2014 season.

-- Set up your CTE
WITH match_list AS (
    SELECT 
  		country_id,
  	   (home_goal + away_goal) AS goals
    FROM match
  	-- Create a list of match IDs to filter data in the CTE
    WHERE id IN (
       SELECT id
       FROM match
       WHERE season = '2013/2014' AND EXTRACT(MONTH FROM date) = 08))
-- Select the league name and average of goals in the CTE
SELECT 
	name,
    AVG(match_list.goals)
FROM league AS l
-- Join the CTE onto the league table
LEFT JOIN match_list ON l.id = match_list.country_id
GROUP BY l.name;