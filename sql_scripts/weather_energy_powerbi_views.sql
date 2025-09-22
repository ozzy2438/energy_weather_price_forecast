
-- View 1: Daily, region, and KPI summary
CREATE OR ALTER VIEW vw_powerbi_summary AS
SELECT
  REGION,
  DATE = CONVERT(date, datetime_utc),
  AVG(TOTALDEMAND) AS avg_demand,
  MAX(TOTALDEMAND) AS peak_demand,
  MIN(TOTALDEMAND) AS min_demand,
  AVG(RRP) AS avg_price,
  MAX(RRP) AS max_price,
  MIN(RRP) AS min_price,
  SUM(rain_mm) AS total_rainfall,
  AVG(temp_c) AS avg_temp,
  AVG(sunshine_sec) AS avg_sunshine,
  AVG(shortwave_wm2) AS avg_solar,
  COUNT(*) AS records
FROM Brisbane_QLD1_merged
GROUP BY REGION, CONVERT(date, datetime_utc)
UNION ALL
SELECT
  REGION,
  CONVERT(date, datetime_utc),
  AVG(TOTALDEMAND),
  MAX(TOTALDEMAND),
  MIN(TOTALDEMAND),
  AVG(RRP),
  MAX(RRP),
  MIN(RRP),
  SUM(rain_mm),
  AVG(temp_c),
  AVG(sunshine_sec),
  AVG(shortwave_wm2),
  COUNT(*)
FROM Sydney_NSW1_merged
GROUP BY REGION, CONVERT(date, datetime_utc)
UNION ALL
SELECT
  REGION,
  CONVERT(date, datetime_utc),
  AVG(TOTALDEMAND),
  MAX(TOTALDEMAND),
  MIN(TOTALDEMAND),
  AVG(RRP),
  MAX(RRP),
  MIN(RRP),
  SUM(rain_mm),
  AVG(temp_c),
  AVG(sunshine_sec),
  AVG(shortwave_wm2),
  COUNT(*)
FROM Melbourne_VIC1_merged
GROUP BY REGION, CONVERT(date, datetime_utc);

-- View 2: Hour-of-day demand and price summary
CREATE OR ALTER VIEW vw_powerbi_hourly_pattern AS
SELECT
  REGION,
  hour,
  AVG(TOTALDEMAND) AS avg_demand,
  AVG(RRP) AS avg_price,
  COUNT(*) AS count_records
FROM (
  SELECT REGION, hour, TOTALDEMAND, RRP FROM Brisbane_QLD1_merged
  UNION ALL
  SELECT REGION, hour, TOTALDEMAND, RRP FROM Sydney_NSW1_merged
  UNION ALL
  SELECT REGION, hour, TOTALDEMAND, RRP FROM Melbourne_VIC1_merged
) t
GROUP BY REGION, hour;

-- View 3: Price spike analysis (>100 $/MWh)
CREATE OR ALTER VIEW vw_powerbi_price_spikes AS
SELECT
  REGION,
  datetime_utc,
  hour,
  RRP,
  TOTALDEMAND,
  temp_c,
  rain_mm,
  shortwave_wm2
FROM (
    SELECT * FROM Brisbane_QLD1_merged
    UNION ALL
    SELECT * FROM Sydney_NSW1_merged
    UNION ALL
    SELECT * FROM Melbourne_VIC1_merged
) t
WHERE RRP > 100;

-- View 4: Weather/electricity correlations (for analysis)
-- You'd calculate correlations in DAX in Power BI, but run summary stats in SQL
CREATE OR ALTER VIEW vw_powerbi_weather_kpis AS
SELECT 
  REGION,
  AVG(temp_c) AS avg_temp,
  AVG(CASE WHEN rain_mm>0 THEN rain_mm ELSE NULL END) AS avg_rain,
  AVG(shortwave_wm2) AS avg_solar,
  AVG(RRP) AS avg_price,
  AVG(TOTALDEMAND) AS avg_demand,
  SUM(CASE WHEN RRP > 100 THEN 1 ELSE 0 END)*1.0/COUNT(*) AS price_spike_pct
FROM (
    SELECT * FROM Brisbane_QLD1_merged
    UNION ALL
    SELECT * FROM Sydney_NSW1_merged
    UNION ALL
    SELECT * FROM Melbourne_VIC1_merged
) t
GROUP BY REGION;

-- View 5: Detailed feature-engineered data for modeling
-- Brisbane shown; repeat for other cities
go
CREATE OR ALTER VIEW vw_powerbi_brisbane_features AS
SELECT * FROM Brisbane_QLD1_fe;
go
CREATE OR ALTER VIEW vw_powerbi_sydney_features AS
SELECT * FROM Sydney_NSW1_fe;
go
CREATE OR ALTER VIEW vw_powerbi_melbourne_features AS
SELECT * FROM Melbourne_VIC1_fe;
go
