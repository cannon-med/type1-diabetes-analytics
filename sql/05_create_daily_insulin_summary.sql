-- Create daily insulin summary table
CREATE OR REPLACE VIEW t1d.mart_patient_daily_insulin AS
SELECT
    patient_id,
    CAST(administration_timestamp AS DATE) AS insulin_date,
    COUNT(*) AS dose_count,
    AVG(dose_units) AS avg_dose,
    MIN(dose_units) AS min_dose,
    MAX(dose_units) AS max_dose,
    SUM(CASE WHEN delivery_method = 'pump' THEN 1 ELSE 0 END) AS pump_doses,
    SUM(CASE WHEN delivery_method = 'injection' THEN 1 ELSE 0 END) AS injection_doses
FROM t1d.fact_insulin
GROUP BY patient_id, CAST(administration_timestamp AS DATE);