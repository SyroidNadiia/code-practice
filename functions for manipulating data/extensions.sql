Enabling extensions
-- Before you can use the capabilities of an extension it must be enabled. As you have previously learned, most PostgreSQL distributions come pre-bundled with many useful extensions to help extend the native features of your database. You will be working with fuzzystrmatch and pg_trgm in upcoming exercises but before you can practice using the capabilities of these extensions you will need to first make sure they are enabled in our database. In this exercise you will enable the pg_trgm extension and confirm that the fuzzystrmatch extension, which was enabled in the video, is still enabled by querying the pg_extension system table.

-- Enable the pg_trgm extension
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Now confirm that both fuzzystrmatch and pg_trgm are enabled by selecting all rows from the appropriate system table.

-- Select all rows extensions
SELECT *
FROM pg_extension;

-- Measuring similarity between two strings
-- Now that you have enabled the fuzzystrmatch and pg_trgm extensions you can begin to explore their capabilities. First, we will measure the similarity between the title and description from the film table of the Sakila database.
-- Select the title and description columns
SELECT 
  title, 
  description, 
  -- Calculate the similarity
  similarity(title, description)
FROM 
  film

-- Select the film title and film description.
-- Calculate the levenshtein distance for the film title with the string JET NEIGHBOR.

-- Select the title and description columns
SELECT  
  title, 
  description, 
  -- Calculate the levenshtein distance
  levenshtein(title, 'JET NEIGHBOR') AS distance
FROM 
  film
ORDER BY 3

-- Select the title and description columns
SELECT  
  title, 
  description 
FROM 
  film
WHERE 
  -- Match "Astounding Drama" in the description
  to_tsvector(description) @@ 
  to_tsquery('Astounding & Drama');

SELECT 
  title, 
  description, 
  -- Calculate the similarity
  similarity(description, 'Astounding Drama')
FROM 
  film 
WHERE 
  to_tsvector(description) @@ 
  to_tsquery('Astounding & Drama') 
ORDER BY 
	similarity(description, 'Astounding Drama') DESC;