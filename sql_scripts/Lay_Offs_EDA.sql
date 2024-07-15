-- DATA EXPLORATORY ANALYSIS --

-- Retrieve the maximum number of total layoffs and the maximum percentage of layoffs --
SELECT 
	MAX(total_laid_off) AS max_total_laid_off, 
	MAX(percentage_laid_off) AS max_percentage_laid_off
FROM 
	layoffs_staging2;
    
-- Retrieve all records where 100% of employees were laid off, ordered by funds raised in descending order --
SELECT 
	*
FROM 
	layoffs_staging2
WHERE 
	percentage_laid_off = 1
ORDER BY 
	funds_raised_millions DESC;
    
-- Checking the interval of lay-offs to determine the date range of recorded lay-offs --
SELECT 
	MIN(`date`) AS earliest_layoff, 
	MAX(`date`) AS latest_layoff
FROM 
	layoffs_staging2;
    
-- Retrieve the total number of layoffs per company, ordered by total layoffs in descending order --
SELECT 
	company, 
    SUM(total_laid_off) AS total_laid_off
FROM 
	layoffs_staging2
GROUP BY 
	company
ORDER BY 
	2 DESC;
    
-- Retrieve the total number of layoffs per industry, ordered by total layoffs in descending order --
SELECT 
	industry, 
    SUM(total_laid_off) AS total_laid_off
FROM 
	layoffs_staging2
GROUP BY 
	industry
ORDER BY 
	2 DESC;
    
-- Retrieve the total number of layoffs per country, ordered by total layoffs in descending order --
SELECT 
	country, 
	SUM(total_laid_off) AS total_laid_off
FROM 
	layoffs_staging2
GROUP BY 
	country
ORDER BY 
	2 DESC;

-- Retrieve the total number of layoffs per date, ordered by date in descending order --
SELECT 
	`date`, 
	SUM(total_laid_off) AS total_laid_off
FROM 
	layoffs_staging2
GROUP BY 
	`date`
ORDER BY 
	1 DESC;
    
-- Retrieve the total number of layoffs per year, ordered by year in descending order --.
SELECT 
	YEAR(`date`), 
    SUM(total_laid_off) AS total_laid_off
FROM 
	layoffs_staging2
GROUP BY 
	YEAR(`date`)
ORDER BY 
	1 DESC;

-- Retrieve the total number of layoffs per month, ordered by month in ascending order --.
SELECT 
	SUBSTRING(`date`, 1, 7) AS `Month`,
	SUM(total_laid_off) AS total_laid_off
FROM 
	layoffs_staging2
WHERE 
	SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY 
	`Month`
ORDER BY 
	1 ASC;
    
/*
    This query calculates the total number of layoffs per month
    and computes a rolling total of layoffs over time. The results
    are ordered by month in ascending order for easy analysis.
*/
WITH Rolling_Total AS
(
SELECT 
	SUBSTRING(`date`, 1, 7) AS `Month`,
	SUM(total_laid_off) AS total_off
FROM 
	layoffs_staging2
WHERE 
	SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY 
	`Month`
ORDER BY
	1 ASC
)
SELECT 
	`Month`, 
    total_off,
    SUM(total_off) OVER(ORDER BY `Month`) AS rolling_total
FROM 
	Rolling_Total;
    
-- Retrieve total layoffs per company for each year, ordered by total layoffs in descending order --
SELECT 
	company, 
    YEAR(`date`) AS , 
    SUM(total_laid_off) AS total_laid_off
FROM 
	layoffs_staging2
GROUP BY 
	company, 
    YEAR(`date`)
ORDER BY 
	3 DESC;

/*
    This query retrieves the top 5 companies with the highest number of layoffs
    for each year, using DENSE_RANK to rank companies within each year.
*/
WITH Company_Year (company, years, total_laid_off) AS
(
SELECT 
	company, 
    YEAR(`date`) AS `Year`, 
    SUM(total_laid_off) AS total_laid_off
FROM 
	layoffs_staging2
GROUP BY 
	company, 
	YEAR(`date`)
), Company_Year_Rank AS
( -- Assign a dense rank to companies based on total layoffs per year --
SELECT 
	*, 
	DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM 
	Company_Year
WHERE 
	years IS NOT NULL
) -- Select the top 5 ranked companies per year --
SELECT 
	*
FROM 
	Company_Year_Rank
WHERE 
	Ranking <= 5 ;