CREATE DATABASE ChurnDB;

USE ChurnDB;

--DATABASE SCHEMA

-- Verify all raw files uploaded to DB
SELECT TABLE_NAME, 
(SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = t.TABLE_NAME AND TABLE_CATALOG = 'ChurnDB') AS column_count
FROM INFORMATION_SCHEMA.TABLES t
WHERE TABLE_CATALOG = 'ChurnDB'
ORDER BY TABLE_NAME;

-- NULL check for ALL columns in stg_demographics
SELECT
SUM(CASE WHEN [Customer ID] IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
SUM(CASE WHEN [Count] IS NULL THEN 1 ELSE 0 END) AS null_count,
SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS null_gender,
SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS null_age,
SUM(CASE WHEN [Under 30] IS NULL THEN 1 ELSE 0 END) AS null_under_30,
SUM(CASE WHEN [Senior Citizen] IS NULL THEN 1 ELSE 0 END) AS null_senior_citizen,
SUM(CASE WHEN Married IS NULL THEN 1 ELSE 0 END) AS null_married,
SUM(CASE WHEN Dependents IS NULL THEN 1 ELSE 0 END) AS null_dependents,
SUM(CASE WHEN [Number of Dependents] IS NULL THEN 1 ELSE 0 END) AS null_number_of_dependents
FROM stg_demographics;

-- NULL check for ALL columns in stg_location
SELECT
SUM(CASE WHEN [Customer ID] IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
SUM(CASE WHEN [Count] IS NULL THEN 1 ELSE 0 END) AS null_count,
SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS null_country,
SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS null_state,
SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS null_city,
SUM(CASE WHEN [Zip Code] IS NULL THEN 1 ELSE 0 END) AS null_zip_code,
SUM(CASE WHEN [Lat Long] IS NULL THEN 1 ELSE 0 END) AS null_lat_long,
SUM(CASE WHEN Latitude IS NULL THEN 1 ELSE 0 END) AS null_latitude,
SUM(CASE WHEN Longitude IS NULL THEN 1 ELSE 0 END) AS null_longitude
FROM stg_location;

-- NULL check for ALL columns in stg_services
SELECT
SUM(CASE WHEN [Customer ID] IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
SUM(CASE WHEN [Count] IS NULL THEN 1 ELSE 0 END) AS null_count,
SUM(CASE WHEN Quarter IS NULL THEN 1 ELSE 0 END) AS null_quarter,
SUM(CASE WHEN [Referred a Friend] IS NULL THEN 1 ELSE 0 END) AS null_referred_a_friend,
SUM(CASE WHEN [Number of Referrals] IS NULL THEN 1 ELSE 0 END) AS null_number_of_referrals,
SUM(CASE WHEN [Tenure in Months] IS NULL THEN 1 ELSE 0 END) AS null_tenure_in_months,
SUM(CASE WHEN Offer IS NULL THEN 1 ELSE 0 END) AS null_offer,
SUM(CASE WHEN [Phone Service] IS NULL THEN 1 ELSE 0 END) AS null_phone_service,
SUM(CASE WHEN [Avg Monthly Long Distance Charges] IS NULL THEN 1 ELSE 0 END) AS null_avg_monthly_ld_charges,
SUM(CASE WHEN [Multiple Lines] IS NULL THEN 1 ELSE 0 END) AS null_multiple_lines,
SUM(CASE WHEN [Internet Service] IS NULL THEN 1 ELSE 0 END) AS null_internet_service,
SUM(CASE WHEN [Internet Type] IS NULL THEN 1 ELSE 0 END) AS null_internet_type,
SUM(CASE WHEN [Avg Monthly GB Download] IS NULL THEN 1 ELSE 0 END) AS null_avg_monthly_gb,
SUM(CASE WHEN [Online Security] IS NULL THEN 1 ELSE 0 END) AS null_online_security,
SUM(CASE WHEN [Online Backup] IS NULL THEN 1 ELSE 0 END) AS null_online_backup,
SUM(CASE WHEN [Device Protection Plan] IS NULL THEN 1 ELSE 0 END) AS null_device_protection,
SUM(CASE WHEN [Premium Tech Support] IS NULL THEN 1 ELSE 0 END) AS null_premium_tech_support,
SUM(CASE WHEN [Streaming TV] IS NULL THEN 1 ELSE 0 END) AS null_streaming_tv,
SUM(CASE WHEN [Streaming Movies] IS NULL THEN 1 ELSE 0 END) AS null_streaming_movies,
SUM(CASE WHEN [Streaming Music] IS NULL THEN 1 ELSE 0 END) AS null_streaming_music,
SUM(CASE WHEN [Unlimited Data] IS NULL THEN 1 ELSE 0 END) AS null_unlimited_data,
SUM(CASE WHEN Contract IS NULL THEN 1 ELSE 0 END) AS null_contract,
SUM(CASE WHEN [Paperless Billing] IS NULL THEN 1 ELSE 0 END) AS null_paperless_billing,
SUM(CASE WHEN [Payment Method] IS NULL THEN 1 ELSE 0 END) AS null_payment_method,
SUM(CASE WHEN [Monthly Charge] IS NULL THEN 1 ELSE 0 END) AS null_monthly_charge,
SUM(CASE WHEN [Total Charges] IS NULL THEN 1 ELSE 0 END) AS null_total_charges,
SUM(CASE WHEN [Total Refunds] IS NULL THEN 1 ELSE 0 END) AS null_total_refunds,
SUM(CASE WHEN [Total Extra Data Charges] IS NULL THEN 1 ELSE 0 END) AS null_total_extra_data,
SUM(CASE WHEN [Total Long Distance Charges] IS NULL THEN 1 ELSE 0 END) AS null_total_ld_charges,
SUM(CASE WHEN [Total Revenue] IS NULL THEN 1 ELSE 0 END) AS null_total_revenue
FROM stg_services;

-- NULL check for ALL columns in stg_status
SELECT
SUM(CASE WHEN [Customer ID] IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
SUM(CASE WHEN [Count] IS NULL THEN 1 ELSE 0 END) AS null_count,
SUM(CASE WHEN Quarter IS NULL THEN 1 ELSE 0 END) AS null_quarter,
SUM(CASE WHEN [Satisfaction Score] IS NULL THEN 1 ELSE 0 END) AS null_satisfaction_score,
SUM(CASE WHEN [Customer Status] IS NULL THEN 1 ELSE 0 END) AS null_customer_status,
SUM(CASE WHEN [Churn Label] IS NULL THEN 1 ELSE 0 END) AS null_churn_label,
SUM(CASE WHEN [Churn Value] IS NULL THEN 1 ELSE 0 END) AS null_churn_value,
SUM(CASE WHEN [Churn Score] IS NULL THEN 1 ELSE 0 END) AS null_churn_score,
SUM(CASE WHEN CLTV IS NULL THEN 1 ELSE 0 END) AS null_cltv,
SUM(CASE WHEN [Churn Category] IS NULL THEN 1 ELSE 0 END) AS null_churn_category,
SUM(CASE WHEN [Churn Reason] IS NULL THEN 1 ELSE 0 END) AS null_churn_reason
FROM stg_status;

-- NULL check for ALL columns in stg_population
SELECT
SUM(CASE WHEN [Zip Code] IS NULL THEN 1 ELSE 0 END) AS null_zip_code,
SUM(CASE WHEN Population IS NULL THEN 1 ELSE 0 END) AS null_population
FROM stg_population;

-- Creating new table schema for clean data
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

-- Clean and insert values
INSERT INTO dim_demographics
SELECT
TRIM([Customer ID]) AS customer_id,
TRIM(UPPER(LEFT(Gender, 1)) + LOWER(SUBSTRING(Gender, 2, LEN(Gender)))) AS gender,
CAST(Age AS INT) AS age,
CASE WHEN TRIM([Under 30]) = 'Yes' THEN 1 ELSE 0 END AS under_30,
CASE WHEN TRIM([Senior Citizen]) = 'Yes' THEN 1 ELSE 0 END AS senior_citizen,
CASE WHEN TRIM(Married) = 'Yes' THEN 1 ELSE 0 END AS married,
CASE WHEN TRIM(Dependents) = 'Yes' THEN 1 ELSE 0 END AS dependents,
CAST([Number of Dependents] AS INT) AS number_of_dependents
FROM stg_demographics;

SELECT COUNT(*) AS dim_demographics_rows FROM dim_demographics;
SELECT TOP 5 * FROM dim_demographics;

INSERT INTO dim_location
SELECT
TRIM([Customer ID]) AS customer_id,
TRIM(City) AS city,
CAST([Zip Code] AS VARCHAR(10)) AS zip_code,
CAST(Latitude AS FLOAT) AS latitude,
CAST(Longitude AS FLOAT) AS longitude
FROM stg_location;

SELECT COUNT(*) AS dim_location_rows FROM dim_location;
SELECT TOP 5 * FROM dim_location;

INSERT INTO dim_services
SELECT
TRIM([Customer ID]) AS customer_id,
CAST([Tenure in Months] AS INT) AS tenure_in_months,
ISNULL(TRIM(Offer), 'No Offer') AS offer,
CASE WHEN TRIM([Phone Service]) = 'Yes' THEN 1 ELSE 0 END AS phone_service,
CASE WHEN TRIM([Multiple Lines]) = 'Yes' THEN 1 ELSE 0 END AS multiple_lines,
CASE WHEN TRIM([Internet Service]) = 'Yes' THEN 1 ELSE 0 END AS internet_service,
ISNULL(TRIM([Internet Type]), 'No Internet') AS internet_type,
CAST([Avg Monthly GB Download] AS INT) AS avg_monthly_gb_download,
CAST([Avg Monthly Long Distance Charges] AS FLOAT) AS avg_monthly_long_distance_charges,
CASE WHEN TRIM([Online Security]) = 'Yes' THEN 1 ELSE 0 END AS online_security,
CASE WHEN TRIM([Online Backup]) = 'Yes' THEN 1 ELSE 0 END AS online_backup,
CASE WHEN TRIM([Device Protection Plan]) = 'Yes' THEN 1 ELSE 0 END AS device_protection_plan,
CASE WHEN TRIM([Premium Tech Support]) = 'Yes' THEN 1 ELSE 0 END AS premium_tech_support,
CASE WHEN TRIM([Streaming TV]) = 'Yes' THEN 1 ELSE 0 END AS streaming_tv,
CASE WHEN TRIM([Streaming Movies]) = 'Yes' THEN 1 ELSE 0 END AS streaming_movies,
CASE WHEN TRIM([Streaming Music]) = 'Yes' THEN 1 ELSE 0 END AS streaming_music,
CASE WHEN TRIM([Unlimited Data]) = 'Yes' THEN 1 ELSE 0 END AS unlimited_data,
TRIM(Contract) AS contract,
CASE WHEN TRIM([Paperless Billing]) = 'Yes' THEN 1 ELSE 0 END AS paperless_billing,
TRIM([Payment Method]) AS payment_method,
CASE WHEN TRIM([Referred a Friend]) = 'Yes' THEN 1 ELSE 0 END AS referred_a_friend,
CAST([Number of Referrals] AS INT) AS number_of_referrals
FROM stg_services;

SELECT COUNT(*) AS dim_services_rows FROM dim_services;
SELECT TOP 5 * FROM dim_services;

INSERT INTO dim_status
SELECT
TRIM([Customer ID]) AS customer_id,
CAST([Satisfaction Score] AS INT) AS satisfaction_score,
TRIM([Customer Status]) AS customer_status,
CAST([Churn Value] AS INT) AS churn_value,
CAST([Churn Score] AS INT) AS churn_score,
ISNULL(TRIM([Churn Category]), 'Not Applicable') AS churn_category,
ISNULL(TRIM([Churn Reason]), 'Not Applicable') AS churn_reason
FROM stg_status;

SELECT COUNT(*) AS dim_status_rows FROM dim_status;
SELECT TOP 5 * FROM dim_status;

INSERT INTO fact_customers
SELECT
TRIM(sv.[Customer ID]) AS customer_id,
CAST(sv.[Monthly Charge] AS FLOAT) AS monthly_charge,
CAST(sv.[Total Charges] AS FLOAT) AS total_charges,
CAST(sv.[Total Refunds] AS FLOAT) AS total_refunds,
CAST(sv.[Total Extra Data Charges] AS INT) AS total_extra_data_charges,
CAST(sv.[Total Long Distance Charges] AS FLOAT) AS total_long_distance_charges,
CAST(sv.[Total Revenue] AS FLOAT) AS total_revenue,
CAST(st.CLTV AS INT) AS cltv,
CAST(st.[Churn Value] AS INT) AS churn_value,
CAST(st.[Satisfaction Score] AS INT) AS satisfaction_score,
CAST(sv.[Monthly Charge] AS FLOAT) * 12 AS revenue_at_risk,
CASE
WHEN CAST(sv.[Tenure in Months] AS INT) > 0
THEN ROUND(CAST(sv.[Total Revenue] AS FLOAT) / CAST(sv.[Tenure in Months] AS INT), 2)
ELSE CAST(sv.[Monthly Charge] AS FLOAT)
END AS avg_monthly_revenue,
CASE
WHEN CAST(st.CLTV AS INT) > (SELECT AVG(CAST(CLTV AS INT)) FROM stg_status)
THEN 1 ELSE 0
END AS is_high_value
FROM stg_services sv
JOIN stg_status st ON TRIM(sv.[Customer ID]) = TRIM(st.[Customer ID]);

SELECT COUNT(*) AS fact_customers_rows FROM fact_customers;
SELECT TOP 5 * FROM fact_customers;

-- Add an important column missing from the cleaned database
-- Add partner column to dim_demographics
ALTER TABLE dim_demographics
ADD partner INT;

-- Update from stg_main
UPDATE dim_demographics
SET partner = CASE WHEN TRIM(m.Partner) = 'Yes' THEN 1 ELSE 0 END
FROM dim_demographics d
JOIN stg_main m ON TRIM(d.customer_id) = TRIM(m.[Customer ID]);

-- Verify
SELECT TOP 5 customer_id, gender, age, senior_citizen, married, partner, dependents
FROM dim_demographics;

SELECT
SUM(CASE WHEN partner = 1 THEN 1 ELSE 0 END) AS has_partner,
SUM(CASE WHEN partner = 0 THEN 1 ELSE 0 END) AS no_partner
FROM dim_demographics;

-- Adding foreign keys
ALTER TABLE fact_customers
ADD CONSTRAINT fk_fact_location
FOREIGN KEY (customer_id) REFERENCES dim_location(customer_id);

ALTER TABLE fact_customers
ADD CONSTRAINT fk_fact_services
FOREIGN KEY (customer_id) REFERENCES dim_services(customer_id);

ALTER TABLE fact_customers
ADD CONSTRAINT fk_fact_status
FOREIGN KEY (customer_id) REFERENCES dim_status(customer_id);

-- Verify
SELECT
fk.name AS constraint_name,
tp.name AS parent_table,
tr.name AS referenced_table
FROM sys.foreign_keys fk
JOIN sys.tables tp ON fk.parent_object_id = tp.object_id
JOIN sys.tables tr ON fk.referenced_object_id = tr.object_id
WHERE tp.name = 'fact_customers';

