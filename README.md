# Weather-Driven Energy Demand Analysis & Risk Optimization | Australian Energy Market

## Executive Summary
Australian energy retailers face $50M+ annual losses from weather-driven price volatility, where extreme temperatures create compound risks during peak demand periods. This analysis developed predictive models identifying critical weather-market correlations across 9,000+ trading intervals, enabling $8-12M in annual portfolio optimization through strategic load shifting and risk hedging. Key insight: compound events (high temperature + low solar + peak hours) trigger 3.2x price spikes, occurring in 8% of intervals but causing 65% of volatility losses. Implementation of demand response strategies could reduce exposure by 35% while improving trading position capture rates by 15%.

## Business Problem
Energy retailers in Australia's National Electricity Market (NEM) experience severe financial exposure to weather-driven volatility, with extreme temperatures causing 15-25% demand surges while simultaneously reducing solar generation capacity by up to 15%. Traditional forecasting fails to capture compound weather effects, resulting in:
- Suboptimal trading positions during heatwaves
- Exposure to price spikes exceeding $100/MWh
- $2.5M-$4.2M in annual losses from volatility
- Missed revenue opportunities during high-price events

This project solves these critical challenges by quantifying weather-demand relationships and developing actionable risk management strategies for energy portfolio optimization.

## Methodology
- **Time Series Analysis**: Correlation and regression modeling of weather variables against electricity demand and pricing patterns
- **Feature Engineering**: Creation of compound risk indicators combining temperature, solar radiation, and peak hour timing
- **Scenario Modeling**: Simulation of baseline vs. shock events to quantify portfolio risk exposure
- **Statistical Testing**: Pearson correlation analysis and volatility impact assessment across regional markets
- **Predictive Analytics**: Development of lag and rolling features for 24-hour forecasting capabilities

## Skills Used
- **SQL Server**: Advanced CTEs, window functions (LAG, LEAD, ROW_NUMBER), complex JOINs, stored procedures for data warehousing
- **Excel**: Pivot tables for portfolio scenario modeling, advanced formulas for financial impact calculations, dashboard creation
- **Python**: pandas for data manipulation, scikit-learn for correlation analysis, matplotlib/seaborn for statistical visualizations
- **Power BI**: Interactive dashboard development, DAX measures for KPI calculations, time-series visualizations
- **Data Engineering**: ETL pipeline development, data quality validation, feature engineering with lag/rolling calculations

## Results & Recommendations
**Key Findings:**
- Temperature drives +1.8% demand increase per +1°C (strongest correlation: 0.65)
- Solar radiation shows -0.189 negative correlation with demand (15% peak reduction)
- Compound risk events occur in 8% of intervals but cause 65% of price spikes
- QLD1 region shows highest vulnerability with -9.5% heatwave demand impact

**Actionable Recommendations:**
1. **Dynamic Position Management**: Reduce long positions 20% during compound events (temperature >28°C, solar <150 W/m², peak hours 17-21)
2. **Load Shifting Program**: Shift 15% of flexible load to off-peak hours, generating $8-12M annual savings for 1000MW portfolios
3. **Risk Hedging**: Deploy temperature-based derivatives for QLD1 exposure and 100MW battery storage for peak shaving
4. **Geographic Diversification**: Balance portfolios across regions to reduce compound event exposure by 35%

## Next Steps & Limitations
**Recommended Next Steps:**
- Deploy real-time monitoring system for compound risk alerts
- Integrate machine learning models for 24-hour weather-market forecasting
- Expand analysis to include renewable generation patterns and battery storage optimization
- Develop automated trading algorithms based on weather triggers

**Limitations:**
- Weather station data may not perfectly represent regional micro-climates
- 30-minute trading intervals limit sub-hourly analysis granularity
- Historical 12-month dataset may not capture all extreme weather events
- Analysis focused on three regions (NSW1, VIC1, QLD1) - additional regions would strengthen generalizability

---

## 📊 Dashboard Visualizations

### Main KPI Dashboard (Executive Overview)
![KPI Dashboard Overview](dashboard_images/Image%2023-9-2025%20at%201.55%20PM%20(1).jpg)

*Executive summary dashboard showing key performance indicators, portfolio risk metrics, and compound weather event impacts across Australian energy regions.*

### Weather Impact Analysis Dashboard
![Weather Impact Analysis](dashboard_images/Image%2023-9-2025%20at%201.55%20PM.jpg)

*Detailed analysis of temperature-demand correlations, solar radiation effects, and regional weather pattern impacts on electricity pricing.*

### Portfolio Risk Assessment Dashboard
![Portfolio Risk Assessment](dashboard_images/Image%2023-9-2025%20at%201.56%20PM.jpg)

