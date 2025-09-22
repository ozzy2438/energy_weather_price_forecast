
CREATE OR ALTER VIEW vw_powerbi_weather_impact AS
SELECT
    t.REGION, t.date, t.hour,
    t.RRP AS price, t.TOTALDEMAND AS demand,
    t.temp_c, t.rh_pct, t.rain_mm, t.sunshine_sec, t.shortwave_wm2, t.wind_speed_ms,
    -- Weather bins for visual distinctness
    CASE WHEN t.temp_c < 10 THEN '<10°C'
         WHEN t.temp_c < 15 THEN '10-15°C'
         WHEN t.temp_c < 20 THEN '15-20°C'
         WHEN t.temp_c < 25 THEN '20-25°C'
         WHEN t.temp_c < 30 THEN '25-30°C'
         ELSE '>30°C' END AS temp_bin,
    CASE WHEN t.shortwave_wm2 < 100 THEN '0-100'
         WHEN t.shortwave_wm2 < 300 THEN '100-300'
         WHEN t.shortwave_wm2 < 500 THEN '300-500'
         WHEN t.shortwave_wm2 < 700 THEN '500-700'
         ELSE '700+' END AS solar_bin,
    CASE WHEN t.wind_speed_ms < 2 THEN '0-2'
         WHEN t.wind_speed_ms < 4 THEN '2-4'
         WHEN t.wind_speed_ms < 6 THEN '4-6'
         WHEN t.wind_speed_ms < 8 THEN '6-8'
         ELSE '8+' END AS wind_bin,
    -- Event and spike flags for graphing
    CASE WHEN t.RRP > 100 THEN 1 ELSE 0 END AS price_spike,
    -- Averages for easy aggregation in Power BI
    AVG(t.temp_c) OVER (PARTITION BY t.REGION, t.date) AS region_avg_temp,
    AVG(t.shortwave_wm2) OVER (PARTITION BY t.REGION, t.date) AS region_avg_solar,
    AVG(t.RRP) OVER (PARTITION BY t.REGION, t.date) AS region_avg_price,
    AVG(t.TOTALDEMAND) OVER (PARTITION BY t.REGION, t.date) AS region_avg_demand,
    COUNT(CASE WHEN t.rain_mm > 0 THEN 1 END) OVER (PARTITION BY t.REGION, t.date) AS rain_hours_count,
    -- Weather-electricity correlation (to be aggregated in Power BI):
    t.temp_c * 1.0 AS X_temp,
    t.RRP * 1.0 AS Y_price,
    t.shortwave_wm2 * 1.0 AS X_solar,
    -- Region color for consistent legend mapping
    CASE t.REGION WHEN 'QLD1' THEN '#45B7D1' WHEN 'NSW1' THEN '#FF6B6B' WHEN 'VIC1' THEN '#4ECDC4' END AS region_color
FROM (
    SELECT *,
        CONVERT(date, datetime_utc) AS date
    FROM dbo.Brisbane_QLD1_merged
    UNION ALL
    SELECT *, CONVERT(date, datetime_utc) AS date FROM dbo.Sydney_NSW1_merged
    UNION ALL
    SELECT *, CONVERT(date, datetime_utc) AS date FROM dbo.Melbourne_VIC1_merged
) t;
