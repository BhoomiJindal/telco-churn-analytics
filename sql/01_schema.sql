CREATE DATABASE ChurnDB;

USE ChurnDB;

--DATABASE SCHEMA

--Verify the tables have been successfully imported
SELECT COUNT(*) AS total_rows FROM stg_churn;

--Create structure for tables to work on
CREATE TABLE dim_demographics (
customer_id VARCHAR(20) PRIMARY KEY,
gender VARCHAR(10),
age INT,
under_30 INT,
senior_citizen INT,
married INT,
dependents INT,
number_of_dependents INT
);

CREATE TABLE dim_location (
customer_id VARCHAR(20) PRIMARY KEY,
city VARCHAR(100),
zip_code VARCHAR(10),
latitude FLOAT,
longitude FLOAT
);

CREATE TABLE dim_services (
customer_id VARCHAR(20) PRIMARY KEY,
tenure_in_months INT,
offer VARCHAR(50),
phone_service INT,
multiple_lines INT,
internet_service INT,
internet_type VARCHAR(50),
avg_monthly_gb_download INT,
avg_monthly_long_distance_charges FLOAT,
online_security INT,
online_backup INT,
device_protection_plan INT,
premium_tech_support INT,
streaming_tv INT,
streaming_movies INT,
streaming_music INT,
unlimited_data INT,
contract VARCHAR(20),
paperless_billing INT,
payment_method VARCHAR(50),
referred_a_friend INT,
number_of_referrals INT
);

CREATE TABLE dim_status (
customer_id VARCHAR(20) PRIMARY KEY,
satisfaction_score INT,
customer_status VARCHAR(20),
churn_value INT,
churn_score INT,
churn_category VARCHAR(50),
churn_reason VARCHAR(100)
);

CREATE TABLE fact_customers (
customer_id VARCHAR(20) PRIMARY KEY,
monthly_charge FLOAT,
total_charges FLOAT,
total_refunds FLOAT,
total_extra_data_charges INT,
total_long_distance_charges FLOAT,
total_revenue FLOAT,
cltv INT,
churn_value INT,
satisfaction_score INT,
revenue_at_risk FLOAT,
avg_monthly_revenue FLOAT,
is_high_value INT,
FOREIGN KEY (customer_id) REFERENCES dim_demographics(customer_id)
);

--Add foreign keys
ALTER TABLE fact_customers
ADD CONSTRAINT fk_fact_location
FOREIGN KEY (customer_id) REFERENCES dim_location(customer_id);

ALTER TABLE fact_customers
ADD CONSTRAINT fk_fact_services
FOREIGN KEY (customer_id) REFERENCES dim_services(customer_id);

ALTER TABLE fact_customers
ADD CONSTRAINT fk_fact_status
FOREIGN KEY (customer_id) REFERENCES dim_status(customer_id);

--Verify the created schema
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_CATALOG = 'ChurnDB' 
ORDER BY TABLE_NAME;

--Insert information into the tables
--CAST is used to convert one data type to another
INSERT INTO dim_demographics
SELECT customer_id, gender, CAST(age AS INT), CAST(under_30 AS INT), CAST(senior_citizen AS INT), CAST(married AS INT), CAST(dependents AS INT), CAST(number_of_dependents AS INT)
FROM stg_churn;

INSERT INTO dim_location
SELECT customer_id, city, zip_code, CAST(latitude AS FLOAT), CAST(longitude AS FLOAT)
FROM stg_churn;

INSERT INTO dim_services
SELECT customer_id, CAST(tenure_in_months AS INT), offer, CAST(phone_service AS INT), CAST(multiple_lines AS INT), CAST(internet_service AS INT), internet_type, CAST(avg_monthly_gb_download AS INT), CAST(avg_monthly_long_distance_charges AS FLOAT), CAST(online_security AS INT), CAST(online_backup AS INT), CAST(device_protection_plan AS INT), CAST(premium_tech_support AS INT), CAST(streaming_tv AS INT), CAST(streaming_movies AS INT), CAST(streaming_music AS INT), CAST(unlimited_data AS INT), contract, CAST(paperless_billing AS INT), payment_method, CAST(referred_a_friend AS INT), CAST(number_of_referrals AS INT)
FROM stg_churn;

INSERT INTO dim_status
SELECT customer_id, CAST(satisfaction_score AS INT), customer_status, CAST(churn_value AS INT), CAST(churn_score AS INT), churn_category, churn_reason
FROM stg_churn;

INSERT INTO fact_customers
SELECT customer_id, CAST(monthly_charge AS FLOAT), CAST(total_charges AS FLOAT), CAST(total_refunds AS FLOAT), CAST(total_extra_data_charges AS INT), CAST(total_long_distance_charges AS FLOAT), CAST(total_revenue AS FLOAT), CAST(cltv AS INT), CAST(churn_value AS INT), CAST(satisfaction_score AS INT), CAST(revenue_at_risk AS FLOAT), CAST(avg_monthly_revenue AS FLOAT), CAST(is_high_value AS INT)
FROM stg_churn;

--Verify the data is inserted into the tables correctly
SELECT 'dim_demographics' AS table_name, COUNT(*) AS row_count 
FROM dim_demographics
UNION ALL
SELECT 'dim_location', COUNT(*) 
FROM dim_location
UNION ALL
SELECT 'dim_services', COUNT(*) 
FROM dim_services
UNION ALL
SELECT 'dim_status', COUNT(*) 
FROM dim_status
UNION ALL
SELECT 'fact_customers', COUNT(*) 
FROM fact_customers;

--Verify all the tables link correctly through customer_id using JOIN query
SELECT TOP 5 d.customer_id, d.gender, d.age, l.city, s.contract, s.internet_type, st.customer_status, f.monthly_charge, f.cltv
FROM dim_demographics d
JOIN dim_location l ON d.customer_id = l.customer_id
JOIN dim_services s ON d.customer_id = s.customer_id
JOIN dim_status st ON d.customer_id = st.customer_id
JOIN fact_customers f ON d.customer_id = f.customer_id;
