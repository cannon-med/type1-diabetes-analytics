CREATE OR REPLACE VIEW t1d.mart_patient_daily_glucose AS
SELECT
    patient_id,
    CAST(measurement_timestamp AS DATE) AS glucose_date,
    COUNT(*) AS reading_count,
    AVG(glucose_mg_dl) AS avg_glucose,
    MIN(glucose_mg_dl) AS min_glucose,
    MAX(glucose_mg_dl) AS max_glucose,
    100.0 * SUM(CASE WHEN glucose_mg_dl BETWEEN 70 AND 180 THEN 1 ELSE 0 END) / COUNT(*) AS tir_pct,
    SUM(CASE WHEN glucose_mg_dl < 70 THEN 1 ELSE 0 END) AS low_reading_count,
    SUM(CASE WHEN glucose_mg_dl > 180 THEN 1 ELSE 0 END) AS high_reading_count
FROM
    t1d.fact_glucose
GROUP BY
    patient_id,
    CAST(measurement_timestamp AS DATE);