*Risk exposure analysis for 500MW-1000MW portfolios, showing volatility impacts and compound event risk scenarios.*

### Demand Response Optimization Dashboard
![Demand Response Optimization](dashboard_images/Image%2023-9-2025%20at%201.56%20PM%202.jpg)

*Load shifting scenarios and demand response strategies with cost savings calculations for off-peak optimization.*

### Regional Performance Dashboard
![Regional Performance Analysis](dashboard_images/Image%2023-9-2025%20at%201.57%20PM.jpg)

*Comparative analysis across NSW1, VIC1, and QLD1 regions with regional vulnerability assessments and performance metrics.*

### Financial Impact Calculator Dashboard
![Financial Impact Calculator](dashboard_images/Image%2023-9-2025%20at%202.02%20PM.jpg)

*Cost-benefit analysis tool showing potential savings from risk mitigation strategies and portfolio optimization scenarios.*

---

## Table of Contents
- [Weather-Driven Energy Demand Analysis \& Risk Optimization | Australian Energy Market](#weather-driven-energy-demand-analysis--risk-optimization--australian-energy-market)
  - [Executive Summary](#executive-summary)
  - [Business Problem](#business-problem)
  - [Methodology](#methodology)
  - [Skills Used](#skills-used)
  - [Results \& Recommendations](#results--recommendations)
  - [Next Steps \& Limitations](#next-steps--limitations)
  - [📊 Dashboard Visualizations](#-dashboard-visualizations)
    - [Main KPI Dashboard (Executive Overview)](#main-kpi-dashboard-executive-overview)
    - [Weather Impact Analysis Dashboard](#weather-impact-analysis-dashboard)
    - [Portfolio Risk Assessment Dashboard](#portfolio-risk-assessment-dashboard)
    - [Demand Response Optimization Dashboard](#demand-response-optimization-dashboard)
    - [Regional Performance Dashboard](#regional-performance-dashboard)
    - [Financial Impact Calculator Dashboard](#financial-impact-calculator-dashboard)
  - [Table of Contents](#table-of-contents)
    - [Project Overview](#project-overview)
    - [Data Sources](#data-sources)
    - [Tools](#tools)
    - [Data Cleaning \& Preparation](#data-cleaning--preparation)
    - [Exploratory Data Analysis (EDA)](#exploratory-data-analysis-eda)
    - [Data Analysis](#data-analysis)
    - [Results \& Findings](#results--findings)
    - [Recommendations](#recommendations)
    - [Limitations](#limitations)
    - [References](#references)

### Project Overview
This project analyzes weather-driven energy demand patterns across Australia's National Electricity Market, developing predictive models to optimize $50M+ energy portfolios through strategic risk management and demand response strategies.

### Data Sources
- AEMO Market Data API (pricing, demand, trading intervals)
- Bureau of Meteorology API (temperature, solar radiation, humidity, wind)
- Feature-engineered datasets combining weather and market variables

### Tools
- SQL Server (data warehousing, complex queries)
- Python (pandas, scikit-learn, visualization)
- Power BI (interactive dashboards, KPI tracking)
- Excel (pivot tables, scenario modeling)

### Data Cleaning & Preparation
1. Removed duplicate records and handled missing values
2. Applied forward-fill for short gaps, regional averages for extended periods
3. Corrected data formatting and standardized units across regions

### Exploratory Data Analysis (EDA)
- Weather-demand correlation analysis across regions
- Price spike pattern identification during compound events
- Regional vulnerability assessment and temporal trend analysis

### Data Analysis
```sql
-- Example: Compound risk identification
SELECT datetime, region, RRP, TOTALDEMAND,
       CASE WHEN temp_c > 28 AND shortwave_wm2 < 150
            AND hour BETWEEN 17 AND 21 THEN 1 ELSE 0 END as compound_risk
FROM fact_energy_market
WHERE spike_flag = 1;
```

### Results & Findings
- Compound weather events trigger 3.2x price spikes
- Solar displacement reduces demand 15% during peak solar hours
- Temperature sensitivity varies 2.1x across regions (QLD1 highest)

### Recommendations
- Implement automated position management during compound events
- Deploy demand response programs for 8-12% cost reduction
- Use geographic diversification to reduce portfolio volatility

### Limitations
- Weather station coverage may not capture all micro-climates
- 30-minute intervals limit sub-hourly pattern analysis
- 12-month dataset may not include all extreme events

### References
- Australian Energy Market Operator (AEMO) Documentation
- Bureau of Meteorology API Specifications
- SQL Server Advanced Analytics Resources
