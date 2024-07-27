# Layoffs Data Analysis

## Project Description

This project contains the analysis of layoff data from various companies, industries, and countries from March 11, 2020, to March 6, 2023 conducted in MySQL. The project includes data cleaning and exploratory data analysis (EDA) to reveal trends and insights related to layoffs.

To find the sql sql_scripts please navigate to `layoffs-analysis
/sql_scripts`.

## Data Cleaning

Several data cleaning steps were needed to ensure the dataset was accurate and ready for analysis:

#### Creating Staging Table: 

A staging table was created to hold the initial raw data before any changes were applied.

#### Removing Duplicates: 

Duplicates were identified and removed by adding row numbers to records, as the original dataset lacked a unique identifier (primary key) for each record.

#### Standardizing Data: 

Data was standardized by trimming leading and trailing spaces, fixing typos, and converting date formats from string to date.

#### Handling Blank Values: 

Some blank values were updated to NULL and then filled with appropriate values, while others were deleted from the dataset.

#### Removing Unnecessary Columns: 

Columns that were not required for analysis were removed. Specifically, the row number column, which was used to identify and remove duplicates, was deleted as it is not important for the analysis and it takes up storage.

## Exploratory Data Analysis (EDA)

The EDA aimed to uncover key insights and trends in the layoff data. The following analyses were performed:

#### Total Layoffs per Company: 

Calculated the total number of layoffs for each company.

#### Total Layoffs per Industry: 

Calculated the total number of layoffs for each industry.

#### Total Layoffs per Country: 

Calculated the total number of layoffs for each country.

#### Total Layoffs by Date, Year, and Month: 

Analyzed layoffs over different time periods.

#### Rolling Total Layoffs per Month: 

Calculated the rolling total of layoffs over time.

#### Top 5 Companies with Highest Layoffs per Year: 

Ranked companies by total layoffs each year and identified the top 5 companies with the highest layoffs.
