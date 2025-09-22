
-- Step 2: Null Value Analysis for All Input Tables
-- Shows column-wise null (IS NULL) counts and percentage for all primary tables

-- Utility: Macro for null stats (replace 'table_name' and 'col_list')
-- Runs per table, use in your SQL Server or save as a .sql file to share in portfolio
-- Example for Brisbane_QLD1_merged:
SELECT 
    'Brisbane_QLD1_merged' AS table_name, 
    COLUMN_NAME AS column_name,
    SUM(CASE WHEN [{COLUMN_NAME}] IS NULL THEN 1 ELSE 0 END) AS null_count,
    COUNT(*) AS total_rows,
    100.0 * SUM(CASE WHEN [{COLUMN_NAME}] IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS null_pct
FROM Brisbane_QLD1_merged
CROSS APPLY (
    SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_NAME = 'Brisbane_QLD1_merged'
) cols
GROUP BY COLUMN_NAME
UNION ALL
SELECT 'Sydney_NSW1_merged', COLUMN_NAME,
    SUM(CASE WHEN [{COLUMN_NAME}] IS NULL THEN 1 ELSE 0 END),
    COUNT(*),
    100.0 * SUM(CASE WHEN [{COLUMN_NAME}] IS NULL THEN 1 ELSE 0 END) / COUNT(*)
FROM Sydney_NSW1_merged
CROSS APPLY (
    SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Sydney_NSW1_merged'
) cols
GROUP BY COLUMN_NAME
UNION ALL
SELECT 'Melbourne_VIC1_merged', COLUMN_NAME,
    SUM(CASE WHEN [{COLUMN_NAME}] IS NULL THEN 1 ELSE 0 END),
    COUNT(*),
    100.0 * SUM(CASE WHEN [{COLUMN_NAME}] IS NULL THEN 1 ELSE 0 END) / COUNT(*)
FROM Melbourne_VIC1_merged
CROSS APPLY (
    SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Melbourne_VIC1_merged'
) cols
GROUP BY COLUMN_NAME
UNION ALL
SELECT 'AEMO_PRICE_DEMAND', COLUMN_NAME,
    SUM(CASE WHEN [{COLUMN_NAME}] IS NULL THEN 1 ELSE 0 END),
    COUNT(*),
    100.0 * SUM(CASE WHEN [{COLUMN_NAME}] IS NULL THEN 1 ELSE 0 END) / COUNT(*)
FROM AEMO_PRICE_DEMAND
CROSS APPLY (
    SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'AEMO_PRICE_DEMAND'
) cols
GROUP BY COLUMN_NAME;

-- Repeat above block for *_fe tables as needed, or for any specific table in your pipeline.
