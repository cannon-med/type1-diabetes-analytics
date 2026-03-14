CREATE SCHEMA IF NOT EXISTS t1d;

CREATE TABLE IF NOT EXISTS t1d.dim_patient (
    patient_id INT PRIMARY KEY,
    sex VARCHAR(20),
    age_group VARCHAR(50),
    diabetes_duration_years INT,
    insulin_delivery_method VARCHAR(50),
    cgm_device_type VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS t1d.fact_glucose (
    measurement_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    measurement_timestamp TIMESTAMP NOT NULL,
    glucose_mg_dl NUMERIC(5,2) NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES t1d.dim_patient(patient_id)
);

