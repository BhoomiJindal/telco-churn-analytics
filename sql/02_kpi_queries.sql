USE ChurnDB;

--KPI QUERIES

--Overall health check
SELECT
COUNT(*) AS total_customers,
SUM(CASE WHEN churn_value = 1 THEN 1 ELSE 0 END) AS total_churned,
ROUND(SUM(CASE WHEN churn_value = 1 THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct,
ROUND(SUM(total_revenue), 2) AS total_revenue,
ROUND(SUM(CASE WHEN churn_value = 1 THEN revenue_at_risk ELSE 0 END), 2) AS total_revenue_at_risk
FROM fact_customers;

--Revenue retained vs revenue lost
SELECT
f.churn_value,
CASE WHEN f.churn_value = 1 THEN 'Churned' ELSE 'Stayed/Joined' END AS status,
COUNT(*) AS customer_count,
ROUND(SUM(f.total_revenue), 2) AS revenue_total,
ROUND(SUM(f.total_revenue) * 100.0 / (SELECT SUM(total_revenue) FROM fact_customers), 2) AS pct_of_total_revenue
FROM fact_customers f
GROUP BY f.churn_value;

--Average CLTV and Satisfaction Score: Churned vs Stayed
SELECT
f.churn_value,
CASE WHEN f.churn_value = 1 THEN 'Churned' ELSE 'Stayed/Joined' END AS status,
COUNT(*) AS customer_count,
ROUND(AVG(f.cltv * 1.0), 2) AS avg_cltv,
ROUND(AVG(f.satisfaction_score * 1.0), 2) AS avg_satisfaction_score,
ROUND(AVG(f.monthly_charge), 2) AS avg_monthly_charge,
ROUND(AVG(f.total_revenue), 2) AS avg_total_revenue
FROM fact_customers f
GROUP BY f.churn_value;

--Churn Rate by Contract Type
SELECT
s.contract,
COUNT(*) AS total_customers,
SUM(CASE WHEN f.churn_value = 1 THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct,
ROUND(AVG(f.monthly_charge), 2) AS avg_monthly_charge,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN f.revenue_at_risk ELSE 0 END), 2) AS revenue_lost
FROM dim_services s
JOIN fact_customers f ON s.customer_id = f.customer_id
GROUP BY s.contract
ORDER BY churn_rate_pct DESC;

--Churn Rate by Internet Type
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
GROUP BY s.internet_type
ORDER BY churn_rate_pct DESC;

--Churn Rate by Payment Method
SELECT
s.payment_method,
COUNT(*) AS total_customers,
SUM(CASE WHEN f.churn_value = 1 THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct,
ROUND(AVG(f.monthly_charge), 2) AS avg_monthly_charge,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN f.revenue_at_risk ELSE 0 END), 2) AS revenue_lost
FROM dim_services s
JOIN fact_customers f ON s.customer_id = f.customer_id
GROUP BY s.payment_method
ORDER BY churn_rate_pct DESC;

--Churn Rate by Senior Citizens and Dependants Status
SELECT
CASE WHEN d.senior_citizen = 1 THEN 'Senior Citizen' ELSE 'Non-Senior' END AS age_group,
CASE WHEN d.dependents = 1 THEN 'Has Dependents' ELSE 'No Dependents' END AS dependent_status,
COUNT(*) AS total_customers,
SUM(CASE WHEN f.churn_value = 1 THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct,
ROUND(AVG(f.monthly_charge), 2) AS avg_monthly_charge
FROM dim_demographics d
JOIN fact_customers f ON d.customer_id = f.customer_id
GROUP BY d.senior_citizen, d.dependents
ORDER BY churn_rate_pct DESC;

--Top 10 cities by Churn Rate
SELECT
l.city,
COUNT(*) AS total_customers,
SUM(CASE WHEN f.churn_value = 1 THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN f.revenue_at_risk ELSE 0 END), 2) AS revenue_lost
FROM dim_location l
JOIN fact_customers f ON l.customer_id = f.customer_id
GROUP BY l.city
HAVING COUNT(*) >= 20
ORDER BY churn_rate_pct DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

--Top 10 Churn Reasons with Count and Percentage
SELECT
churn_reason,
COUNT(*) AS customer_count,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dim_status WHERE churn_value = 1), 2) AS pct_of_churned
FROM dim_status
WHERE churn_value = 1
GROUP BY churn_reason
ORDER BY customer_count DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

--Churn by Category with Revenue Impact
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
GROUP BY st.churn_category
ORDER BY churned_customers DESC;

--Revenue at risk from active month-to-month customers
SELECT
s.contract,
COUNT(*) AS active_customers,
ROUND(SUM(f.revenue_at_risk), 2) AS total_annual_revenue_at_risk,
ROUND(AVG(f.monthly_charge), 2) AS avg_monthly_charge,
ROUND(AVG(f.cltv * 1.0), 2) AS avg_cltv,
ROUND(SUM(f.monthly_charge), 2) AS total_monthly_revenue,
ROUND(SUM(f.revenue_at_risk) / COUNT(*), 2) AS avg_revenue_at_risk_per_customer
FROM dim_services s
JOIN fact_customers f ON s.customer_id = f.customer_id
JOIN dim_status st ON s.customer_id = st.customer_id
WHERE st.customer_status = 'Stayed'
AND s.contract = 'Month-to-Month'
GROUP BY s.contract;

