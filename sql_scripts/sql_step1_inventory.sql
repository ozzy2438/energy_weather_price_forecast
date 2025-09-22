
-- Step 1: Table Inventory & Profiling (row counts and date ranges)

-- 1. Brisbane merged table
SELECT 'Brisbane_QLD1_merged' as table_name, COUNT(*) as row_count,
       MIN(datetime_utc) as min_date, MAX(datetime_utc) as max_date
  FROM Brisbane_QLD1_merged
UNION ALL
SELECT 'Sydney_NSW1_merged', COUNT(*), MIN(datetime_utc), MAX(datetime_utc)
  FROM Sydney_NSW1_merged
UNION ALL
SELECT 'Melbourne_VIC1_merged', COUNT(*), MIN(datetime_utc), MAX(datetime_utc)
  FROM Melbourne_VIC1_merged
UNION ALL
SELECT 'AEMO_PRICE_DEMAND', COUNT(*), MIN(SETTLEMENTDATE), MAX(SETTLEMENTDATE)
  FROM AEMO_PRICE_DEMAND
UNION ALL
SELECT 'Brisbane_QLD1_fe', COUNT(*), MIN(datetime_utc), MAX(datetime_utc)
  FROM Brisbane_QLD1_fe
UNION ALL
SELECT 'Sydney_NSW1_fe', COUNT(*), MIN(datetime_utc), MAX(datetime_utc)
  FROM Sydney_NSW1_fe
UNION ALL
SELECT 'Melbourne_VIC1_fe', COUNT(*), MIN(datetime_utc), MAX(datetime_utc)
  FROM Melbourne_VIC1_fe;

-- For ERD/joining logic:
-- See doc comments in SQL or submit your own ERD diagram based on the keys
