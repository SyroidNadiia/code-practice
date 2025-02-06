-- User-defined data types
-- ENUM or enumerated data types are great options to use in your database when you have a column where you want to store a fixed list of values that rarely change. Examples of when it would be appropriate to use an ENUM include days of the week and states or provinces in a country.

-- Another example can be the directions on a compass (i.e., north, south, east and west.) In this exercise, you are going to create a new ENUM data type called compass_position.

-- Create an enumerated data type, compass_position
CREATE TYPE compass_position AS ENUM (
  	-- Use the four cardinal directions
  	'North', 
  	'East',
  	'South', 
  	'West'
);

-- Verify that the new data type has been created by looking in the pg_type system table.
-- Create an enumerated data type, compass_position
CREATE TYPE compass_position AS ENUM (
  	-- Use the four cardinal directions
  	'North', 
  	'South',
  	'East', 
  	'West'
);
-- Confirm the new data type is in the pg_type system table
SELECT typname, typtype
FROM pg_type
WHERE typname='compass_position';


-- Select the column_name, data_type, udt_name.
-- Filter for the rating column in the film table.
-- Select the column name, data type and udt name columns
SELECT column_name, data_type, udt_name
FROM INFORMATION_SCHEMA.COLUMNS 
-- Filter by the rating column in the film table
WHERE table_name ='film' AND column_name='rating';

-- Select all columns from the pg_type table where the type name is equal to mpaa_rating.
SELECT *
FROM pg_type 
WHERE typname='mpaa_rating'

-- Select the film title and inventory ids
SELECT 
	f.title, 
    i.inventory_id
FROM film AS f 
	-- Join the film table to the inventory table
	INNER JOIN inventory AS i ON f.film_id=i.film_id 

-- Now filter your query to only return records where the inventory_held_by_customer() function returns a non-null value.

-- Select the film title and inventory ids
SELECT 
	f.title, 
    i.inventory_id,
    -- Determine whether the inventory is held by a customer
    inventory_held_by_customer(i.inventory_id) as held_by_cust
FROM film as f 
	INNER JOIN inventory AS i ON f.film_id=i.film_id 
WHERE
	-- Only include results where the held_by_cust is not null
    inventory_held_by_customer(i.inventory_id) IS NOT NULL