--High value vs Low value Customer Churn comparison
SELECT
f.is_high_value,
CASE WHEN f.is_high_value = 1 THEN 'High Value' ELSE 'Low Value' END AS customer_segment,
COUNT(*) AS total_customers,
SUM(CASE WHEN f.churn_value = 1 THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct,
ROUND(AVG(f.cltv * 1.0), 2) AS avg_cltv,
ROUND(AVG(f.satisfaction_score * 1.0), 2) AS avg_satisfaction_score,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN f.revenue_at_risk ELSE 0 END), 2) AS revenue_lost,
ROUND(AVG(CASE WHEN f.churn_value = 1 THEN f.monthly_charge END), 2) AS avg_monthly_charge_churned
FROM fact_customers f
GROUP BY f.is_high_value
ORDER BY churn_rate_pct DESC;

--Top 20 highest CLTV customers who already churned
SELECT
f.customer_id,
d.gender,
d.age,
d.senior_citizen,
l.city,
s.contract,
s.internet_type,
s.tenure_in_months,
st.churn_reason,
st.churn_category,
ROUND(f.cltv * 1.0, 2) AS cltv,
ROUND(f.monthly_charge, 2) AS monthly_charge,
ROUND(f.total_revenue, 2) AS total_revenue,
ROUND(f.satisfaction_score * 1.0, 2) AS satisfaction_score
FROM fact_customers f
JOIN dim_demographics d ON f.customer_id = d.customer_id
JOIN dim_location l ON f.customer_id = l.customer_id
JOIN dim_services s ON f.customer_id = s.customer_id
JOIN dim_status st ON f.customer_id = st.customer_id
WHERE f.churn_value = 1
ORDER BY f.cltv DESC
OFFSET 0 ROWS FETCH NEXT 20 ROWS ONLY;

--Churn Rate by Tenure Bucket
WITH tenure_buckets AS (
SELECT
f.customer_id,
f.churn_value,
f.monthly_charge,
CASE
WHEN s.tenure_in_months BETWEEN 1 AND 6 THEN '1. 0-6 Months'
WHEN s.tenure_in_months BETWEEN 7 AND 12 THEN '2. 7-12 Months'
WHEN s.tenure_in_months BETWEEN 13 AND 24 THEN '3. 13-24 Months'
WHEN s.tenure_in_months BETWEEN 25 AND 36 THEN '4. 25-36 Months'
WHEN s.tenure_in_months BETWEEN 37 AND 48 THEN '5. 37-48 Months'
WHEN s.tenure_in_months BETWEEN 49 AND 60 THEN '6. 49-60 Months'
WHEN s.tenure_in_months BETWEEN 61 AND 72 THEN '7. 61-72 Months'
END AS tenure_bucket
FROM fact_customers f
JOIN dim_services s ON f.customer_id = s.customer_id
)
SELECT
tenure_bucket,
COUNT(*) AS total_customers,
SUM(CASE WHEN churn_value = 1 THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN churn_value = 1 THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct,
ROUND(AVG(monthly_charge), 2) AS avg_monthly_charge
FROM tenure_buckets
GROUP BY tenure_bucket
ORDER BY tenure_bucket;

--Running total of churned customers by Tenure
WITH tenure_buckets AS (
SELECT
f.customer_id,
f.churn_value,
CASE
WHEN s.tenure_in_months BETWEEN 1 AND 6 THEN '1. 0-6 Months'
WHEN s.tenure_in_months BETWEEN 7 AND 12 THEN '2. 7-12 Months'
WHEN s.tenure_in_months BETWEEN 13 AND 24 THEN '3. 13-24 Months'
WHEN s.tenure_in_months BETWEEN 25 AND 36 THEN '4. 25-36 Months'
WHEN s.tenure_in_months BETWEEN 37 AND 48 THEN '5. 37-48 Months'
WHEN s.tenure_in_months BETWEEN 49 AND 60 THEN '6. 49-60 Months'
WHEN s.tenure_in_months BETWEEN 61 AND 72 THEN '7. 61-72 Months'
END AS tenure_bucket
FROM fact_customers f
JOIN dim_services s ON f.customer_id = s.customer_id
),
bucket_summary AS (
SELECT
tenure_bucket,
COUNT(*) AS total_customers,
SUM(CASE WHEN churn_value = 1 THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN churn_value = 1 THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM tenure_buckets
GROUP BY tenure_bucket
)
SELECT
tenure_bucket,
total_customers,
churned_customers,
churn_rate_pct,
SUM(churned_customers) OVER (ORDER BY tenure_bucket) AS running_total_churned,
ROUND(SUM(churned_customers) OVER (ORDER BY tenure_bucket) * 100.0 / SUM(churned_customers) OVER (), 2) AS cumulative_pct_of_total_churn
FROM bucket_summary
ORDER BY tenure_bucket;

--Rank cities by churn rate
WITH city_churn AS (
SELECT
l.city,
COUNT(*) AS total_customers,
SUM(CASE WHEN f.churn_value = 1 THEN 1 ELSE 0 END) AS churned_customers,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_pct,
ROUND(SUM(CASE WHEN f.churn_value = 1 THEN f.revenue_at_risk ELSE 0 END), 2) AS revenue_lost
FROM dim_location l
JOIN fact_customers f ON l.customer_id = f.customer_id
GROUP BY l.city
HAVING COUNT(*) >= 20
),
ranked_cities AS (
SELECT
city,
total_customers,
churned_customers,
churn_rate_pct,
revenue_lost,
RANK() OVER (ORDER BY churn_rate_pct DESC) AS churn_rank,
RANK() OVER (ORDER BY revenue_lost DESC) AS revenue_rank
FROM city_churn
)
SELECT
churn_rank,
revenue_rank,
city,
total_customers,
churned_customers,
churn_rate_pct,
revenue_lost
FROM ranked_cities
ORDER BY churn_rank
OFFSET 0 ROWS FETCH NEXT 15 ROWS ONLY;
