-- 1. What is the total job opening?
SELECT 
	COUNT(job_title) AS total_job_vacancy
FROM data_analyst
WHERE job_title IS NOT NULL;

-- 2. How many Company are recruiting?
SELECT 
	COUNT(DISTINCT company_name) AS total_company_recruiting
FROM data_analyst
WHERE company_name IS NOT NULL;

-- 3. What is average overall rating?
SELECT 
	CAST(AVG(rating) AS DECIMAL (5,2)) AS avg_rating
FROM data_analyst
WHERE rating IS NOT NULL;

-- 4. How many industry are recruiting?
SELECT 
	COUNT(DISTINCT Industry) AS total_industry
FROM data_analyst
WHERE Industry IS NOT NULL;

-- 5. How many sector are recruiting?
SELECT 
	COUNT(DISTINCT sector) AS total_sector
FROM data_analyst
WHERE sector IS NOT NULL;


-- 6.Top 10 job opening  per title
SELECT TOP 10
	job_title,
	COUNT(*) AS total_position
FROM data_analyst
WHERE job_title IS NOT NULL
GROUP BY job_title
ORDER BY total_position DESC;

-- 7. number of job opening in each industry
SELECT 
	industry,
	COUNT(*) AS total_position
FROM data_analyst
WHERE industry IS NOT NULL
GROUP BY Industry
ORDER BY total_position DESC;

-- 8. number of job opening by sector
SELECT
	sector,
	COUNT(*) AS total_position
FROM data_analyst
WHERE sector IS NOT NULL
GROUP BY sector
ORDER BY total_position DESC;

-- 9. number of job opening by state
SELECT 
	state,
	COUNT(*) AS total_position
FROM data_analyst
GROUP BY state
ORDER BY total_position DESC;

-- 10. job opening by company
SELECT TOP 20
	company_name,
	COUNT(*) AS total_position
FROM data_analyst
WHERE company_name IS NOT NULL
GROUP BY 
	company_name
ORDER BY 
	total_position DESC;


-- 11. job opening  per company_size_emp
SELECT 
	company_size_emp,
	COUNT(*) AS total_position
FROM data_analyst
WHERE company_size_emp IS NOT NULL AND company_size_emp <> 'Unknown-'
GROUP BY company_size_emp
ORDER BY total_position DESC;

-- 12. what programming skill  are most required by TOP 5 Job title

WITH CTE AS (
SELECT 
	job_title,
	CASE WHEN skill_excel = 1 THEN 1 ELSE NULL END AS excel,
	CASE WHEN skill_python = 1 THEN 1 ELSE NULL END AS python,
	CASE WHEN skill_sql = 1 THEN 1 ELSE NULL END AS sql,
	CASE WHEN skill_tableau = 1 THEN 1 ELSE NULL END AS tableau,
	CASE WHEN skill_powerbi = 1 THEN 1 ELSE NULL END AS power_bi
	
FROM (
	SELECT 
		job_title,
		skill_excel,
		skill_python,
		skill_sql,
		skill_tableau,
		skill_powerbi
	FROM data_analyst
	) skill
)
SELECT TOP 5
	job_title,
	SUM(excel) AS excel,
	SUM(python) AS python,
	SUM(sql) AS sql,
	SUM(tableau) AS tableau,
	SUM(power_bi) AS power_bi
FROM CTE 
GROUP BY job_title
ORDER BY excel DESC;


-- 13. What is the distribution of job opening by rating
SELECT
	CAST(rating AS DECIMAL (5,2)) AS rating,
	COUNT(*) AS total_position
FROM data_analyst
WHERE rating IS NOT NULL
GROUP BY CAST(rating AS DECIMAL (5,2))
ORDER BY rating ASC;

-- 14. rating distribution by sector
SELECT 
	sector,
	CAST(MIN(rating) AS DECIMAL (5,2)) AS min_rating,
	CAST(AVG(rating) AS DECIMAL (5,2))AS avg_rating,
	CAST(MAX(rating) AS DECIMAL (5,2)) AS max_rating
FROM data_analyst
WHERE sector IS NOT NULL
GROUP BY 
	sector
ORDER BY avg_rating DESC;

