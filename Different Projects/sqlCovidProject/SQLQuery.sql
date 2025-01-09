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