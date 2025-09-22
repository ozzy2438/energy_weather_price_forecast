
-- Step 4: Canonical Schema, Dimensions, Metrics, Derived Bins/Flags
-- Example: a canonical view for QLD1 feature engineering table
Go
CREATE OR ALTER VIEW vw_qld1_canonical AS
SELECT
    datetime_utc AS datetime,
    'QLD1' AS region,
    date,
    hour,
    dow AS day_of_week,
    CAST(is_weekend AS INT) AS is_weekend,
    CASE WHEN hour BETWEEN 17 AND 21 THEN 'peak' WHEN hour BETWEEN 11 AND 14 THEN 'off-peak' ELSE 'other' END AS peak_period,
    temp_c,
    rh_pct,
    rain_mm,
    sunshine_sec,
    shortwave_wm2,
    wind_speed_ms,
    RRP,
    TOTALDEMAND,
    temp_bin,
    -- Derived bins/flags (example logic, update thresholds per need)
    CASE WHEN temp_c >= 30 THEN '30+' WHEN temp_c >= 25 THEN '25-30' WHEN temp_c >= 20 THEN '20-25' ELSE '<20' END AS temp_bin2,
    CASE WHEN shortwave_wm2 >= 800 THEN 'high' WHEN shortwave_wm2 >= 400 THEN 'mid' ELSE 'low' END AS solar_bin,
    CASE WHEN wind_speed_ms >= 10 THEN 'high' WHEN wind_speed_ms >= 5 THEN 'mid' ELSE 'low' END AS wind_bin,
    CASE WHEN RRP > 100 THEN 1 ELSE 0 END AS spike_flag,
    CASE WHEN temp_c > 28 AND shortwave_wm2 < 150 AND (hour BETWEEN 17 AND 21) THEN 1 ELSE 0 END AS compound_highTemp_lowSolar_peakHour,
    RRP_lag_1h, RRP_lag_12h, RRP_lag_24h,
    TOTALDEMAND_lag_1h, TOTALDEMAND_lag_12h, TOTALDEMAND_lag_24h,
    RRP_rolling_3h, RRP_rolling_6h, RRP_rolling_24h,
    TOTALDEMAND_rolling_3h, TOTALDEMAND_rolling_6h, TOTALDEMAND_rolling_24h
FROM Brisbane_QLD1_fe;
-- Repeat/adapt for Sydney_NSW1_fe, Melbourne_VIC1_fe with region, table swaps.

-- To unify, create a master view/union after mapping regions (all views to have same columns/units):
CREATE OR ALTER VIEW vw_weathermarket_canonical AS
SELECT * FROM vw_qld1_canonical
UNION ALL
SELECT * FROM vw_nsw1_canonical
UNION ALL
SELECT * FROM vw_vic1_canonical;
