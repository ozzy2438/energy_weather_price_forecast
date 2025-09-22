
-- Step 5: Unified Fact Table for Modeling (per 30-min, canonical fields, no dups)
-- Assumes canonical views from prior step (vw_qld1_canonical, vw_nsw1_canonical, vw_vic1_canonical)
-- Merge weather-engineered and market info
CREATE OR ALTER VIEW vw_fact_energy_market AS
SELECT
    m.SETTLEMENTDATE AS datetime,
    m.REGION AS region,
    w.hour,
    w.day_of_week,
    w.is_weekend,
    w.peak_period,
    w.temp_c,
    w.rh_pct,
    w.rain_mm,
    w.sunshine_sec,
    w.shortwave_wm2,
    w.wind_speed_ms,
    m.RRP,
    m.TOTALDEMAND,
    w.temp_bin,
    w.spike_flag,
    w.compound_highTemp_lowSolar_peakHour,
    w.RRP_lag_1h, w.RRP_lag_12h, w.RRP_lag_24h,
    w.TOTALDEMAND_lag_1h, w.TOTALDEMAND_lag_12h, w.TOTALDEMAND_lag_24h,
    w.RRP_rolling_3h, w.RRP_rolling_6h, w.RRP_rolling_24h,
    w.TOTALDEMAND_rolling_3h, w.TOTALDEMAND_rolling_6h, w.TOTALDEMAND_rolling_24h
FROM AEMO_PRICE_DEMAND m
LEFT JOIN (
    SELECT * FROM vw_weathermarket_canonical
) w
  ON CAST(m.SETTLEMENTDATE AS DATETIME) = CAST(w.datetime AS DATETIME)
 AND m.REGION = w.region;

-- Validate uniqueness/grain:
-- SELECT COUNT(*) - COUNT(DISTINCT datetime + '|' + region) FROM vw_fact_energy_market;
