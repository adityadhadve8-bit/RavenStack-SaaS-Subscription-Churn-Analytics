# RavenStack-SaaS-Subscription-Churn-Analytics
End-to-end SaaS analytics project: PostgreSQL analysis + 5-page Power BI dashboard tracking MRR/ARR, customer growth, churn, product usage and support for a subscription business (500 accounts, 5K subscriptions, 2023-2024).

## Business Problem

RavenStack is a B2B SaaS company selling subscription software worldwide. As the customer base grew, leadership had no single view of:

- How much recurring revenue (MRR / ARR) the business generates and where it comes from
- Which customers, plans, industries and countries are churning, and why
- Whether product usage and customer support relate to retention
- Where to focus acquisition and retention spend

- Goal: turn five raw operational tables into a decision-ready analytics solution that tracks revenue, growth, retention, product engagement and churn.

## Objectives
- Analyse MRR and ARR and revenue by plan, billing frequency and country
- Track customer acquisition and churn over time
- Measure subscription plan performance
- Analyse feature adoption and product engagement
- Identify high-value customers
- Evaluate billing and auto-renewal behaviour
- Build an interactive executive dashboard for stakeholders

## Dataset

### Five relational tables, Jan 2023 – Dec 2024:

- Table	Rows	Description
- ravenstack_accounts	500	Customer profile: industry, country, signup date, referral source, plan, seats, trial & churn flags
- ravenstack_subscriptions	5,000	Subscription history: plan, seats, MRR/ARR, billing frequency, auto-renew, upgrade/downgrade/churn flags
- ravenstack_churn_events	600	Churn date, reason code, refund amount, preceding upgrade/downgrade, reactivation, feedback
- ravenstack_feature_usage	25,000	Feature usage count, duration, errors, beta-feature flag
- ravenstack_support_tickets	2,000	Priority, response & resolution time, satisfaction score, escalation

- Relationships: accounts (1) → (∗) subscriptions (1) → (∗) feature_usage, and accounts (1) → (∗) support_tickets / churn_events.
- The dataset is synthetic (RavenStack sample data), so figures illustrate the analysis approach rather than a real company.

### Tech Stack & Skills
PostgreSQL — schema design (PK/FK constraints), JOIN, GROUP BY, CASE, FILTER, DATE_TRUNC, aggregate analysis
Power BI — data modelling, DAX measures, slicers, drill-through navigation, 5-page report design
Analytics — KPI design, cohort/segment analysis, churn analysis, product-usage analysis

## Key Insights
- Enterprise is the revenue engine. Enterprise is roughly a third of subscriptions but ~75% of MRR (avg ≈ $4.9K per subscription vs ≈ $475 for Basic).
- Churn is plan-agnostic, so its revenue impact isn't. All plans churn at ~22%, which means each Enterprise loss costs ~10× a Basic loss.
- Growth is strong. New-subscription MRR rose from ~$42K (Q1 2023) to ~$5.0M (Q4 2024), and quarterly signups grew from 55 to 80.
- Churn volume is rising with the base. Churn events grew from 6 (Q1 2023) to 251 (Q4 2024), so retention needs to scale with acquisition.
- Some segments churn far more. DevTools, event-sourced leads and Germany stand out; partner and organic channels retain best.
- Downgrades are an early warning. Subscriptions with a downgrade churn at 11.5% vs 9.6% without; upgrades churn less (8.7% vs 9.8%). About 1 in 5 churn events followed an upgrade.
- Reasons are diffuse. No single cause dominates, but product gaps (features) plus price perception are the largest stated themes.
- Revenue is moderately concentrated. The top 20% of accounts bring ~43% of MRR, so a few large accounts matter but there is no extreme dependency.
- Usage and support metrics alone did not separate churned from active customers (similar usage, errors, ticket volume and CSAT), so better health signals are needed.

## Recommendations
- Protect Enterprise accounts first. Assign proactive account management and renewal reviews, since each retained Enterprise account is worth far more than other tiers.
- Act on downgrades. Trigger a customer-success outreach whenever an account downgrades.
- Fix the leaky channels. Re-qualify event-sourced leads and invest more in partner and organic channels, which show the lowest churn.
- Target high-churn segments (DevTools, Germany) with tailored onboarding and success playbooks.
- Address the top stated reasons. Feed "missing features" feedback into the roadmap and review pricing or packaging for value perception.
- Build a real health score. Raw usage volume and CSAT didn't predict churn here; add recency of activity, seat utilisation, and trend-based signals.
- Improve data capture on churn. Around 16% of reasons are unknown and ~25% of feedback is blank; make exit surveys mandatory.
- Push beta adoption through onboarding, since beta usage is only ~10% of total.
- Win back lapsed customers with a reactivation programme, as ~10% already return unprompted.

### About Me
Aditya Dhadve — Data Analyst | SQL • Power BI • Excel • Python • Machine Learning • Depp Learning • Gen AI 
🔗 LinkedIn - www.linkedin.com/in/aditya-dhadve-a911ba2a8 ·
📧 adityadhadve8@gmail.com
⭐If you found this project useful, please star the repo!
