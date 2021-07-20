--Data Visulation on Teableau
--Project Dataset:https://ourworldindata.org/covid-deaths


--1.Global Number

Select SUM(new_cases) as total_new_cases, SUM(cast(new_deaths as int)) as total_new_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases)*100) as new_death_percentage
from PortfolioProject..CovidDeaths
where continent is not null
--group by date
order by 1,2


--2.Showing continent with the total death count

Select location, Sum(cast(new_deaths as int)) as TotalDeathCount
from  PortfolioProject..CovidDeaths
where continent is null and location not in('World','International','European Union')
group by location
order by TotalDeathCount desc

--3.Looking at countries with highest infection rate compared to population

Select location,population,MAX(total_cases) as HighestInfectedCount,MAX(total_cases/population *100) as PercentagePopulationInfected
from PortfolioProject..CovidDeaths
where continent is not null
group by location,population
order by PercentagePopulationInfected desc


--4.Looking at countries with highest infection rate compared to population over time

Select location,population,date,MAX(total_cases) as HighestInfectedCount,MAX(total_cases/population *100) as PercentagePopulationInfected
from PortfolioProject..CovidDeaths
where continent is not null
group by location,population,date
order by PercentagePopulationInfected desc