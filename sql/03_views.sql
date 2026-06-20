USE ChurnDB;

--VIEWS

-- Overall Company Health Metrics
CREATE VIEW vw_overall_health AS
SELECT
COUNT(*) AS total_customers,
SUM(CASE WHEN churn_value = 1 THEN 1 ELSE 0 END) AS total_churned,
ROUND(SUM(CASE WHEN churn_value = 1 THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct,
ROUND(SUM(total_revenue), 2) AS total_revenue,
ROUND(SUM(CASE WHEN churn_value = 1 THEN revenue_at_risk ELSE 0 END), 2) AS total_revenue_at_risk,
ROUND(AVG(satisfaction_score * 1.0), 2) AS avg_satisfaction_score,
ROUND(AVG(cltv * 1.0), 2) AS avg_cltv
FROM fact_customers;

-- Churn by Contract Type
CREATE VIEW vw_churn_by_contract AS
SELECT
s.contract,
COUNT(*) AS total_customers,
SUM(CASE WHEN f.churn_value = 1 THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct,
ROUND(AVG(f.monthly_charge), 2) AS avg_monthly_charge,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN f.revenue_at_risk ELSE 0 END), 2) AS revenue_lost
FROM dim_services s
JOIN fact_customers f ON s.customer_id = f.customer_id
GROUP BY s.contract;

-- Churn by Internet Type
CREATE VIEW vw_churn_by_internet AS
SELECT
s.internet_type,
COUNT(*) AS total_customers,
SUM(CASE WHEN f.churn_value = 1 THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct,
ROUND(AVG(f.monthly_charge), 2) AS avg_monthly_charge,
ROUND(AVG(f.satisfaction_score * 1.0), 2) AS avg_satisfaction_score,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN f.revenue_at_risk ELSE 0 END), 2) AS revenue_lost
FROM dim_services s
JOIN fact_customers f ON s.customer_id = f.customer_id
GROUP BY s.internet_type;

-- Churn by Payment Method
CREATE VIEW vw_churn_by_payment AS
SELECT
s.payment_method,
COUNT(*) AS total_customers,
SUM(CASE WHEN f.churn_value = 1 THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct,
ROUND(AVG(f.monthly_charge), 2) AS avg_monthly_charge,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN f.revenue_at_risk ELSE 0 END), 2) AS revenue_lost
FROM dim_services s
JOIN fact_customers f ON s.customer_id = f.customer_id
GROUP BY s.payment_method;

-- Churn by Demographics
CREATE VIEW vw_churn_by_demographics AS
SELECT
CASE WHEN d.senior_citizen = 1 THEN 'Senior Citizen' ELSE 'Non-Senior' END AS age_group,
CASE WHEN d.dependents = 1 THEN 'Has Dependents' ELSE 'No Dependents' END AS dependent_status,
CASE WHEN d.partner = 1 THEN 'Has Partner' ELSE 'No Partner' END AS partner_status,
CASE WHEN d.married = 1 THEN 'Married' ELSE 'Not Married' END AS marital_status,
COUNT(*) AS total_customers,
SUM(CASE WHEN f.churn_value = 1 THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct,
ROUND(AVG(f.monthly_charge), 2) AS avg_monthly_charge
FROM dim_demographics d
JOIN fact_customers f ON d.customer_id = f.customer_id
GROUP BY d.senior_citizen, d.dependents, d.partner, d.married;

-- All Cities Churn
CREATE VIEW vw_churn_by_city AS
SELECT
l.city,
COUNT(*) AS total_customers,
SUM(CASE WHEN f.churn_value = 1 THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN f.revenue_at_risk ELSE 0 END), 2) AS revenue_lost,
AVG(l.latitude) AS latitude,
AVG(l.longitude) AS longitude
FROM dim_location l
JOIN fact_customers f ON l.customer_id = f.customer_id
GROUP BY l.city;

-- All Churn Reasons
CREATE VIEW vw_churn_reasons AS
SELECT
churn_reason,
churn_category,
COUNT(*) AS customer_count,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dim_status WHERE churn_value = 1), 2) AS pct_of_churned
FROM dim_status
WHERE churn_value = 1
GROUP BY churn_reason, churn_category;

