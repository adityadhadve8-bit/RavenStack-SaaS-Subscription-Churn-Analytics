------------------------------------------------
-- RAVENSTACK SAAS SUBSCRIPTION ANALYTICS  --
------------------------------------------------


------------------------------------------------
-- Project Description
------------------------------------------------

/*
RavenStack is a Software-as-a-Service (SaaS) company that provides subscription-based software solutions to businesses worldwide. 
As the customer base grows, management requires a centralized analytics dashboard to monitor revenue, customer growth, subscription performance, product usage, and churn trends.
This project develops an end-to-end Business Intelligence solution using PostgreSQL for data analysis and Power BI for interactive visualization.
The dashboard enables stakeholders to monitor key business metrics, identify growth opportunities, detect customer churn, and make data-driven decisions.
*/




--------------------------------------------------
--Project Objectives
--------------------------------------------------
/*
The primary objectives were to:

- Analyze Monthly Recurring Revenue (MRR) and Annual Recurring Revenue (ARR).
- Track customer acquisition and churn.
- Measure subscription plan performance.
- Analyze feature adoption and product engagement.
- Identify high-value customers.
- Monitor customer retention.
- Evaluate billing and renewal behavior.
- Build an interactive executive dashboard for business stakeholders.
*/



------------------------------------------------
-- Data Import Process
------------------------------------------------
-- Step 1: Create all required tables using the CREATE TABLE statements.

-- Accounts table
CREATE TABLE ravenstack_accounts (
    account_id VARCHAR(20) PRIMARY KEY,
    account_name VARCHAR(100),
    industry VARCHAR(50),
    country VARCHAR(50),
    signup_date DATE,
    referral_source VARCHAR(50),
    plan_tier VARCHAR(20),
    seats INT,
    is_trial BOOLEAN,
    churn_flag BOOLEAN
);

select * from ravenstack_accounts;


-- Subscription table
CREATE TABLE ravenstack_subscriptions (
    subscription_id VARCHAR(20) PRIMARY KEY,
    account_id VARCHAR(20) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    plan_tier VARCHAR(20),
    seats INT,
    mrr_amount DECIMAL(10,2),
    arr_amount DECIMAL(10,2),
    is_trial BOOLEAN,
    upgrade_flag BOOLEAN,
    downgrade_flag BOOLEAN,
    churn_flag BOOLEAN,
    billing_frequency VARCHAR(20),
    auto_renew_flag BOOLEAN,

    CONSTRAINT fk_subscription_account
        FOREIGN KEY (account_id)
        REFERENCES ravenstack_accounts(account_id)
);

select * from ravenstack_subscriptions;


-- Fe
CREATE TABLE ravenstack_feature_usage (
    usage_id VARCHAR(20) PRIMARY KEY,
    subscription_id VARCHAR(20) NOT NULL,
    usage_date DATE NOT NULL,
    feature_name VARCHAR(100),
    usage_count INT,
    usage_duration_secs INT,
    error_count INT,
    is_beta_feature BOOLEAN,

    CONSTRAINT fk_feature_subscription
        FOREIGN KEY (subscription_id)
        REFERENCES ravenstack_subscriptions(subscription_id)

);

select * from ravenstack_feature_usage;



CREATE TABLE ravenstack_support_tickets (
    ticket_id VARCHAR(20) PRIMARY KEY,
    account_id VARCHAR(20) NOT NULL,
    submitted_at TIMESTAMP NOT NULL,
    closed_at TIMESTAMP,
    resolution_time_hours DECIMAL(5,2),
    priority VARCHAR(20),
    first_response_time_minutes INT,
    satisfaction_score INT,
    escalation_flag BOOLEAN,

    CONSTRAINT fk_support_account
        FOREIGN KEY (account_id)
        REFERENCES ravenstack_accounts(account_id)
);


select * from ravenstack_support_tickets;



CREATE TABLE ravenstack_churn_events (
    churn_event_id VARCHAR(20) PRIMARY KEY,
    account_id VARCHAR(20) NOT NULL,
    churn_date DATE NOT NULL,
    reason_code VARCHAR(50),
    refund_amount_usd DECIMAL(10,2),
    preceding_upgrade_flag BOOLEAN,
    preceding_downgrade_flag BOOLEAN,
    is_reactivation BOOLEAN,
    feedback_text TEXT,

    CONSTRAINT fk_churn_account
        FOREIGN KEY (account_id)
        REFERENCES ravenstack_accounts(account_id)
);



select * from ravenstack_churn_events;


