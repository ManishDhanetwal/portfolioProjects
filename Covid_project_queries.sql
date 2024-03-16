  select location , date , total_cases, total_deaths ,(total_deaths/total_cases)*100 as DeathPercentage
  from PortfolioProject..covidDeath
  order by 1,2

  SELECT 
  location, 
  date,
  total_cases, 
  total_deaths, 
  (COALESCE(total_deaths, 0) / NULLIF(COALESCE(total_cases, 0), 0)) * 100 AS DeathPercentage
FROM 
  PortfolioProject..covidDeath
ORDER BY 
  1, 2;

  SELECT 
  location, 
  date,
  total_cases, 
  total_deaths, 
  (CAST(total_deaths AS float) / NULLIF(CAST(total_cases AS float), 0)) * 100 AS DeathPercentage
FROM 
  PortfolioProject..covidDeaths
ORDER BY 
  location, 
  date;


  SELECT 
  location, 
  date, 
  MAX(total_cases) AS total_cases, 
  MAX(total_deaths) AS total_deaths,
 (CAST(total_deaths AS float) / NULLIF(CAST(total_cases AS float), 0)) * 100 AS DeathPercentage
FROM 
  PortfolioProject..covidDeath
GROUP BY 
  location, 
  date
ORDER BY 
  location, 
  date;


  --show hioghest death count


  select location , MAX(cast(total_deaths as int)) as TotalDeathCount
  from PortfolioProject..covidDeath
  where continent is not null
  group by location
  order by TotalDeathCount desc


 -- lets break things down by continent 

   select location , MAX(cast(total_deaths as int)) as TotalDeathCount
  from PortfolioProject..covidDeath
  where continent is not null
  group by continent
  order by TotalDeathCount desc


  --showing the continents wiht hifhes death counte per popilation


  select continent ,MAX(cast(total_deaths as int)) as TotalDeathCount
  from PortfolioProject..covidDeath

  where continent is not null
  group by continent
  order by TotalDeathCount desc

  select *
  from PortfolioProject..covidDeath dea
  join PortfolioProject..covidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date


SELECT 
date,
  SUM(new_cases),
  SUM(new_deaths),
  SUM(cast(new_deaths as float) / NULLIF(cast(new_cases as float),0))* 100 AS Globaldeath
from PortfolioProject..covidDeath
WHERE continent IS NOT NULL
group by date
order by 1,2

SELECT
  date,
  SUM(new_cases),
  SUM(new_deaths),
  SUM(CAST(new_deaths AS float) / NULLIF(CAST(new_cases AS float), 0)) * 100 AS DeathPercentage
FROM 
  PortfolioProject..covidDeath
WHERE 
  continent IS NOT NULL
GROUP BY 
  date
ORDER BY 1,2;


SELECT
  location,
  date,
  SUM(cast(total_cases AS int)) AS total_cases,
  SUM(cast(total_deaths as int)) AS total_deaths
FROM
  PortfolioProject..covidDeath
GROUP BY
  location,
  date;
WITH CTE AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY location, date ORDER BY (SELECT NULL)) AS rn
  FROM PortfolioProject..covidDeath
)
DELETE FROM CTE WHERE rn > 1;


SELECT
  date,
  SUM(new_cases),
  SUM(new_deaths),
  SUM(CAST(new_deaths AS float) / NULLIF(CAST(new_cases AS float), 0)) * 100 AS DeathPercentage
FROM 
  PortfolioProject..covidDeath
WHERE 
  continent IS NOT NULL
GROUP BY 
  date
ORDER BY 1,2;



--total pop . vs vaccinated


---USE CTE

with PopvsVac ( Continent , location ,Date , Population , new_vaccinations , TotalVaccinationtoDate ) 
as (

select dea.continent , dea.location , dea.date , dea.population, vac.new_vaccinations,
SUM(convert(float ,vac.new_vaccinations)) over (Partition by dea.location order by dea.location , dea.date) as TotalVaccinationtoDate
from PortfolioProject..covidDeath as dea
join PortfolioProject..covidVaccinations as  vac
	on dea.location= vac.location
	and dea.date=vac.date
where dea.continent is not null
)

Select * ,  ( TotalVaccinationtoDate/Population)*100 As percentagevaccination
from PopvsVac


order by 2,3


--temp TABLE
DROP table if exists #percentPopulationVaccinated
Create table #percentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar (255),
date datetime,
population numeric,
new_vaccination numeric ,
TotalVaccinationtoDate numeric )


insert into #percentPopulationVaccinated

select dea.continent , dea.location , dea.date , dea.population, vac.new_vaccinations,
SUM(convert(float ,vac.new_vaccinations)) over (Partition by dea.location order by dea.location , dea.date) as TotalVaccinationtoDate
from PortfolioProject..covidDeath as dea
join PortfolioProject..covidVaccinations as  vac
	on dea.location= vac.location
	and dea.date=vac.date
where dea.continent is not null

 
Select * ,  ( TotalVaccinationtoDate/Population)*100 As percentagevaccination
from #percentPopulationVaccinated


--create view to store the data for visualisation

 Create view percentPopulationVaccinated as 

select dea.continent , dea.location , dea.date , dea.population, vac.new_vaccinations,
SUM(convert(float ,vac.new_vaccinations)) over (Partition by dea.location order by dea.location , dea.date) as TotalVaccinationtoDate
from PortfolioProject..covidDeath as dea
join PortfolioProject..covidVaccinations as  vac
	on dea.location= vac.location
	and dea.date=vac.date
where dea.continent is not null

select * from  percentPopulationVaccinated