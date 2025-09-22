
-- Step 3: Profiling/Outlier Detection (summary stats, IQR outliers, duplicate checks)

-- Duplicate Checks:
SELECT 'Brisbane_QLD1_merged' AS table_name, COUNT(*) AS total_rows,
       COUNT(*) - COUNT(DISTINCT datetime_utc + '|' + REGION) AS dup_count
  FROM Brisbane_QLD1_merged
UNION ALL
SELECT 'Sydney_NSW1_merged', COUNT(*),
       COUNT(*) - COUNT(DISTINCT datetime_utc + '|' + REGION)
  FROM Sydney_NSW1_merged
UNION ALL
SELECT 'Melbourne_VIC1_merged', COUNT(*),
       COUNT(*) - COUNT(DISTINCT datetime_utc + '|' + REGION)
  FROM Melbourne_VIC1_merged
UNION ALL
SELECT 'AEMO_PRICE_DEMAND', COUNT(*),
       COUNT(*) - COUNT(DISTINCT SETTLEMENTDATE + '|' + REGION)
  FROM AEMO_PRICE_DEMAND;

-- Descriptive Statistics for Markets/Weather (mean/std/min/max/IQR)
-- (Example for Brisbane QLD1 merged—you can adapt for any table/metric)
SELECT
    'Brisbane_QLD1_merged' AS table_name, 'temp_c' AS metric,
    COUNT(*) AS n, MIN(temp_c) AS min, MAX(temp_c) AS max, AVG(temp_c) AS mean,
    STDEV(temp_c) AS std,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY temp_c) OVER () AS q1,
    PERCENTILE_CONT(0.5)  WITHIN GROUP (ORDER BY temp_c) OVER () AS median,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY temp_c) OVER () AS q3
FROM Brisbane_QLD1_merged
UNION ALL
SELECT 'Brisbane_QLD1_merged', 'RRP', COUNT(*), MIN(RRP), MAX(RRP), AVG(RRP),
    STDEV(RRP),
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY RRP) OVER (),
    PERCENTILE_CONT(0.5)  WITHIN GROUP (ORDER BY RRP) OVER (),
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY RRP) OVER ()
FROM Brisbane_QLD1_merged;
-- Repeat/select for other columns and tables: rh_pct, rain_mm, shortwave_wm2, wind_speed_ms, TOTALDEMAND, etc.

-- IQR-Based Outlier Flag Example (Python logic: outlier if x < q1-1.5*IQR or x > q3+1.5*IQR)
-- Example: Outliers in temp_c for Brisbane:
WITH stats AS (
  SELECT 
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY temp_c) OVER () AS q1,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY temp_c) OVER () AS q3
  FROM Brisbane_QLD1_merged
)
SELECT COUNT(*) AS n_total,
       SUM(CASE WHEN temp_c < stats.q1 - 1.5 * (stats.q3 - stats.q1) OR temp_c > stats.q3 + 1.5 * (stats.q3 - stats.q1) THEN 1 ELSE 0 END) AS iqr_outliers
  FROM Brisbane_QLD1_merged, stats;

-- Adapt similar IQR outlier logic for RRP, TOTALDEMAND, wind_speed_ms, etc.
