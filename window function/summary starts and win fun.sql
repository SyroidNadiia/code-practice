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