-- 15. rating distribution in each industry
SELECT 
	industry,
	CAST(MIN(rating) AS DECIMAL (5,2)) AS min_rating,
	CAST(AVG(rating) AS DECIMAL (5,2))AS avg_rating,
	CAST(MAX(rating) AS DECIMAL (5,2)) AS max_rating
FROM data_analyst
WHERE industry IS NOT NULL
GROUP BY Industry
ORDER BY avg_rating DESC;

-- 16.rating distribution in each state
SELECT 
	state,
	CAST(MIN(rating) AS DECIMAL (5,2)) AS min_rating,
	CAST(AVG(rating) AS DECIMAL (5,2))AS avg_rating,
	CAST(MAX(rating) AS DECIMAL (5,2)) AS max_rating
FROM data_analyst
WHERE state IS NOT NULL
GROUP BY state
ORDER BY avg_rating DESC;

-- 17. rating distribution in type of ownership
SELECT 
	type_of_ownership,
	CAST(MIN(rating) AS DECIMAL (5,2)) AS min_rating,
	CAST(AVG(rating) AS DECIMAL (5,2))AS avg_rating,
	CAST(MAX(rating) AS DECIMAL (5,2)) AS max_rating
FROM data_analyst
WHERE type_of_ownership IS NOT NULL AND type_of_ownership <> 'unknown'
GROUP BY type_of_ownership
ORDER BY avg_rating DESC;


-- 18. rating distribution  by company employee size 
SELECT 
	company_size_emp,
	CAST(MIN(rating) AS DECIMAL (5,2)) AS min_rating,
	CAST(AVG(rating) AS DECIMAL (5,2))AS avg_rating,
	CAST(MAX(rating) AS DECIMAL (5,2)) AS max_rating
FROM data_analyst
WHERE company_size_emp IS NOT NULL AND company_size_emp <> 'unknown-'
GROUP BY company_size_emp
ORDER BY avg_rating DESC;



-- 19. estimation of min_salary, avg_salary, max_salary for each industry
SELECT
	industry,
	FORMAT(AVG(min_salary_est),'0,000') AS avg_min_salary_est,
	FORMAT(AVG(avg_salary_est),'0,000') AS avg_salary_est,
	FORMAT(AVG(max_salary_est),'0,000') AS avg_max_salary_est
FROM data_analyst
WHERE Industry IS NOT NULL
GROUP BY Industry
ORDER BY avg_salary_est DESC;


-- 20. sector with the highest minimum,  the highest average, and the highest maximum salary estimation
SELECT 
	sector,
	CAST(MAX(min_salary_est) AS MONEY) AS highest_min_salary,
	CAST(MAX(avg_salary_est) AS MONEY) AS highest_avg_salary,
	CAST(MAX(max_salary_est) AS MONEY) AS highest_salary
FROM data_analyst
WHERE sector IS NOT NULL
GROUP BY 
	sector
ORDER BY 
	highest_avg_salary DESC;

-- 21.  Distribution of salary estimation by State
SELECT
	state,
	CAST(AVG(min_salary_est) AS MONEY) AS avg_min_salary_est,
	CAST(AVG(avg_salary_est) AS MONEY) AS avg_salary_est,
	CAST(AVG(max_salary_est) AS MONEY) AS avg_max_salary_est
FROM data_analyst
GROUP BY state
ORDER BY 
	avg_salary_est DESC;

-- 22. Average estimated salary distribution by  top 10 job opening 
SELECT 
	job_title,
	state,
	CAST(AVG(min_salary_est) AS MONEY) AS avg_min_est_salary,
	CAST(AVG(avg_salary_est) AS MONEY) AS avg_est_salary,
	CAST(AVG(max_salary_est) AS MONEY) AS avg_max_est_salary
FROM data_analyst
WHERE job_title IN ('Data Analyst','Sr. Data Analyst','Jr. Data Analyst','Business Data Analyst','Sr. Business Analyst',
						'Data Quality Analyst', 'Data Governance Analyst', 'Lead Data Analyst', 'Data Reporting Analyst',
						'Financial Data Analyst')
GROUP BY
	job_title,
	state
ORDER BY
	state, 
	avg_est_salary DESC,
	job_title;



