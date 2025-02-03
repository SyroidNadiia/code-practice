-- Concatenate the first_name and last_name columns separated by a single space followed by email surrounded by < and >.

-- Concatenate the first_name and last_name and email 
SELECT first_name || ' ' || last_name || ' <' || email || '>' AS full_email 
FROM customer
-- Concatenate the first_name and last_name and email
SELECT CONCAT(first_name, ' ', last_name,  '<', email, '>') AS full_email 
FROM customer

-- Convert the film category name to uppercase.
-- Convert the first letter of each word in the film's title to upper case.
-- Concatenate the converted category name and film title separated by a colon.
-- Convert the description column to lowercase.

SELECT 
  -- Concatenate the category name to coverted to uppercase
  -- to the film title converted to title case
  UPPER(c.name)  || ': ' || INITCAP(f.title) AS film_category, 
  -- Convert the description column to lowercase
  LOWER(f.description) AS description
FROM 
  film AS f 
  INNER JOIN film_category AS fc 
  	ON f.film_id = fc.film_id 
  INNER JOIN category AS c 
  	ON fc.category_id = c.category_id;

-- Replace all whitespace with an underscore.
SELECT 
  -- Replace whitespace in the film title with an underscore
  REPLACE(title, ' ', '_') AS title
FROM film; 

-- Determining the length of strings
-- Select the title and description columns from the film table.
-- Find the number of characters in the description column with the alias desc_len.

SELECT 
  -- Select the title and description columns
  title,
  description,
  -- Determine the length of the description column
  LENGTH(description) AS desc_len
FROM film;

-- Select the first 50 characters of the description column with the alias short_desc
SELECT 
  -- Select the first 50 characters of description
  LEFT(description, 50) AS short_desc
FROM 
  film AS f; 



