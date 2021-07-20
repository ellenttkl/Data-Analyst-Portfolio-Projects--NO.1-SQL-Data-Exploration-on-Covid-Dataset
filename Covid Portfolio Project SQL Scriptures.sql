-- Dataset link: https://ourworldindata.org/covid-deaths

Select *
From PortfolioProject..CovidDeaths
--where continent is not null
order by 3,4

--Select *
--From PortfolioProject..CovidVacinations
--where continent is not null
--order by 3,4


--selecting data we are going to be using

Select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country

Select location,date,total_cases,total_deaths,(total_deaths/total_cases *100) as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2


--Looking at total cases vs population
--shows what percentage of population got covid

Select location,date,population,total_cases,(total_cases/population *100) as PercentagePopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%states%'
order by 1,2



--Looking at countries with highest infection rate compared to population


Select location,population,MAX(total_cases) as HighestInfectedCount,MAX(total_cases/population *100) as PercentagePopulationInfected
from PortfolioProject..CovidDeaths
where continent is not null
group by location,population
order by PercentagePopulationInfected desc

--showing countries with highest death count per population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from  PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc


---Break things down by continent
--Showing continent with the highest death count


Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from  PortfolioProject..CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc



--Global Numbers

Select date, SUM(new_cases) as total_new_cases, SUM(cast(new_deaths as int)) as total_new_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases)*100) as new_death_percentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2

--Looking at total population vs vacinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVacinations vac
on dea.date=vac.date and dea.location = vac.location
where dea.continent is not null
order by 2,3


--Use CTE (Common Table Expression)


with PopvsVac(continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVacinations vac
on dea.date=vac.date and dea.location = vac.location
where dea.continent is not null
--order by 2,3
)

select *,(RollingPeopleVaccinated/population)*100 
from PopvsVac


--Use Temp Table
Drop Table if Exists #PercentabePopulationVaccinated
Create Table #PercentabePopulationVaccinated
(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentabePopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVacinations vac
on dea.date=vac.date and dea.location = vac.location
where dea.continent is not null
--order by 2,3

select *,(RollingPeopleVaccinated/population)*100 
from #PercentabePopulationVaccinated


--Creating view to store data for later visulization

Create View PercentabePopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea 
join PortfolioProject..CovidVacinations vac
on dea.date=vac.date and dea.location = vac.location
where dea.continent is not null
--order by 2,3

Select * from PercentabePopulationVaccinated
