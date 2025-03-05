-- First, using the tag_type table, count the number of tags with each type.
-- Order the results to find the most common tag type.
-- Count the number of tags with each type
SELECT type, COUNT(*) AS count
  FROM tag_type
 -- To get the count for each type, what do you need to do?
 GROUP BY type
 -- Order the results with the most common tag types listed first
 ORDER BY count DESC;

-- Join the tag_company, company, and tag_type tables, keeping only mutually occurring records.
-- Select company.name, tag_type.tag, and tag_type.type for tags with the most common type from the previous step.
-- Select the 3 columns desired
-- Select the 3 columns desired
SELECT name, tag_type.tag, tag_type.type
  FROM company
  	   -- Join the tag_company and company tables
       INNER JOIN tag_company 
       ON company.id = tag_company.company_id
       -- Join the tag_type and company tables
       INNER JOIN tag_type
       ON tag_company.tag = tag_type.tag
  -- Filter to most common type
  WHERE type='cloud';