-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. NULL Values or Blank Values 
-- 4. Remove Any Columns

-- Creating a Copy of the Original Table --

SELECT 
	*
FROM 
	layoffs;


CREATE TABLE 
	layoffs_staging
LIKE 
	layoffs;


INSERT INTO
	layoffs_staging
SELECT 
	*
FROM 
	layoffs;


-- 1. Removing Duplicates --

-- Checking for Duplicates --

-- Add row numbers to identify duplicates --
SELECT 
	*,
ROW_NUMBER() OVER
(
PARTITION BY 
	company, 
	location, 
    industry, 
    total_laid_off, 
    percentage_laid_off, 
    `date`, 
    stage, 
    country, 
    funds_raised_millions
) AS row_num
FROM 
	layoffs_staging;
    
    
-- Create a CTE to select duplicates based on row numbers --
WITH duplicate_cte AS
(
SELECT 
	*,
ROW_NUMBER() OVER
(
PARTITION BY 
	company, 
    location, 
    industry, 
    total_laid_off, 
    percentage_laid_off, 
    `date`, 
    stage, 
    country, 
    funds_raised_millions
) AS row_num
FROM 
	layoffs_staging)
SELECT 
	*
FROM 
	duplicate_cte
WHERE 
	row_num > 1;


-- Creating a New Table with row_num Column --

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO 
	layoffs_staging2
SELECT 
	*,
ROW_NUMBER() OVER
(
PARTITION BY 
	company,
    location, 
    industry, 
    total_laid_off, 
    percentage_laid_off, 
    `date`, 
    stage, 
    country, 
    funds_raised_millions
) AS row_num
FROM 
	layoffs_staging;
    
-- Delete Duplicates --
SELECT 
	*
FROM 
	layoffs_staging2
WHERE 
	row_num > 1;


DELETE 
FROM 
	layoffs_staging2
WHERE 
	row_num > 1;


-- Standardizing the Data --

-- Trim Leading and Trailing Spaces from Company Names --
SELECT 
	company, 
    TRIM(company)
FROM 
	layoffs_staging2;


UPDATE 
	layoffs_staging2
SET 
	company = TRIM(company);

-- Standardize Industry Values --
SELECT 
	*
FROM 
	layoffs_staging2
WHERE 
	industry LIKE 'Crypto%';


UPDATE 
	layoffs_staging2
SET 
	industry = 'Crypto'
WHERE 
	industry LIKE 'Crypto%';

-- Select distinct location values that need standardization --
SELECT 
	DISTINCT location
FROM 
	layoffs_staging2
WHERE 
	location LIKE 'Malm%';


UPDATE 
	layoffs_staging2
SET 
	location = REPLACE(location, 'Ăö', 'o');


UPDATE 
	layoffs_staging2
SET 
	location = REPLACE(location, 'ĂĽ', 'u');
    
-- Select distinct country values that need standardization --
SELECT 
	DISTINCT country 
FROM 
	layoffs_staging2
WHERE 
	country LIKE 'United States%'
ORDER BY 
	1;


SELECT 
	DISTINCT country,
    TRIM( TRAILING '.' FROM country)
FROM 
	layoffs_staging2
ORDER BY 
	1;
    

UPDATE 
	layoffs_staging2
SET 
	country = TRIM( TRAILING '.' FROM country)
WHERE 
	country LIKE 'United States%';
    
-- Converting and Standardizing Date Format --
SELECT 
	`date`,
	STR_TO_DATE(`date`, '%m/%d/%Y') AS converted_date
FROM 
	layoffs_staging2;

UPDATE 
	layoffs_staging2
SET 
	`date` = STR_TO_DATE(`date`, '%m/%d/%Y')

ALTER TABLE 
	layoffs_staging2
MODIFY COLUMN 
	`date` DATE;

-- 3. Null/Blank Values --

-- Identify Rows with Null Values in total_laid_off and percentage_laid_off--
SELECT 
	*
FROM 
	layoffs_staging2
WHERE 
	total_laid_off IS NULL
AND 
	percentage_laid_off IS NULL;
    
-- Identify Rows with Null or Blank Values in industry -- 
SELECT 
	*
FROM 
	layoffs_staging2
WHERE 
	industry IS NULL 
OR 
	industry = '';
    

UPDATE 
	layoffs_staging2
SET 
	industry = NULL
WHERE 
	industry = ''; 
    
-- This query finds companies with NULL industry in t1 and a non-NULL industry in t2 --
SELECT 
	t1.industry, 
	t2.industry
FROM 
	layoffs_staging2 t1
JOIN 
	layoffs_staging2 t2
ON 
    t1.company = t2.company
WHERE 
	t1.industry IS NULL
AND 
	t2.industry IS NOT NULL;
		
 -- This updates the industry in t1 where it is NULL, using the non-NULL value from t2 --       
UPDATE 
	layoffs_staging2 t1
JOIN 
	layoffs_staging2 t2
ON 
	t1.company = t2.company
SET 
	t1.industry = t2.industry
WHERE 
	t1.industry IS NULL
AND 
	t2.industry IS NOT NULL;

-- Identify Rows with NULL Values in total_laid_off and percentage_laid_off --
SELECT 
	*
FROM 
	layoffs_staging2
WHERE 
	total_laid_off IS NULL
AND 
	percentage_laid_off IS NULL;

--  Delete Rows with NULL Values in total_laid_off and percentage_laid_off --
DELETE 
FROM 
	layoffs_staging2
WHERE 
	total_laid_off IS NULL
AND 
	percentage_laid_off IS NULL;

-- 4. Removing Unnceccessary Columns --

ALTER TABLE 
	layoffs_staging2
DROP COLUMN 
	row_num;






























