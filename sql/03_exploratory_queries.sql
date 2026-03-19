/* Average glucose by patient */
SELECT 
	patient_id, 
	AVG(glucose_mg_dl) AS average_glucose
FROM t1d.fact_glucose
GROUP BY patient_id
ORDER BY patient_id;

/* Average daily glucose by patient*/
SELECT 
	patient_id, 
	CAST(measurement_timestamp AS DATE) AS glucose_date,
	avg(glucose_mg_dl) AS glucose_daily_avg
FROM t1d.fact_glucose
GROUP BY CAST(measurement_timestamp AS DATE), patient_id
ORDER BY patient_id, glucose_date;

/* Count insulin doses by Patient*/
SELECT 
	patient_id, 
	COUNT(insulin_event_id) AS insulin_dose_count
FROM t1d.fact_insulin
GROUP BY patient_id
ORDER BY patient_id;

/* Average insulin dose by Patient*/
SELECT 
    patient_id, 
    AVG(dose_units) AS average_insulin_dose
FROM t1d.fact_insulin
GROUP BY patient_id
ORDER BY average_insulin_dose DESC;