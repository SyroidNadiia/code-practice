-- Numbering rows
-- The simplest application for window functions is numbering rows. Numbering rows allows you to easily fetch the nth row. For example, it would be very difficult to get the 35th row in any given table if you didn't have a column with each row's number.

-- Number each row in the dataset.

SELECT
  *,
  -- Assign numbers to each row
  ROW_NUMBER() OVER() AS Row_N
FROM Summer_Medals
ORDER BY Row_N ASC;

-- Assign a number to each year in which Summer Olympic games were held.

SELECT
  Year,

  -- Assign numbers to each year
  ROW_NUMBER() OVER() AS Row_N
FROM (
  SELECT DISTINCT Year
  FROM Summer_Medals
  ORDER BY Year ASC
) AS Years
ORDER BY Year ASC;


-- Assign a number to each year in which Summer Olympic games were held so that rows with the most recent years have lower row numbers.

SELECT
  Year,
  -- Assign the lowest numbers to the most recent years
  ROW_NUMBER() OVER (ORDER BY year DESC) AS Row_N
FROM (
  SELECT DISTINCT Year
  FROM Summer_Medals
) AS Years
ORDER BY Year;


-- Assign a number to each year in which Summer Olympic games were held so that rows with the most recent years have lower row numbers.

SELECT
  -- Count the number of medals each athlete has earned
  athlete,
  COUNT(medal) AS Medals
FROM Summer_Medals
GROUP BY Athlete
ORDER BY Medals DESC;

-- Having wrapped the previous query in the Athlete_Medals CTE, rank each athlete by the number of medals they've earned.

WITH Athlete_Medals AS (
  SELECT
    -- Count the number of medals each athlete has earned
    Athlete,
    COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete)

SELECT
  -- Number each athlete by how many medals they've earned
  Athlete,
  ROW_NUMBER() OVER (ORDER BY Medals DESC) AS Row_N
FROM Athlete_Medals
ORDER BY Medals DESC;

-- Return each year's gold medalists in the Men's 69KG weightlifting competition.

SELECT
  -- Return each year's champions' countries
  year,
  country AS champion
FROM Summer_Medals
WHERE
  Discipline = 'Weightlifting' AND
  Event = '69KG' AND
  Gender = 'Men' AND
  Medal = 'Gold';

-- Having wrapped the previous query in the Weightlifting_Gold CTE, get the previous year's champion for each year.

WITH Weightlifting_Gold AS (
  SELECT
    -- Return each year's champions' countries
    Year,
    Country AS champion
  FROM Summer_Medals
  WHERE
    Discipline = 'Weightlifting' AND
    Event = '69KG' AND
    Gender = 'Men' AND
    Medal = 'Gold')

SELECT
  Year, Champion,
  -- Fetch the previous year's champion
  LAG(Champion) OVER
    (ORDER BY year ASC) AS Last_Champion
FROM Weightlifting_Gold
ORDER BY Year ASC;

-- Reigning champions by gender
-- You've already fetched the previous year's champion for one event. However, if you have multiple events, genders, or other metrics as columns, you'll need to split your table into partitions to avoid having a champion from one event or gender appear as the previous champion of another event or gender.

-- Return the previous champions of each year's event by gender.

WITH Tennis_Gold AS (
  SELECT DISTINCT
    Gender, Year, Country
  FROM Summer_Medals
  WHERE
    Year >= 2000 AND
    Event = 'Javelin Throw' AND
    Medal = 'Gold')

SELECT
  Gender, Year,
  Country AS Champion,
  -- Fetch the previous year's champion by gender
  LAG(country) OVER (PARTITION BY gender
            ORDER BY year ASC) AS Last_Champion
FROM Tennis_Gold
ORDER BY Gender ASC, Year ASC;

-- Return the previous champions of each year's events by gender and event

WITH Athletics_Gold AS (
  SELECT DISTINCT
    Gender, Year, Event, Country
  FROM Summer_Medals
  WHERE
    Year >= 2000 AND
    Discipline = 'Athletics' AND
    Event IN ('100M', '10000M') AND
    Medal = 'Gold')

SELECT
  Gender, Year, Event,
  Country AS Champion,
  -- Fetch the previous year's champion by gender and event
  LAG(country) OVER (PARTITION BY gender, event
            ORDER BY Year ASC) AS Last_Champion
FROM Athletics_Gold
ORDER BY Event ASC, Gender ASC, Year ASC;

-- For each year, fetch the current gold medalist and the gold medalist 3 competitions ahead of the current row.

