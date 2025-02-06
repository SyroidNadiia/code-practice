Joining Subqueries in FROM
-- The match table in the European Soccer Database does not contain country or team names. You can get this information by joining it to the country table, and use this to aggregate information, such as the number of matches played in each country.

-- If you're interested in filtering data from one of these tables, you can also create a subquery from one of the tables, and then join it to an existing table in the database. A subquery in FROM is an effective way of answering detailed questions that requires filtering or transforming data before including it in your final results.

-- Your goal in this exercise is to generate a subquery using the match table, and then join that subquery to the country table to calculate information about matches with 10 or more goals in total!

-- Create the subquery to be used in the next step, which selects the country ID and match ID (id) from the match table.
-- Filter the query for matches with greater than or equal to 10 goals.

SELECT 
	-- Select the country ID and match ID
	country_id, 
    id
FROM match
-- Filter for matches with 10 or more goals in total
WHERE (home_goal + away_goal) >= 10;

-- Construct a subquery that selects only matches with 10 or more total goals.
-- Inner join the subquery onto country in the main query.
-- Select name from country and count the id column from match.

SELECT
	-- Select country name and the count match IDs
    c.name AS country_name,
    COUNT(sub.id) AS matches
FROM country AS c
-- Inner join the subquery onto country
-- Select the country id and match id columns
INNER JOIN (SELECT country_id, id 
           FROM match
           -- Filter the subquery by matches with 10+ goals
           WHERE (home_goal + away_goal) >= 10) AS sub
ON c.id = sub.country_id
GROUP BY country_name;

-- Complete the subquery inside the FROM clause. Select the country name from the country table, along with the date, the home goal, the away goal, and the total goals columns from the match table.
-- Create a column in the subquery that adds home and away goals, called total_goals. This will be used to filter the main query.
-- Select the country, date, home goals, and away goals in the main query.
-- Filter the main query for games with 10 or more total goals.

SELECT
	-- Select country, date, home, and away goals from the subquery
    subq.country,
    subq.date,
    subq.home_goal,
    subq.away_goal
FROM 
	-- Select country name, date, home_goal, away_goal, and total goals in the subquery
	(SELECT c.name AS country, 
     	    m.date, 
     		m.home_goal, 
     		m.away_goal,
           (m.home_goal + m.away_goal) AS total_goals
    FROM match AS m
    LEFT JOIN country AS c
    ON m.country_id = c.id) AS subq
-- Filter by total goals scored in the main query
WHERE total_goals >= 10;