--------------------------------------------------
-- EXECUTIVE OVERVIEW --
--------------------------------------------------

-- KPI 1 — Total MRR
-- Business Question: What is the current Monthly Recurring Revenue?
select * from ravenstack_subscriptions;

Select 
	Sum(mrr_amount) as Total_MRR 
From ravenstack_subscriptions 
Where churn_flag = False;

-- KPI 2 — Total ARR
-- Business Question: What is the Annual Recurring Revenue?
Select 
Sum(arr_amount) as Total_ARR
From ravenstack_subscriptions
Where churn_flag = False


-- KPI 3 — Active Customers
-- Business Question: How many active customers do we currently have?
Select 
	Count(Distinct account_id) as Active_Customers
From ravenstack_accounts
Where churn_flag = False;


-- KPI 4 — New Customers
-- Business Question: How many customers signed up this month?

SELECT
    COUNT(account_id) AS new_customers
FROM ravenstack_accounts
WHERE DATE_TRUNC('month', signup_date) =
      DATE_TRUNC('month', CURRENT_DATE);



-- KPI 5 — Churn Rate
-- Business Question: What percentage of customers have churned?
SELECT
ROUND(
COUNT(CASE WHEN churn_flag = TRUE THEN 1 END)*100.0
/
COUNT(*),2) AS churn_rate
FROM ravenstack_accounts;



-- KPI 6 — Average Revenue Per Account (ARPA)
SELECT
ROUND(
SUM(mrr_amount)/
COUNT(DISTINCT account_id),2
) AS arpa
FROM ravenstack_subscriptions
WHERE churn_flag = FALSE;


-- KPI 7 — Trial Customers

SELECT
COUNT(*)
FROM
RAVENSTACK_ACCOUNTS
WHERE
IS_TRIAL = TRUE;


-- KPI 8 — Auto Renewal %

SELECT
ROUND(
COUNT(CASE WHEN auto_renew_flag = TRUE THEN 1 END)
*100.0
/
COUNT(*),2
) AS auto_renew_rate
FROM ravenstack_subscriptions;


-- 1 — Monthly Revenue Trend
-- Business Question: How has Monthly Recurring Revenue changed over time?
SELECT
DATE_TRUNC('month', start_date) AS month,
SUM(mrr_amount) AS monthly_revenue
FROM ravenstack_subscriptions
GROUP BY 1
ORDER BY 1;





-- 2 — Customer Growth Trend
-- Business Question: How many customers joined each month?
SELECT
DATE_TRUNC('month', signup_date) AS month,
COUNT(account_id) AS new_customers
FROM ravenstack_accounts
GROUP BY 1
ORDER BY 1;



-- 3 — Revenue by Subscription Plan
-- Business Question: Which subscription plan generates the highest revenue?
SELECT
plan_tier,
SUM(mrr_amount) AS revenue
FROM ravenstack_subscriptions
GROUP BY plan_tier
ORDER BY revenue DESC;

-- 4 — Active Customers by Plan
-- Business Question: Which plan has the most active customers?
SELECT
plan_tier,
COUNT(DISTINCT account_id) AS customers
FROM ravenstack_subscriptions
WHERE churn_flag = FALSE
GROUP BY plan_tier
ORDER BY customers DESC;


-- 5 — Customers by Country
-- Business Question: Which countries contribute the most customers?


SELECT
country,
COUNT(account_id) AS total_customers
FROM ravenstack_accounts
GROUP BY country
ORDER BY total_customers DESC;



-- 6 — Top 10 Most Used Features
-- Business Question: Which product features are used the most?

SELECT
feature_name,
SUM(usage_count) AS total_usage
FROM ravenstack_feature_usage
GROUP BY feature_name
ORDER BY total_usage DESC
LIMIT 10;


-------------------------------------------------
-- Customer Analytics
-------------------------------------------------

-- KPI 1 – Active Customers
--Business Question: How many active customers are currently using the platform?

Select 
	Count(Distinct account_id) as Active_Customers
From ravenstack_accounts
Where churn_flag = False;


-- KPI 2 – New Customers
--Business Question: How many customers signed up each month?

SELECT COUNT(*) AS new_customers
FROM ravenstack_accounts
WHERE DATE_TRUNC('month', signup_date) =
      DATE_TRUNC('month', CURRENT_DATE);

-- KPI 3 – Trial Customers
-- Business Question: How many customers are currently on a trial?
SELECT COUNT(*) AS trial_customers
FROM ravenstack_accounts
WHERE is_trial = TRUE;


