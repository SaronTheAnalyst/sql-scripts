select *
from PortfolioProject. .CovidDeaths
where continent is not null
order by 3,4

--selecting the Data that i will be using 

select Location, Date, total_cases, new_cases, total_Deaths, Population
from PortfolioProject. .CovidDeaths
where continent is not null
order by 1,2

--Looking at the Total case VS Total Deaths
--Shows Likelihood of Dying if you Contract Covid in your Country

SELECT Location, Date, total_cases, total_Deaths, (CAST(total_Deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
where continent is not null
--AND location like '%south korea%'
ORDER BY 1, 2

--Looking as the Total case VS the Population
--Shows what percentage of population got Covid

SELECT Location, Date, Population, total_cases, (CAST(total_cases AS FLOAT) / CAST(population AS FLOAT)) * 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
where continent is not null
AND location like '%south korea%'
ORDER BY 1, 2

--Looking at countries with highest Infection Rate Compared to Population

SELECT Location, Population, max(total_cases) as HighestInfectionCount, MAX((CAST(total_cases AS FLOAT) / CAST(population AS FLOAT)) * 100) AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
where continent is not null
--AND location like '%south korea%'
Group By location, population
ORDER BY PercentPopulationInfected DESC

--Showing Countries with Highest Death Count per Population

SELECT Location, max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
--AND location like '%south korea%'
Group By location
ORDER BY TotalDeathCount DESC

--Breaking things down by continent

--showing the continents with the highest deathcount per population

SELECT continent, max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
--AND location like '%south korea%'
Group By continent
ORDER BY TotalDeathCount DESC

--Global NUmbers

SELECT Date, sum(cast(new_cases as float)) as TotalCases, sum(cast(new_Deaths as float)) as TotalDeaths, sum(cast(new_Deaths as float))/sum(cast(new_cases as float))*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
where continent is not null
-- and location like '%south korea%'
Group by date
ORDER BY 1, 2

--total cases

SELECT sum(cast(new_cases as float)) as TotalCases, sum(cast(new_Deaths as float)) as TotalDeaths, sum(cast(new_Deaths as float))/sum(cast(new_cases as float))*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
where continent is not null
-- and location like '%south korea%'
ORDER BY 1, 2


--Looking at the total population VS Vaccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location
, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/dea.population)*100
from PortfolioProject. .CovidDeaths dea
 join PortfolioProject. .CovidVaccinations vac
     on dea.Location = vac.Location
     and dea.date = vac.date
where dea.continent is not null
 order by 2,3



--using CTE

with PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
 as
 (
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location
, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/dea.population)*100
from PortfolioProject. .CovidDeaths dea
 join PortfolioProject. .CovidVaccinations vac
     on dea.Location = vac.Location
     and dea.date = vac.date
where dea.continent is not null
--order by 2,3
 )
 select *, (RollingPeopleVaccinated/population)*100
 from PopvsVac




 --using temp table 

 drop table if exists #PercentPopulationVaccinated
 CREATE TABLE #PercentPopulationVaccinated (
    Continent NVARCHAR(255),
    location NVARCHAR(255),
    date datetime,
    population numeric,
	new_vaccinations numeric,
	RollingPeopleVaccinated numeric
)

 insert into #PercentPopulationVaccinated
  select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location
, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/dea.population)*100
from PortfolioProject. .CovidDeaths dea
 join PortfolioProject. .CovidVaccinations vac
     on dea.Location = vac.Location
     and dea.date = vac.date
where dea.continent is not null
--order by 2,3

 select *, (RollingPeopleVaccinated/population)*100
 from #PercentPopulationVaccinated



-- creating view to store data for later data visualaization

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location
, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/dea.population)*100
from PortfolioProject. .CovidDeaths dea
 join PortfolioProject. .CovidVaccinations vac
     on dea.Location = vac.Location
     and dea.date = vac.date
where dea.continent is not null
--order by 2,3


create view GlobalNumber as 
SELECT Date, sum(cast(new_cases as float)) as TotalCases, sum(cast(new_Deaths as float)) as TotalDeaths, sum(cast(new_Deaths as float))/sum(cast(new_cases as float))*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
where continent is not null
-- and location like '%south korea%'
Group by date
--ORDER BY 1, 2

create view HighestDeathCountPerPopulation as 
SELECT Location, max(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
--AND location like '%south korea%'
Group By location
--ORDER BY TotalDeathCount DESC

create view PercentPopulationInfected as 
SELECT Location, Population, max(total_cases) as HighestInfectionCount, MAX((CAST(total_cases AS FLOAT) / CAST(population AS FLOAT)) * 100) AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
where continent is not null
--AND location like '%south korea%'
Group By location, population
--ORDER BY PercentPopulationInfected DESC

create view DeathPercentage as
SELECT sum(cast(new_cases as float)) as TotalCases, sum(cast(new_Deaths as float)) as TotalDeaths, sum(cast(new_Deaths as float))/sum(cast(new_cases as float))*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
where continent is not null

create view RollingPeopleVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location
, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/dea.population)*100
from PortfolioProject. .CovidDeaths dea
 join PortfolioProject. .CovidVaccinations vac
     on dea.Location = vac.Location
     and dea.date = vac.date
where dea.continent is not null