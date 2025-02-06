-- Nested simple subqueries
-- Nested subqueries can be either simple or correlated.

-- Just like an unnested subquery, a nested subquery's components can be executed independently of the outer query, while a correlated subquery requires both the outer and inner subquery to run and produce results.

-- In this exercise, you will practice creating a nested subquery to examine the highest total number of goals in each season, overall, and during July across all seasons.

-- Complete the main query to select the season and the max total goals in a match for each season. Name this max_goals.
-- Complete the first simple subquery to select the max total goals in a match across all seasons. Name this overall_max_goals.
-- Complete the nested subquery to select the maximum total goals in a match played in July across all seasons.
-- Select the maximum total goals in the outer subquery. Name this entire subquery july_max_goals.

SELECT
	-- Select the season and max goals scored in a match
	season,
    MAX(home_goal + away_goal) AS max_goals,
    -- Select the overall max goals scored in a match
   (SELECT MAX(home_goal + away_goal) FROM match) AS overall_max_goals,
   -- Select the max number of goals scored in any match in July
   (SELECT MAX(home_goal + away_goal) 
    FROM match
    WHERE id IN (
          SELECT id FROM match WHERE EXTRACT(MONTH FROM date) = 07)) AS july_max_goals
FROM match
GROUP BY season;


-- Generate a list of matches where at least one team scored 5 or more goals.

-- Select matches where a team scored 5+ goals
SELECT
	country_id,
    season,
	id
FROM match
WHERE home_goal >=5 OR away_goal >=5;

-- Complete the main query to select the season and the max total goals in a match for each season. Name this max_goals.
-- Complete the first simple subquery to select the max total goals in a match across all seasons. Name this overall_max_goals.
-- Complete the nested subquery to select the maximum total goals in a match played in July across all seasons.
-- Select the maximum total goals in the outer subquery. Name this entire subquery july_max_goals.

SELECT
	-- Select the season and max goals scored in a match
	season,
    MAX(home_goal + away_goal) AS max_goals,
    -- Select the overall max goals scored in a match
   (SELECT MAX(home_goal + away_goal) FROM match) AS overall_max_goals,
   -- Select the max number of goals scored in any match in July
   (SELECT MAX(home_goal + away_goal) 
    FROM match
    WHERE id IN (
          SELECT id FROM match WHERE EXTRACT(MONTH FROM date) = 07)) AS july_max_goals
FROM match
GROUP BY season;

-- Finally, declare the same query from step 2 as a subquery in FROM with the alias outer_s.
-- Left join it to the country table using the outer query's country_id column.
-- Calculate an AVG of high scoring matches per country in the main query.

SELECT
	c.name AS country,
    -- Calculate the average matches per season
	AVG(outer_s.matches) AS avg_seasonal_high_scores
FROM country AS c
-- Left join outer_s to country
LEFT JOIN (
  SELECT country_id, season,
         COUNT(id) AS matches
  FROM (
    SELECT country_id, season, id
	FROM match
	WHERE home_goal >= 5 OR away_goal >= 5) AS inner_s
  -- Close parentheses and alias the subquery
  GROUP BY country_id, season) AS outer_s
ON c.id = outer_s.country_id
GROUP BY country;