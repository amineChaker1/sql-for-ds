  SELECT TOP (1000) *
  FROM sqlCovidProject.dbo.CovidDeaths
  order by 3,4

  --SELECT TOP (1000) *
  --FROM sqlCovidProject.dbo.CovidVaccinations
  --order by 3 , 4


-- Selceting the nedded data
  Select location, date, total_cases, new_cases, total_deaths, population
  from sqlCovidProject.dbo.CovidDeaths
  order by 1,2

  /* Data Exploring */

-- Total Cases vs Total Deaths (likelyhood of dying from covid in france)
  select Location, date, total_cases, total_deaths, (total_deaths / total_cases) * 100 as casesPerDeathes
  from sqlCovidProject.dbo.CovidDeaths
  where Location like '%france%'
  order by 1,2

-- Total Cases vs Population (likelyhood of catching covid the infection rate)
  select Location, date, total_cases, population, (total_cases / population) * 100 as casesPerPopulation
  from sqlCovidProject.dbo.CovidDeaths
  order by 1,2

-- Countries with highest Infection Rate compared to Population
  select Location, population, max(total_cases) as HighestTotalCases, max((total_cases/population)) * 100 as HighestInfectionRate
  from sqlCovidProject.dbo.CovidDeaths
  group by Location , population
  order by HighestInfectionRate desc

-- Countries with highest Death Count per Population not including continents
  select Location, max(cast(total_deaths as integer)) as TotalDeaths
  from sqlCovidProject.dbo.CovidDeaths
  where continent is not null
  group by Location
  order by TotalDeaths desc 

-- now including continents
  select Location, max(cast(total_deaths as integer)) as TotalDeaths
  from sqlCovidProject.dbo.CovidDeaths
  where continent is null
  group by Location
  order by TotalDeaths desc 

-- likelyhood of dying from covid globaly
  select sum(new_cases), sum(cast(new_deaths as int)), sum(cast(new_deaths as int)) / sum(new_cases) * 100 as DeathPer
  from sqlCovidProject.dbo.CovidDeaths
  where continent is not null
  --group by location, date
  order by 1,2 

-- Working on the vaccination table
select location, new_vaccinations, new_vaccinations_smoothed
from sqlCovidProject..CovidVaccinations
order by 1

-- population vs vaccination (using the total_vaccination column)
  select dea.location, max(population) as pop , max(total_vaccinations) as allVaccinations, (max(total_vaccinations)/max(population) ) * 100 as VacPerPopPercent
  from sqlCovidProject..CovidDeaths as dea
  join sqlCovidProject..CovidVaccinations as vac
  on dea.location = vac.location and dea.date = vac.date
  where dea.continent is not null
  group by dea.location
  order by 1

-- population vs vaccination (using the new_vaccinations column)
  select dea.continent, dea.location, dea.date, dea.population, new_vaccinations, 
  sum(cast(new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as
  CumulativeNewVaccinations --to get the maximum value of this column we need to create a view or a CTE
  from sqlCovidProject..CovidDeaths as dea
  join sqlCovidProject..CovidVaccinations as vac
  on dea.location = vac.location and dea.date = vac.date
  where dea.continent is not null
  order by 2,3

-- creating view
USE sqlCovidProject
GO
create view PopulationVsVaccinationView
as
select dea.continent, dea.location, dea.date, dea.population, new_vaccinations, 
  sum(cast(new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as
  CumulativeNewVaccinations --to get the maximum value of this column we need to create a view
  from sqlCovidProject..CovidDeaths as dea
  join sqlCovidProject..CovidVaccinations as vac
  on dea.location = vac.location and dea.date = vac.date
  where dea.continent is not null

select location, date , (CumulativeNewVaccinations / population) * 100 as PopulationVsVaccinationPercent
from PopulationVsVaccinationView
group by location, date
order by 2,3

-- Using CTE 
With PopulationVsVaccinationCTE as (
select dea.continent, dea.location, dea.date, dea.population, new_vaccinations, 
  sum(cast(new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date) as
  CumulativeNewVaccinations --to get the maximum value of this column we need to create a view
  from sqlCovidProject..CovidDeaths as dea
  join sqlCovidProject..CovidVaccinations as vac
  on dea.location = vac.location and dea.date = vac.date
  where dea.continent is not null
)
select * , (CumulativeNewVaccinations / population) * 100 as PopulationVsVaccinationPercent
from PopulationVsVaccinationCTE
where new_vaccinations is not null and CumulativeNewVaccinations is not null