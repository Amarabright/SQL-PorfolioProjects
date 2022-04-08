Select *
From PortfolioProject..CovidDeaths
where continent is not null
order by 3,4


--Select data to be used

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
where continent is not null
order by 1, 2

--To look for Total Cases vs Total Deaths

Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
order by 1, 2

--this shows the estimates of deaths per country with focus on Nigeria
Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where Location like '%nigeria%'
where continent is not null
order by 1, 2

---Looking at Total Cases Vs Population
--shows percentage of poplulation that got covid in Nigeria
Select Location, date,  Population, total_cases, (total_cases/population)*100 as DPercentPopulationInfected
From PortfolioProject..CovidDeaths
--where Location like '%nigeria%'
order by 1, 2

--looking at countries with highest infection rate compared to population
Select Location,  Population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--where Location like '%nigeria%'
Group by Location, Population
order by PercentPopulationInfected desc


--Showing Countries with Highest Death Count per Population
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--where Location like '%nigeria%'
where continent is not null
Group by Location
order by TotalDeathCount desc


--LET'S BREAK THINGS DOWN BY CONTINENT
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--where Location like '%nigeria%'
where continent is not null
Group by continent
order by TotalDeathCount desc

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--where Location like '%nigeria%'
where continent is  null
Group by location
order by TotalDeathCount desc

--showing contintents with hgihest death count per population
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--where Location like '%nigeria%'
where continent is not null
Group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS
--THIS GIVES THE SUM OF THE NEW CASES BY DATE.
Select date, SUM(new_cases)--, total-deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%nigeria%'
where continent is not null
Group By date
order by 1, 2

Select date, SUM(new_cases), SUM(cast(new_deaths as int))--,total_deaths, (total_ddeaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%nigeria%'
where continent is not null
Group By date
order by 1, 2


--To get death percnt across the world
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%nigeria%'
where continent is not null
--oup By date
order by 1, 2

--looking at Total popultaion vs Vaccination
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER   (Partition by dea.location)
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

--Creating views to store data fro later visualization

Create view  DeathPercentage as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3

Select *
From DeathPercentage
