
-- Step 6: Scenario Forecasting (+3C temp, -30% solar, peak-hour flag; compute deltas)
-- Baseline: recent week from fact table or desired horizon
SELECT *
INTO #baseline_forecast
FROM vw_fact_energy_market
WHERE datetime BETWEEN DATEADD(day, -7, (SELECT MAX(datetime) FROM vw_fact_energy_market))
                  AND (SELECT MAX(datetime) FROM vw_fact_energy_market);

-- Scenario shock: +3C temp, -30% solar, force 'peak' period
SELECT 
    datetime, region, hour, day_of_week, is_weekend,
    'peak' as peak_period,
    CASE WHEN temp_c IS NOT NULL THEN temp_c + 3 ELSE NULL END as temp_c,
    rh_pct, rain_mm, sunshine_sec,
    CASE WHEN shortwave_wm2 IS NOT NULL THEN shortwave_wm2 * 0.7 ELSE NULL END as shortwave_wm2,
    wind_speed_ms, RRP, TOTALDEMAND,
    temp_bin, spike_flag, compound_highTemp_lowSolar_peakHour,
    RRP_lag_1h, RRP_lag_12h, RRP_lag_24h,
    TOTALDEMAND_lag_1h, TOTALDEMAND_lag_12h, TOTALDEMAND_lag_24h,
    RRP_rolling_3h, RRP_rolling_6h, RRP_rolling_24h,
    TOTALDEMAND_rolling_3h, TOTALDEMAND_rolling_6h, TOTALDEMAND_rolling_24h
INTO #scenario_forecast
FROM vw_fact_energy_market
WHERE datetime BETWEEN DATEADD(day, -7, (SELECT MAX(datetime) FROM vw_fact_energy_market))
                  AND (SELECT MAX(datetime) FROM vw_fact_energy_market);

-- Calculate deltas (actual forecasting requires application of ML model, not pure SQL)
SELECT b.datetime, b.region,
       CAST(s.RRP AS FLOAT) - CAST(b.RRP AS FLOAT) AS delta_price,
       CAST(s.TOTALDEMAND AS FLOAT) - CAST(b.TOTALDEMAND AS FLOAT) AS delta_demand
INTO #forecast_delta
FROM #baseline_forecast b
JOIN #scenario_forecast s
  ON b.datetime = s.datetime AND b.region = s.region;

-- For sharing or dashboard, export: SELECT * FROM #forecast_delta
-- Clean up temp tables
DROP TABLE IF EXISTS #baseline_forecast, #scenario_forecast, #forecast_delta;
