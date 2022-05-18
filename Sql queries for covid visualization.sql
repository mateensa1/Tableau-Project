/*
Queries used for Tableau Project
*/

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%Australia%'
where continent is not null 
--Group By date
order by 1,2


--2

Select Continent, SUM(cast(new_deaths as int)) AS TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null 
GROUP BY continent
order by TotalDeathCount desc

--3

-- For Tableau load, changing NULL to 0 with Coalesce(___, 0) to prevent being read as str
--Lookup of countries with the highest case percentage
Select Location, Coalesce(Population, 0) as Population, Coalesce(MAX(total_cases), 0) as HighestInfCount, Coalesce(MAX(ROUND(total_cases/population,4)*100), 0) AS PercentPopInfected
From PortfolioProject..CovidDeaths
--Where location like '%Australia%'
Where continent IS NOT NULL
GROUP BY Location, Population
--HAVING PercentPopInfected IS NOT NULL
order by 4 DESC


--4

Select Location, Population,date, Coalesce(MAX(total_cases), 0) as HighestInfCount,  Coalesce(MAX(ROUND(total_cases/population,4)*100), 0) AS PercentPopInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent IS NOT NULL
Group by Location, Population, date
order by PercentPopInfected desc