-- Churn by Category with Revenue Impact
CREATE VIEW vw_churn_by_category AS
SELECT
st.churn_category,
COUNT(*) AS churned_customers,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dim_status WHERE churn_value = 1), 2) AS pct_of_churned,
ROUND(SUM(f.revenue_at_risk), 2) AS total_revenue_lost,
ROUND(AVG(f.cltv * 1.0), 2) AS avg_cltv,
ROUND(AVG(f.satisfaction_score * 1.0), 2) AS avg_satisfaction_score
FROM dim_status st
JOIN fact_customers f ON st.customer_id = f.customer_id
WHERE st.churn_value = 1
GROUP BY st.churn_category;

-- Churn by Tenure Bucket
CREATE VIEW vw_churn_by_tenure AS
SELECT
CASE
WHEN s.tenure_in_months BETWEEN 1 AND 6 THEN '1. 0-6 Months'
WHEN s.tenure_in_months BETWEEN 7 AND 12 THEN '2. 7-12 Months'
WHEN s.tenure_in_months BETWEEN 13 AND 24 THEN '3. 13-24 Months'
WHEN s.tenure_in_months BETWEEN 25 AND 36 THEN '4. 25-36 Months'
WHEN s.tenure_in_months BETWEEN 37 AND 48 THEN '5. 37-48 Months'
WHEN s.tenure_in_months BETWEEN 49 AND 60 THEN '6. 49-60 Months'
WHEN s.tenure_in_months BETWEEN 61 AND 72 THEN '7. 61-72 Months'
END AS tenure_bucket,
COUNT(*) AS total_customers,
SUM(CASE WHEN f.churn_value = 1 THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct,
ROUND(AVG(f.monthly_charge), 2) AS avg_monthly_charge
FROM dim_services s
JOIN fact_customers f ON s.customer_id = f.customer_id
GROUP BY
CASE
WHEN s.tenure_in_months BETWEEN 1 AND 6 THEN '1. 0-6 Months'
WHEN s.tenure_in_months BETWEEN 7 AND 12 THEN '2. 7-12 Months'
WHEN s.tenure_in_months BETWEEN 13 AND 24 THEN '3. 13-24 Months'
WHEN s.tenure_in_months BETWEEN 25 AND 36 THEN '4. 25-36 Months'
WHEN s.tenure_in_months BETWEEN 37 AND 48 THEN '5. 37-48 Months'
WHEN s.tenure_in_months BETWEEN 49 AND 60 THEN '6. 49-60 Months'
WHEN s.tenure_in_months BETWEEN 61 AND 72 THEN '7. 61-72 Months'
END;

-- High Value vs Low Value Churn
CREATE VIEW vw_churn_by_value_segment AS
SELECT
CASE WHEN f.is_high_value = 1 THEN 'High Value' ELSE 'Low Value' END AS customer_segment,
COUNT(*) AS total_customers,
SUM(CASE WHEN f.churn_value = 1 THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct,
ROUND(AVG(f.cltv * 1.0), 2) AS avg_cltv,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN f.revenue_at_risk ELSE 0 END), 2) AS revenue_lost
FROM fact_customers f
GROUP BY f.is_high_value;

-- Churn by Partner Status
CREATE VIEW vw_churn_by_partner AS
SELECT
CASE WHEN d.partner = 1 THEN 'Has Partner' ELSE 'No Partner' END AS partner_status,
COUNT(*) AS total_customers,
SUM(CASE WHEN f.churn_value = 1 THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct,
ROUND(AVG(f.monthly_charge), 2) AS avg_monthly_charge,
ROUND(AVG(f.satisfaction_score * 1.0), 2) AS avg_satisfaction_score,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN f.revenue_at_risk ELSE 0 END), 2) AS revenue_lost
FROM dim_demographics d
JOIN fact_customers f ON d.customer_id = f.customer_id
GROUP BY d.partner;

-- Verify all views created
SELECT TABLE_NAME AS view_name
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_CATALOG = 'ChurnDB'
ORDER BY TABLE_NAME;
