SELECT *
FROM CovidDataCases.dbo.CovidDeaths$ 
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDataCases.dbo.CovidDeaths$
ORDER BY 1,2

SELECT
SUM (total_cases) AS 'Total Cases', SUM (CAST(total_deaths AS BIGINT)) AS 'Total Deaths'
FROM CovidDataCases.dbo.CovidDeaths$

SELECT location, 
SUM (total_cases) AS 'Total Cases/Country', SUM (CAST(total_deaths AS INT)) AS 'Total Deaths/Country'
FROM CovidDataCases.dbo.CovidDeaths$
GROUP BY location
ORDER BY location ASC

SELECT location, date, total_cases, total_deaths, (total_deaths/ NULLIF(total_cases, 0))*100 AS 'Death Percentage'
FROM CovidDataCases.dbo.CovidDeaths$
ORDER BY 1,2

SELECT location, date, population, total_cases, (total_cases/population)*100 AS 'Cases over Populations Percentage'
FROM CovidDataCases.dbo.CovidDeaths$
ORDER BY 1,2

SELECT location, population, MAX (total_cases) AS 'Highest Cases Count', MAX ((total_cases/population))*100 AS 'Cases over Populations Percentage'
FROM CovidDataCases.dbo.CovidDeaths$
GROUP BY location, population
ORDER BY 'Cases over Populations Percentage' DESC

SELECT location, population, MAX (CAST(total_deaths AS INT)) AS 'Highest Deaths Count', MAX ((total_deaths/population))*100 AS 'Deaths over Populations Percentage'
FROM CovidDataCases.dbo.CovidDeaths$
GROUP BY location, population
ORDER BY 'Deaths over Populations Percentage' DESC

SELECT continent, MAX (total_cases) AS 'Cases by Continent', MAX (CAST(total_deaths AS INT)) AS 'Deaths by Continent'
FROM CovidDataCases.dbo.CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 'Cases by Continent' DESC

SELECT *
FROM CovidDataCases.dbo.CovidVaccinations$
ORDER BY 3,4