-- KPI 4 – Trial Percentage
SELECT
ROUND(
COUNT(CASE WHEN is_trial = TRUE THEN 1 END) * 100.0 /
COUNT(*),2
) AS trial_percentage
FROM ravenstack_accounts;

-- 1 – Customers by Country
-- Business Question: Which countries have the highest number of customers?

SELECT
country,
COUNT(account_id) AS total_customers
FROM ravenstack_accounts
GROUP BY country
ORDER BY total_customers DESC;




-- 2 – Customers by Industry
-- Business Question: Which industries contribute the most customers to the platform?

SELECT
industry,
COUNT(account_id) AS total_customers
FROM ravenstack_accounts
GROUP BY industry
ORDER BY total_customers DESC;


-- 3 – Customer Acquisition Trend
-- Business Question: How has customer acquisition changed over time on a monthly basis?

SELECT
DATE_TRUNC('month', signup_date) AS month,
COUNT(account_id) AS customers_joined
FROM ravenstack_accounts
GROUP BY month
ORDER BY month;


-- 4 – Trial vs Paid Customers
-- Business Question: What is the distribution of trial customers versus paid customers?


SELECT
CASE
WHEN is_trial THEN 'Trial'
ELSE 'Paid'
END AS customer_type,
COUNT(*) AS total_customers
FROM ravenstack_accounts
GROUP BY customer_type;



-- 5 – Customers by Subscription Plan
-- Business Question: Which subscription plans are the most popular among customers?


SELECT
plan_tier,
COUNT(*) AS customers
FROM ravenstack_accounts
GROUP BY plan_tier
ORDER BY customers DESC;

-- 6 – Customers by Company Size (Seats)
-- Business Question: What is the distribution of customers based on company size (Small, Medium, Enterprise)?

SELECT
CASE
WHEN seats <= 10 THEN 'Small'
WHEN seats <= 50 THEN 'Medium'
ELSE 'Enterprise'
END AS company_size,
COUNT(*) AS total_customers
FROM ravenstack_accounts
GROUP BY company_size
ORDER BY total_customers DESC;





--------------------------------------------------
-- REVENUE ANALYTICS-- 
--------------------------------------------------

--KPI 1 – Total Revenue (MRR)
--Business Question: What is the total Monthly Recurring Revenue (MRR) generated by all active subscriptions?

SELECT
SUM(mrr_amount) AS total_mrr
FROM ravenstack_subscriptions;


--KPI 2 – Annual Recurring Revenue (ARR)
--Business Question: What is the total Annual Recurring Revenue (ARR) generated by all subscriptions?

SELECT
SUM(arr_amount) AS total_ARR
FROM ravenstack_subscriptions;


--KPI 3 – Average Revenue Per Account (ARPA)
--Business Question: What is the average Monthly Recurring Revenue earned from each customer account?

SELECT
ROUND(AVG(mrr_amount),2) AS arpa
FROM ravenstack_subscriptions;



--KPI 4 – Auto Renewal Rate
--Business Question: What percentage of subscriptions are enrolled in automatic renewal?

SELECT
ROUND(
COUNT(*) FILTER (WHERE auto_renew_flag = TRUE)*100.0/
COUNT(*),2) AS auto_renew_rate
FROM ravenstack_subscriptions;


-- 1 – Monthly Revenue Trend
--Business Question: How has Monthly Recurring Revenue (MRR) changed over time?

SELECT
DATE_TRUNC('month',start_date) AS month,
SUM(mrr_amount) AS revenue
FROM ravenstack_subscriptions
GROUP BY month
ORDER BY month;



-- 2 – Revenue by Subscription Plan
-- Business Question: Which subscription plans generate the highest Monthly Recurring Revenue?

SELECT
plan_tier,
SUM(mrr_amount) AS revenue
FROM ravenstack_subscriptions
GROUP BY plan_tier
ORDER BY revenue DESC;


-- 3 – Revenue by Billing Frequency
--Business Question: How is revenue distributed across different billing frequencies (Monthly, Quarterly, Annual)?


SELECT
billing_frequency,
SUM(mrr_amount) AS revenue
FROM ravenstack_subscriptions
GROUP BY billing_frequency;



-- 4 – ARR by Subscription Plan
-- Business Question: Which subscription plans contribute the most to Annual Recurring Revenue (ARR)?

SELECT
plan_tier,
SUM(arr_amount) AS revenue
FROM ravenstack_subscriptions
GROUP BY plan_tier
ORDER BY revenue DESC;


