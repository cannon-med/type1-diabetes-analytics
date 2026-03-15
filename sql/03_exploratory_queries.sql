/* daily avg glucose by patient */

SELECT 
	patient_id, 
	AVG(glucose_mg_dl) AS average_glucose
FROM t1d.fact_glucose
GROUP BY patient_id
ORDER BY patient_id;

SELECT 
	patient_id, 
	CAST(measurement_timestamp AS DATE) AS glucose_date,
	avg(glucose_mg_dl) AS glucose_daily_avg
FROM t1d.fact_glucose
GROUP BY CAST(measurement_timestamp AS DATE), patient_id
ORDER BY patient_id, cast(measurement_timestamp as date);