WITH Discus_Medalists AS (
  SELECT DISTINCT
    Year,
    Athlete
  FROM Summer_Medals
  WHERE Medal = 'Gold'
    AND Event = 'Discus Throw'
    AND Gender = 'Women'
    AND Year >= 2000)

SELECT
  -- For each year, fetch the current and future medalists
  year,
  athlete,
  LEAD(athlete, 3) OVER (ORDER BY year ASC) AS Future_Champion
FROM Discus_Medalists
ORDER BY Year ASC;

-- Return all athletes and the first athlete ordered by alphabetical order.

WITH All_Male_Medalists AS (
  SELECT DISTINCT
    Athlete
  FROM Summer_Medals
  WHERE Medal = 'Gold'
    AND Gender = 'Men')

SELECT
  -- Fetch all athletes and the first athlete alphabetically
  Athlete,
  FIRST_VALUE(athlete) OVER (
    ORDER BY athlete ASC
  ) AS First_Athlete
FROM All_Male_Medalists;

-- Last country by name
-- Just like you can get the first row's value in a dataset, you can get the last row's value. This is often useful when you want to compare the most recent value to previous values.

-- Return the year and the city in which each Olympic games were held.
-- Fetch the last city in which the Olympic games were held.

WITH Hosts AS (
  SELECT DISTINCT Year, City
    FROM Summer_Medals)

SELECT
  Year,
  City,
  -- Get the last city in which the Olympic games were held
  LAST_VALUE(city) OVER (
   ORDER BY year ASC
   RANGE BETWEEN
     UNBOUNDED PRECEDING AND
     UNBOUNDED FOLLOWING
  ) AS Last_City
FROM Hosts
ORDER BY Year ASC;

-- Ranking athletes by medals earned
-- In chapter 1, you used ROW_NUMBER to rank athletes by awarded medals. However, ROW_NUMBER assigns different numbers to athletes with the same count of awarded medals, so it's not a useful ranking function; if two athletes earned the same number of medals, they should have the same rank.

-- Rank each athlete by the number of medals they've earned -- the higher the count, the higher the rank -- with identical numbers in case of identical values.

WITH Athlete_Medals AS (
  SELECT
    Athlete,
    COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete)

SELECT
  Athlete,
  Medals,
  -- Rank athletes by the medals they've won
  RANK() OVER (ORDER BY medals DESC) AS Rank_N
FROM Athlete_Medals
ORDER BY Medals DESC;

-- Rank each country's athletes by the count of medals they've earned -- the higher the count, the higher the rank -- without skipping numbers in case of identical values.

WITH Athlete_Medals AS (
  SELECT
    Country, Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country IN ('JPN', 'KOR')
    AND Year >= 2000
  GROUP BY Country, Athlete
  HAVING COUNT(*) > 1)

SELECT
  Country,
  -- Rank athletes in each country by the medals they've won
  Athlete,
  DENSE_RANK() OVER (PARTITION BY country
                ORDER BY Medals DESC) AS Rank_N
FROM Athlete_Medals
ORDER BY Country ASC, RANK_N ASC;

-- Paging events
-- There are exactly 666 unique events in the Summer Medals Olympics dataset. If you want to chunk them up to analyze them piece by piece, you'll need to split the events into groups of approximately equal size.

-- Split the distinct events into exactly 111 groups, ordered by event in alphabetical order.

WITH Events AS (
  SELECT DISTINCT Event
  FROM Summer_Medals)
  
SELECT
  --- Split up the distinct events into 111 unique groups
  Event,
  NTILE(111) OVER (ORDER BY event ASC) AS Page
FROM Events
ORDER BY Event ASC;

-- Split the athletes into top, middle, and bottom thirds based on their count of medals.

WITH Athlete_Medals AS (
  SELECT Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete
  HAVING COUNT(*) > 1)
  
SELECT
  Athlete,
  Medals,
  -- Split athletes into thirds by their earned medals
  NTILE(3) OVER(ORDER BY medals DESC) AS Third
FROM Athlete_Medals
ORDER BY Medals DESC, Athlete ASC;

-- Return the average of each third.

WITH Athlete_Medals AS (
  SELECT Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete
  HAVING COUNT(*) > 1),
  
  Thirds AS (
  SELECT
    Athlete,
    Medals,
    NTILE(3) OVER (ORDER BY Medals DESC) AS Third
  FROM Athlete_Medals)
  
SELECT
  -- Get the average medals earned in each third
  Third,
  AVG(medals) AS Avg_Medals
FROM Thirds
GROUP BY Third
ORDER BY Third ASC;

