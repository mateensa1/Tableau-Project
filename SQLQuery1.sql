use PortfolioProject
select * from 
PortfolioProject..CovidDeaths
WHERE continent is not null
order by 3,4 


--select * from 
--PortfolioProject..CovidVaccinations
--order by 3,4 


SELECT continent, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
WHERE continent is not null
order by 1,2


--Total cases vs total deaths

SELECT continent, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
WHERE continent is not null
where location like '%Australia%'
order by 1,2


--Total cases vs Population
--percentage of people got covid
SELECT continent, date, Population, total_cases,  (total_cases/population)*100 as PercentofPopulationInfected
From PortfolioProject..CovidDeaths
where location like '%Australia%'
order by 1,2

--countries with highest infection rate compared to population

SELECT continent, Population, MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/population))*100 as PercentofPopulationInfected
From PortfolioProject..CovidDeaths
--where location like '%Australia%'
Group by continent,population
order by PercentofPopulationInfected desc

--Highest death count per population


SELECT continent, Max(cast(total_deaths as bigint)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--where location like '%Australia%'
WHERE continent is not null
Group by continent
order by TotalDeathCount desc


-- Highest death count per population by continent

SELECT continent, Max(cast(total_deaths as bigint)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--where location like '%Australia%'
WHERE continent is  null 
and continent not like '%income%'
Group by continent
order by TotalDeathCount desc


--Global Numbers



SELECT  date, SUM(new_cases) as total_case, SUM(cast(new_deaths as bigint)) as total_deaths, SUM(cast(new_deaths as bigint))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
WHERE continent is not null
--where location like '%Australia%'
Group by date
order by 1,2

--Total world cases and deaths
SELECT  SUM(new_cases) as total_case, SUM(cast(new_deaths as bigint)) as total_deaths, SUM(cast(new_deaths as bigint))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
WHERE continent is not null
--where location like '%Australia%'
--Group by date
order by 1,2

-- CovidVaccinations table


select *
From PortfolioProject..CovidDeaths dea
JOIN   PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

--Total population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


--TEMP TABLE

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into  #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


---Drop

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into  #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for visualizations


Create View use portfolioproject as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

Select * 
From portfolioproject