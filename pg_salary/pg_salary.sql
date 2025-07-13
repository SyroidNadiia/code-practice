SELECT 
	year
	, exp_level AS level
	, emp_type AS type
FROM salaries
WHERE 
	year != 2022
	AND exp_level = 'SE'
ORDER BY year ASC
LIMIT 20;




SELECT 
	year
	, job_title
	, salary_in_usd
FROM salaries
WHERE 
	year = 2023
	AND job_title = 'Data Scientist'
ORDER BY  salary_in_usd DESC
LIMIT 5;








SELECT 
	COUNT(*) 			AS cnt_all
	, COUNT(exp_level) 	AS cnt_level
	, COUNT(DISTINCT exp_level)
FROM salaries
LIMIT 10;
	



SELECT 
	AVG(salary_in_usd) AS salary_avg
	, MIN(salary_in_usd) AS salary_min
	, MAX(salary_in_usd) AS salary_max
FROM salaries
WHERE year = 2023
LIMIT 10;
	


SELECT 
	year
	, exp_level
	, salary_in_usd
	, salary_in_usd * 41 	AS salary_in_uah

	, CASE 
		WHEN exp_level = 'SE'
		THEN 'Senior'
		WHEN exp_level = 'MI'
		THEN 'Middle'
		ELSE 'Other' END AS full_level
FROM salaries
LIMIT 10;









SELECT salary_in_usd AS salary
	, year
	, job_title
FROM salaries
WHERE 
	job_title = 'ML Engineer'
	AND year = 2023
ORDER BY salary_in_usd ASC
LIMIT 10;










SELECT 
	comp_location
	, salary_in_usd
	, job_title
	, year
FROM salaries
WHERE 
	job_title = 'Data Scientist'
	AND year = 2023
ORDER BY salary_in_usd ASC
LIMIT 1;














SELECT 
	year
	, exp_level
	, job_title
	, salary_in_usd
	, remote_ratio
FROM salaries
WHERE remote_ratio = 100
ORDER BY salary_in_usd DESC
LIMIT 5;












SELECT DISTINCT comp_location
FROM salaries;










SELECT COUNT(DISTINCT comp_location)
FROM salaries;












SELECT 
	ROUND(AVG(salary_in_usd), 2) 	AS avg_sal
	, MIN(salary_in_usd) 			AS min_sal
	, MAX(salary_in_usd) 			AS max_sal
FROM salaries
WHERE year = 2023;







SELECT 
	year
	, job_title
	, salary_in_usd
	, salary_in_usd * 41 AS salary_in_uah
FROM salaries
WHERE 
	year = 2023
	AND job_title = 'ML Engineer'
ORDER BY salary_in_uah DESC
LIMIT 5;










SELECT 
	DISTINCT remote_ratio
	, CASE 
	WHEN remote_ratio = 50
	THEN 0.50
	WHEN remote_ratio = 100
	THEN 1.00
	ELSE 0 END
FROM salaries
LIMIT 10;





SELECT 
	DISTINCT ROUND((remote_ratio/100.0), 2) AS remote_frac
FROM salaries;










SELECT *
	, CASE 
	WHEN exp_level = 'EX'
	THEN 'Entry-level'
	WHEN exp_level = 'MI'
	THEN 'Mid-level'
	WHEN exp_level = 'SE'
	THEN 'Senior-level'
	ELSE 'Executive-level' END 		AS exp_level_full
FROM salaries
LIMIT 10;








SELECT COUNT(*)
FROM salaries;



SELECT COUNT(*) - COUNT(salary_in_usd)
FROM salaries;





SELECT *
FROM salaries
LIMIT 10;




SELECT 
	job_title
	, exp_level
	, COUNT(*) 							AS job_nmb
	, ROUND(AVG(salary_in_usd), 2)     AS salary_avg
FROM salaries
GROUP BY job_title, exp_level
ORDER BY 1, 2;






SELECT 
	job_title
	, COUNT(*) 							AS job_nmb
	, ROUND(AVG(salary_in_usd), 2)     AS salary_avg
FROM salaries
WHERE year = 2023
GROUP BY job_title
HAVING COUNT(*) = 1
ORDER BY job_nmb ASC;





SELECT *
FROM salaries
-- WHERE salary_in_usd > AVG(salary_in_usd);

-- порівняння з avg_salary
WHERE salary_in_usd > 
(
	SELECT ROUND(AVG(salary_in_usd), 2)
	FROM salaries
	WHERE year = 2023
)
	AND year = 2023;




SELECT ROUND(AVG(salary_in_usd), 2)
FROM salaries;







SELECT 
	comp_location
	, MAX(salary_in_usd) AS max_sal
FROM salaries
GROUP BY 1
ORDER BY max_sal ASC
LIMIT 1;

-- 6304




SELECT 
	comp_location
	, MAX(salary_in_usd) AS max_sal
FROM salaries
GROUP BY 1;




SELECT MIN(t.max_sal)
FROM (
SELECT 
	comp_location
	, MAX(salary_in_usd) AS max_sal
FROM salaries
GROUP BY 1
) AS t;

-- 6304



SELECT *
FROM (
	SELECT *
	FROM salaries
	ORDER BY salary_in_usd DESC
	LIMIT 2
) AS t
ORDER BY salary_in_usd ASC
LIMIT 1;








SELECT *
FROM salaries
ORDER BY salary_in_usd DESC
LIMIT 1 OFFSET 1


