
-- Step 7: Business KPI analysis: spike events, DR triggers, battery windows, ROI, action counts
-- Assumes all scenario deltas and forecasts are exported for Power BI; this script produces summary tables

-- Price spike event count ($100/MWh)
SELECT region, COUNT(*) AS spike_events
  FROM vw_fact_energy_market
 WHERE RRP > 100
GROUP BY region;

-- Battery charge/discharge windows (example: charge < $30, discharge > $70; edit for scenario/delta)
SELECT region,
       SUM(CASE WHEN RRP < 30 THEN 1 ELSE 0 END) AS battery_charge_events,
       SUM(CASE WHEN RRP > 70 THEN 1 ELSE 0 END) AS battery_discharge_events
  FROM vw_fact_energy_market
GROUP BY region;

-- DR savings estimation: count periods above price threshold, sum delta price (Python needed for forecast deltas, use export)
-- For deltas, reference scenario_delta.csv or db staging table if loaded
-- ROI/Value summary table example:
SELECT region,
   COUNT(CASE WHEN RRP > 100 THEN 1 END) AS baseline_spikes,
   AVG(RRP) AS avg_price,
   AVG(TOTALDEMAND) AS avg_load,
   COUNT(CASE WHEN temp_c > 28 AND shortwave_wm2 < 150 AND hour BETWEEN 17 AND 21 THEN 1 END) AS compound_risk_events
FROM vw_fact_energy_market
GROUP BY region;

-- For Power BI: export above outputs using SELECT ... INTO, then export to CSV as needed.
-- For Python scenario deltas: import CSVs as table/view, and run same aggregates as above for scenario column(s).
