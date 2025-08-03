USE covid;

CREATE TABLE covid_data (
    iso_code VARCHAR(10),
    continent VARCHAR(20),
    location VARCHAR(100),
    date DATE,
    new_tests FLOAT,
    total_tests FLOAT,
    total_tests_per_thousand FLOAT,
    new_tests_per_thousand FLOAT,
    new_tests_smoothed FLOAT,
    new_tests_smoothed_per_thousand FLOAT,
    positive_rate FLOAT,
    tests_per_case FLOAT,
    tests_units VARCHAR(50),
    total_vaccinations FLOAT,
    people_vaccinated FLOAT,
    people_fully_vaccinated FLOAT,
    new_vaccinations FLOAT,
    new_vaccinations_smoothed FLOAT,
    total_vaccinations_per_hundred FLOAT,
    people_vaccinated_per_hundred FLOAT,
    people_fully_vaccinated_per_hundred FLOAT,
    new_vaccinations_smoothed_per_million FLOAT,
    stringency_index FLOAT,
    population_density FLOAT,
    median_age FLOAT,
    aged_65_older FLOAT,
    aged_70_older FLOAT,
    gdp_per_capita FLOAT,
    extreme_poverty FLOAT,
    cardiovasc_death_rate FLOAT,
    diabetes_prevalence FLOAT,
    female_smokers FLOAT,
    male_smokers FLOAT,
    handwashing_facilities FLOAT,
    hospital_beds_per_thousand FLOAT,
    life_expectancy FLOAT,
    human_development_index FLOAT
);


CREATE TABLE covid_cases (
    iso_code VARCHAR(10),
    continent VARCHAR(20),
    location VARCHAR(100),
    date DATE,
    population BIGINT,
    total_cases BIGINT,
    new_cases BIGINT,
    new_cases_smoothed FLOAT,
    total_deaths BIGINT,
    new_deaths BIGINT,
    new_deaths_smoothed FLOAT,
    total_cases_per_million FLOAT,
    new_cases_per_million FLOAT,
    new_cases_smoothed_per_million FLOAT,
    total_deaths_per_million FLOAT,
    new_deaths_per_million FLOAT,
    new_deaths_smoothed_per_million FLOAT,
    reproduction_rate FLOAT,
    icu_patients INT,
    icu_patients_per_million FLOAT,
    hosp_patients INT,
    hosp_patients_per_million FLOAT,
    weekly_icu_admissions INT,
    weekly_icu_admissions_per_million FLOAT,
    weekly_hosp_admissions INT,
    weekly_hosp_admissions_per_million FLOAT
);

SELECT *
FROM covid_cases
LIMIT 5;

SELECT *
FROM covid_cases
WHERE continent IS NOT NULL 
ORDER BY location, date;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid_cases
WHERE continent IS NOT NULL 
ORDER BY location, date;

-- 3. Calculate death percentage among infected (for USA)
SELECT 
    SUM(total_deaths) AS total_deaths,
    SUM(total_cases) AS total_cases,
    (SUM(total_deaths) / SUM(total_cases)) * 100 AS overall_death_percentage
FROM covid_cases
WHERE location LIKE '%states%'
  AND continent IS NOT NULL;
  
-- 4. Calculate percent of population infected by date
SELECT location, date,
       SUM(population) AS population,
       SUM(total_cases) AS total_cases,
       (SUM(total_cases) / SUM(population)) * 100 AS percent_population_infected
FROM covid_cases
WHERE continent IS NOT NULL
GROUP BY location, date
ORDER BY date DESC;

-- 5. Find countries with highest infection rate per population
SELECT location,
		SUM(population),
		SUM(total_cases), 
       (SUM(total_cases)/SUM(population))*100 AS infection_rate
FROM covid_cases
GROUP BY location
ORDER BY infection_rate
LIMIT 10;

-- 6. Find countries with highest total death counts
SELECT location,
	   SUM(total_deaths) AS death_count
FROM covid_cases
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY death_count DESC
;

-- 7. Compare total deaths across continents
SELECT continent, 
		SUM(total_deaths) AS death_count
FROM covid_cases
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY continent
;

-- 8. Global totals and death percentage
SELECT SUM(total_deaths),
	   SUM(population),
       (SUM(total_deaths)/SUM(population)) AS global_total,
       (SUM(total_deaths)/SUM(population))*100 AS global_percentage
FROM covid_cases
WHERE continent IS NOT NULL
;

SELECT *
FROM covid_data
LIMIT 5;

-- 9. Calculate rolling vaccinated people by country over time
SELECT c.continent, 
	   c.location, 
       d.date, 
       c.population, 
       d.total_vaccinations,
       SUM(CAST(d.total_vaccinations AS UNSIGNED))
       OVER (PARTITION BY d.location ORDER BY d.date) AS vaccinations
FROM covid_data d
JOIN covid_cases c
	ON d.date = c.date
    AND d.location = c.location
WHERE d.continent IS NOT NULL
ORDER BY d.location, d.date
;

-- 10. Use CTE to calculate rolling vaccinations and percentage vaccinated
WITH PopVc AS (
	SELECT c.continent, 
	   c.location, 
       d.date, 
       c.population, 
       d.total_vaccinations,
       SUM(CAST(d.total_vaccinations AS UNSIGNED))
       OVER (PARTITION BY d.location ORDER BY d.date) AS vaccinations
FROM covid_data d
JOIN covid_cases c
	ON d.date = c.date
    AND d.location = c.location
WHERE d.continent IS NOT NULL
)

SELECT *,
	   (vaccinations/population) * 100 AS percent_vac
FROM PopVc;

-- 11. Create a temp table to calculate percentage vaccinated
DROP TEMPORARY TABLE IF EXISTS PercentPopulationVaccinated;
CREATE TEMPORARY TABLE PercentPopulationVaccinated (
  continent VARCHAR(255),
  location VARCHAR(255),
  date DATE,
  population NUMERIC,
  new_vaccinations NUMERIC,
  vaccinations NUMERIC
)
;

INSERT INTO PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.date)
FROM covid_cases dea
JOIN covid_data vac
  ON dea.location = vac.location AND dea.date = vac.date;

SELECT *, (vaccinations / population) * 100 AS percent_vaccinated
FROM PercentPopulationVaccinated;

-- 12. Create a view for later visualization
CREATE OR REPLACE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS rolling_people_vaccinated
FROM covid_cases dea
JOIN covid_data vac
  ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
;
