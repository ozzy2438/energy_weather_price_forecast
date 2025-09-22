
CREATE OR ALTER VIEW vw_powerbi_temporal_patterns AS
WITH cte AS (
  SELECT
    t.REGION,
    t.date,
    t.hour,
    t.dow,
    CASE WHEN t.hour BETWEEN 17 AND 21 THEN 'Peak'
         WHEN t.hour BETWEEN 11 AND 14 THEN 'Off-Peak'
         ELSE 'Standard' END AS period_bin,
    CASE WHEN t.dow IN (5,6) THEN 'Weekend' ELSE 'Weekday' END AS week_bin,
    t.TOTALDEMAND,
    t.RRP,
    t.temp_c,
    t.shortwave_wm2,
    t.rain_mm,
    t.rh_pct,
    t.sunshine_sec,
    t.wind_speed_ms
  FROM (
    SELECT REGION, CONVERT(date, datetime_utc) AS date, hour, dow, RRP, TOTALDEMAND, temp_c, shortwave_wm2, rain_mm, rh_pct, sunshine_sec, wind_speed_ms FROM dbo.Brisbane_QLD1_merged
    UNION ALL
    SELECT REGION, CONVERT(date, datetime_utc) AS date, hour, dow, RRP, TOTALDEMAND, temp_c, shortwave_wm2, rain_mm, rh_pct, sunshine_sec, wind_speed_ms FROM dbo.Sydney_NSW1_merged
    UNION ALL
    SELECT REGION, CONVERT(date, datetime_utc) AS date, hour, dow, RRP, TOTALDEMAND, temp_c, shortwave_wm2, rain_mm, rh_pct, sunshine_sec, wind_speed_ms FROM dbo.Melbourne_VIC1_merged
  ) t
)
SELECT
  REGION,
  date,
  hour,
  dow,
  period_bin,
  week_bin,
  TOTALDEMAND,
  RRP,
  temp_c,
  shortwave_wm2,
  rain_mm,
  rh_pct,
  sunshine_sec,
  wind_speed_ms,
  AVG(TOTALDEMAND) OVER (PARTITION BY REGION, hour) AS avg_demand_by_hour,
  AVG(RRP) OVER (PARTITION BY REGION, hour) AS avg_price_by_hour,
  AVG(TOTALDEMAND) OVER (PARTITION BY REGION, dow) AS avg_demand_by_dow,
  AVG(RRP) OVER (PARTITION BY REGION, dow) AS avg_price_by_dow,
  AVG(RRP) OVER (PARTITION BY REGION, period_bin) AS avg_price_by_period,
  AVG(TOTALDEMAND) OVER (PARTITION BY REGION, period_bin) AS avg_demand_by_period,
  AVG(RRP) OVER (PARTITION BY REGION, week_bin) AS avg_price_by_week_bin,
  AVG(TOTALDEMAND) OVER (PARTITION BY REGION, week_bin) AS avg_demand_by_week_bin,
  STDEV(TOTALDEMAND) OVER (PARTITION BY REGION, hour) AS std_demand_by_hour,
  STDEV(RRP) OVER (PARTITION BY REGION, hour) AS std_price_by_hour
FROM cte;
