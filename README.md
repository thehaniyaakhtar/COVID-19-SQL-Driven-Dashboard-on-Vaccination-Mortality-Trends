# 📊 COVID-19 Global Trends Analysis Using SQL & Tableau

This project performs a comprehensive spatiotemporal analysis of COVID-19 using structured SQL queries and interactive Tableau dashboards. Leveraging data from **Our World in Data**, it uncovers patterns in infections, mortality, testing, and vaccination rollouts across countries and continents. The goal is to derive data-backed insights for public health decisions and communicate them through compelling visualizations.

---

## 🔍 Project Overview

### 🎯 Objective
To engineer a robust analytical workflow that models the global impact of COVID-19 using relational queries and visualize the results via Tableau. Focus areas include:

- Identifying high-risk regions and trends  
- Measuring vaccination effectiveness over time  
- Comparing country and continent-level response metrics  

### 🛠 Tech Stack
- **SQL (MySQL):** Data modeling, joins, CTEs, window functions, temp tables, and views  
- **Tableau:** Data visualization, user filters, KPI dashboards  
- **Data Source:** [OurWorldInData COVID-19 Dataset](https://ourworldindata.org/covid-deaths) 

---

## 🧠 Key Technical Contributions

### 🧱 Data Engineering
- Normalized and structured raw CSV datasets into relational tables: `covid_cases` and `covid_data`  
- Applied indexing and primary key strategies for query optimization  
- Created **TEMP TABLES** and **VIEWS** for reusable analysis blocks  

### 🔎 Exploratory Data Analysis (SQL)
- Time-series breakdowns of daily cases, deaths, and vaccinations  
- Rolling vaccination averages using **WINDOW FUNCTIONS**  
- Comparative analysis by continent and country using `GROUP BY`, `JOIN`, and `HAVING` clauses  

### 🧮 Advanced Querying
- Identification of **peak infection/death days** per region  
- Dynamic calculation of **CFR** (Case Fatality Rate) and **VPR** (Vaccination Progress Rate)  
- View-level metrics to drive Tableau dashboards  

---

## 📊 Tableau Dashboard Features

- 📈 **Time Series Visuals:** Daily infection and death trends across selected geographies  
- 🌍 **Geo Maps:** Choropleth maps for continent- and country-level mortality and vaccination rates  
- 🧮 **Comparative KPIs:** Dynamic filters for top-10 analysis of infections, deaths, and recovery  
- 🧭 **User Controls:** Region filters, timeline sliders, metric switchers for interactive exploration  

<img width="1625" height="728" alt="Screenshot (467)" src="https://github.com/user-attachments/assets/4acf4a5d-eb84-4d0c-8f24-588683659972" />

---

## 📈 Insights & Analytical Highlights

### 🌐 Global Observations
- Countries with the highest infection loads—**USA, Brazil, India**—also exhibited slower early vaccine rollouts.  
- Vaccination and mortality are inversely correlated post Q2-2021, especially in high-coverage countries.  

### 🧮 Data-Driven Insights
- Nations with >70% full-dose vaccination (e.g., **Portugal, Chile**) saw significant drops in CFR within 30–45 days.  
- Testing density (**tests per thousand**) was directly proportional to early outbreak containment and CFR accuracy.  

### 🧬 Vaccination Impact
- Booster rollout phases aligned with reduced case spikes in **late 2021–2022**.  
- Rolling average vaccination metrics highlighted gaps in public policy execution and vaccine hesitancy trends.  

### 📌 Comparative Country Metrics
- **Africa** and **Southeast Asia** showed data sparsity and underreporting—suggesting a need for synthetic modeling or estimation.  
- Temporal offset analysis between wave peaks and policy actions revealed response lag in several high-density countries.  

---

