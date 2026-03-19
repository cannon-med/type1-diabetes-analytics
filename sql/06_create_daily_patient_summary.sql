-- Daily Patient Summary View: Aggregates daily glucose and insulin metrics per patient
-- Uses CTEs for glucose and insulin summaries, then joins them for complete daily view

CREATE OR REPLACE VIEW t1d.mart_daily_patient_summary AS
-- CTE: Calculate daily glucose statistics (avg, TIR, low/high counts)
WITH daily_glucose AS (
    SELECT
        patient_id,
        CAST(measurement_timestamp AS DATE) AS summary_date,
        AVG(glucose_mg_dl) AS avg_glucose,
        100.0 * SUM(CASE WHEN glucose_mg_dl BETWEEN 70 AND 180 THEN 1 ELSE 0 END) / COUNT(*) AS tir_pct,
        SUM(CASE WHEN glucose_mg_dl < 70 THEN 1 ELSE 0 END) AS low_reading_count,
        SUM(CASE WHEN glucose_mg_dl > 180 THEN 1 ELSE 0 END) AS high_reading_count
    FROM t1d.fact_glucose
    GROUP BY
        patient_id,
        CAST(measurement_timestamp AS DATE)
),
-- CTE: Calculate daily insulin totals (events, doses by type)
daily_insulin AS (
    SELECT
        patient_id,
        CAST(administration_timestamp AS DATE) AS summary_date,
        COUNT(*) AS insulin_event_count,
        SUM(dose_units) AS total_daily_dose_units,
        SUM(CASE WHEN insulin_type = 'Basal' THEN dose_units ELSE 0 END) AS total_basal_units,
        SUM(CASE WHEN insulin_type = 'Bolus' THEN dose_units ELSE 0 END) AS total_bolus_units
    FROM t1d.fact_insulin
    GROUP BY
        patient_id,
        CAST(administration_timestamp AS DATE)
)
-- Main query: Join glucose and insulin data, handle missing insulin with COALESCE
SELECT
    g.patient_id,
    g.summary_date,
    g.avg_glucose,
    g.tir_pct,
    g.low_reading_count,
    g.high_reading_count,
    COALESCE(i.insulin_event_count, 0) AS insulin_event_count,
    COALESCE(i.total_daily_dose_units, 0) AS total_daily_dose_units,
    COALESCE(i.total_basal_units, 0) AS total_basal_units,
    COALESCE(i.total_bolus_units, 0) AS total_bolus_units
FROM daily_glucose g
LEFT JOIN daily_insulin i
    ON g.patient_id = i.patient_id
   AND g.summary_date = i.summary_date;