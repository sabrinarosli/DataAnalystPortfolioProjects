/* Covid-19 Data Exploration */

--Imported two csv files (Covid Deaths & Covid Vaccinations)
--Skills used: Aggregate functions, joins, CTEs, Windows Function

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*First CSV files (Covid Deaths) */

SELECT *
FROM CovidDataCases.dbo.CovidDeaths$ 
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDataCases.dbo.CovidDeaths$
WHERE continent is not null
ORDER BY 1,2

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Looking at overall Total Cases and Total Deaths of Covid19 of all countries */

SELECT
SUM (total_cases) AS 'Total Cases', SUM (CAST(total_deaths AS BIGINT)) AS 'Total Deaths'
FROM CovidDataCases.dbo.CovidDeaths$
WHERE continent is not null

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Looking at Total Cases and Total Deaths per populations of each countries */

SELECT location, 
SUM (total_cases) AS 'Total Cases/Country', SUM (CAST(total_deaths AS INT)) AS 'Total Deaths/Country'
FROM CovidDataCases.dbo.CovidDeaths$
WHERE continent is not null
GROUP BY location
ORDER BY location ASC

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Looking at highest cases count, highest death counts and its percentages according to countries */

SELECT location, population, MAX (total_cases) AS 'Highest Cases Count', MAX (ROUND((total_cases/population)*100,2)) AS 'Highest Cases/Populations Percentage'
, MAX (CAST(total_deaths AS INT)) AS 'Highest Deaths Count', MAX (ROUND ((total_deaths/population)*100,2)) AS 'Highest Deaths/Populations Percentage'
FROM CovidDataCases.dbo.CovidDeaths$
WHERE continent is not null
GROUP BY location, population
ORDER BY 'Highest Cases/Populations Percentage' DESC, 'Highest Deaths/Populations Percentage' DESC

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Breaking down to continent */
/* Looking at percentage of Total Cases and Total Deaths per populations according to continents */

SELECT location, population, SUM (total_cases) AS 'Total Cases', SUM (CAST(total_deaths AS BIGINT)) AS 'Total Deaths'
, SUM (ROUND((total_cases/population)*100,2)) AS 'Cases/Populations Percentage', SUM (ROUND((total_deaths/population)*100,2)) AS 'Deaths/Populations Percentage'
FROM CovidDataCases.dbo.CovidDeaths$
WHERE continent IS NULL
GROUP BY location, population
ORDER BY population ASC

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Looking at highest cases count, highest death counts and its percentage according to continent */

SELECT location, population, MAX (total_cases) AS 'Highest Cases Count', MAX (ROUND((total_cases/population)*100,2)) AS 'Highest Cases/Populations Percentage'
, MAX (CAST(total_deaths AS INT)) AS 'Highest Deaths Count', MAX (ROUND ((total_deaths/population)*100,2)) AS 'Highest Deaths/Populations Percentage'
FROM CovidDataCases.dbo.CovidDeaths$
WHERE continent is null
GROUP BY location, population
ORDER BY 'Highest Cases/Populations Percentage' DESC, 'Highest Deaths/Populations Percentage' DESC

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Second CSV files (Covid Vaccinations) */
SELECT *
FROM CovidDataCases.dbo.CovidVaccinations$
ORDER BY 3,4

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Using Joins */
/* Looking at number of vaccinations received by population according to countries */

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM (CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS 'Total Vaccinations Uptodate'
FROM CovidDataCases.dbo.CovidDeaths$ AS dea
JOIN CovidDataCases.dbo.CovidVaccinations$ AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
ORDER BY 2,3

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Using CTE */
/* Looking at percentage population vaccination that at least receive one covid vaccines according to countries */

WITH PopulationsVaccinations (continent, location, date, population, new_vaccinations, [Total Vaccinations Uptodate])
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM (CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS 'Total Vaccinations Uptodate'
FROM CovidDataCases.dbo.CovidDeaths$ AS dea
JOIN CovidDataCases.dbo.CovidVaccinations$ AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
)
SELECT *, ([Total Vaccinations Uptodate]/population)*100 AS 'Percentage Population Vaccination'
FROM PopulationsVaccinations