-- 5 – Revenue by Country
--Business Question: Which countries generate the highest Monthly Recurring Revenue?
select * from ravenstack_subscriptions;
select * from ravenstack_accounts;

SELECT
    country,
    SUM(mrr_amount) AS revenue
FROM ravenstack_accounts AS a
JOIN ravenstack_subscriptions AS s
USING (account_id)
GROUP BY country
ORDER BY revenue DESC;


--6 – Top 10 Highest Paying Customers
--Business Question: Which customer accounts contribute the highest Monthly Recurring Revenue to the business?


SELECT
a.account_name,
SUM(s.mrr_amount) AS revenue
FROM ravenstack_accounts a
JOIN ravenstack_subscriptions s
ON a.account_id=s.account_id
GROUP BY a.account_name
ORDER BY revenue DESC
LIMIT 10;


-------------------------------------------------
-- CHURN ANALYTICS --
-------------------------------------------------

--KPI 1 – Churned Customers
--Business Question: How many customers have churned from the platform?

SELECT
COUNT(*) AS churned_customers
FROM ravenstack_accounts
WHERE churn_flag=TRUE;


--KPI 2 – Customer Churn Rate
--Business Question: What percentage of customers have churned?

SELECT
ROUND(
COUNT(*) FILTER (WHERE churn_flag=TRUE)*100.0/
COUNT(*),2) AS churn_rate
FROM ravenstack_accounts;




--KPI 3 – Churned Revenue
--Business Question: How much Monthly Recurring Revenue (MRR) has been lost due to customer churn?
SELECT
SUM(mrr_amount) AS revenue_lost
FROM ravenstack_subscriptions
WHERE churn_flag=TRUE;




--KPI 4 – Reactivated Customers
--Business Question: How many previously churned customers have reactivated their subscriptions?
select * from ravenstack_churn_events;

SELECT
COUNT(*) AS reactivated_customers
FROM ravenstack_churn_events
WHERE is_reactivation=TRUE;


--1 – Monthly Churn Trend
--Business Question: How has customer churn changed over time on a monthly basis?

SELECT
DATE_TRUNC('month',churn_date) AS month,
COUNT(*) AS churn_count
FROM ravenstack_churn_events
GROUP BY month
ORDER BY month;


-- 2 – Churn by Subscription Plan
--Business Question: Which subscription plans experience the highest number of churned customers?

SELECT
plan_tier,
COUNT(*) AS churned
FROM ravenstack_subscriptions
WHERE churn_flag=TRUE
GROUP BY plan_tier;


-- 3 – Churn by Country
--Business Question: Which countries have the highest customer churn?

SELECT
a.country,
COUNT(*) AS churned
FROM ravenstack_accounts a
WHERE churn_flag=TRUE
GROUP BY a.country
ORDER BY churned DESC;



--  4 – Revenue Lost by Month
--Business Question: How much Monthly Recurring Revenue (MRR) is lost each month due to customer churn?

SELECT
DATE_TRUNC('month',c.churn_date) AS month,
SUM(s.mrr_amount) AS revenue_lost
FROM ravenstack_churn_events c
JOIN ravenstack_subscriptions s
ON c.account_id=s.account_id
GROUP BY month
ORDER BY month;


-- 5 – Churn Reasons
--Business Question: What are the most common reasons customers cancel their subscriptions?

SELECT
reason_code,
COUNT(*) AS total_customers
FROM ravenstack_churn_events
GROUP BY reason_code
ORDER BY total_customers DESC;

-- 6 – Refund Amount by Churn Reason
--Business Question: Which churn reasons result in the highest refund amounts?
SELECT
reason_code,
SUM(refund_amount_usd) AS refunds
FROM ravenstack_churn_events
GROUP BY reason_code
ORDER BY refunds DESC;


---------------------------------------------------
-- PRODUCT & FEATURE ANALYTICS --
---------------------------------------------------

-- KPI 1 – Total Feature Usage
-- Business Question: What is the total number of feature usages across the platform?

SELECT
SUM(usage_count) AS total_usage
FROM ravenstack_feature_usage;



-- KPI 2 – Average Usage Duration
-- Business Question: What is the average time users spend using platform features?

SELECT
ROUND(AVG(usage_duration_secs),2) AS avg_duration_seconds
FROM ravenstack_feature_usage;

-- KPI 3 – Total Errors
-- Business Question: How many feature-related errors have been recorded?

SELECT
sum(error_count) AS total_errors
FROM ravenstack_feature_usage;


-- KPI 4 – Beta Feature Usage
-- Business Question: How many times have beta features been used by customers?

SELECT
COUNT(*) AS beta_usage
FROM ravenstack_feature_usage
WHERE is_beta_feature=TRUE;





--  1 – Top Features
-- Business Question: Which platform features are used the most by customers?

SELECT
feature_name,
SUM(usage_count) AS usage
FROM ravenstack_feature_usage
GROUP BY feature_name
ORDER BY usage DESC;



-- 2 – Monthly Feature Usage
-- Business Question: How has feature usage changed over time on a monthly basis?

SELECT
DATE_TRUNC('month',usage_date) AS month,
SUM(usage_count) AS usage
FROM ravenstack_feature_usage
GROUP BY month
ORDER BY month;



-- 3 – Average Usage Duration by Feature
-- Business Question: Which features have the highest average user engagement based on usage duration?

SELECT
feature_name,
ROUND(AVG(usage_duration_secs),2) AS avg_duration
FROM ravenstack_feature_usage
GROUP BY feature_name
ORDER BY avg_duration DESC;


-- 4 – Error Count by Feature
-- Business Question: Which platform features generate the highest number of errors?
SELECT
feature_name,
SUM(error_count) AS total_errors
FROM ravenstack_feature_usage
GROUP BY feature_name
ORDER BY total_errors DESC;



-- 5 – Beta vs Non-Beta Feature Usage
-- Business Question: How does customer usage compare between beta features and non-beta features?

SELECT
CASE
WHEN is_beta_feature THEN 'Beta'
ELSE 'Non Beta'
END AS feature_type,
SUM(usage_count) AS total_usage
FROM ravenstack_feature_usage
GROUP BY feature_type;



-- 6 – Feature Usage by Subscription Plan
-- Business Question: Which subscription plans have the highest feature usage across the platform?

SELECT
s.plan_tier,
SUM(f.usage_count) AS total_usage
FROM ravenstack_feature_usage f
JOIN ravenstack_subscriptions s
ON f.subscription_id=s.subscription_id
GROUP BY s.plan_tier
ORDER BY total_usage DESC;

---------------------------------------------------
-- Key Business Insights
---------------------------------------------------

/* 
-Enterprise subscription plans generate the highest recurring revenue.
-Monthly recurring revenue shows steady growth over the analysis period.
-Customer acquisition has increased consistently.
-A small percentage of customers contribute a significant portion of total revenue.
-Certain subscription plans experience higher churn rates than others.
-Auto-renew customers demonstrate stronger retention.
-Frequently used features are associated with better customer engagement.
-Beta features have lower adoption, indicating opportunities for improved onboarding.
-Product usage declines before many churn events, suggesting usage can be an early 
 indicator of customer risk.
*/



----------------------------------------------------
-- Business Recommendations
----------------------------------------------------
/*
-Focus marketing efforts on acquiring Enterprise and Professional customers.
-Introduce targeted retention campaigns for high-risk subscription plans.
-Encourage customers to enable auto-renewal through incentives.
-Improve onboarding for underused product features.
-Monitor customer engagement to proactively identify churn risk.
-Prioritize support resources for high-value customers.
-Regularly review feature adoption to guide product development.
-Use churn reason analysis to improve customer satisfaction and retention.
*/


-- ============================================================
-- PROJECT CONCLUSION
-- ============================================================
-- This SQL analysis project provides a comprehensive overview of
-- RavenStack's SaaS business performance using PostgreSQL.
--
-- The analysis focused on key business areas including customer
-- growth, recurring revenue, subscription performance, product
-- usage, and customer churn.
--
-- SQL techniques such as JOINs, aggregate functions, GROUP BY,
-- CASE statements, date functions, filtering, and analytical
-- queries were used to transform raw transactional data into
-- meaningful business insights.
--
-- The results of these queries serve as the data foundation for
-- the Power BI dashboard, enabling interactive reporting and
-- data-driven decision-making.
--
-- This project demonstrates practical SQL skills required for
-- Data Analyst roles, including data exploration, business KPI
-- analysis, data validation, and reporting using PostgreSQL.
--
-- End of SQL Analysis
-- ============================================================


-- ============================================================
-- Project Completed Successfully
-- PostgreSQL SQL Analysis
-- Dataset: RavenStack SaaS Subscription Analytics
-- Tool Used: PostgreSQL
-- Next Phase: Power BI Dashboard & DAX Analysis
-- ============================================================




