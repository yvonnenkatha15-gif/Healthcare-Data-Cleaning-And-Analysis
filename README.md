#  Portfolio Project Title: 
## Clinical-Financial Optimization: End-to-End Healthcare Data Scrubbing & Exploratory Analytics

### 1. Project Overview (The Business Scenario)
In this project, I acted as an independent Healthcare Data Analyst tasked with cleaning and evaluating a raw hospital admissions dataset sourced from Kaggle. The dataset tracked clinical vitals, patient demographics, and financial transactions across thousands of records. 

My primary mission was divided into two strategic phases:
1. **Data Engineering Layer:** Eradicate systematic human entry errors, remove duplicate records, and standardize messy categorical values using a strict database staging methodology in **MySQL**.
2. **Business Intelligence Layer:** Design a dynamic exploratory model in **Excel** to identify hospital cost drivers and analyze patient length-of-stay durations for executive decision-making.

---

### 2. The Data Engineering Layer (MySQL Core Cleaning)
To preserve the absolute integrity of the hospital's primary source data, I created a physical data pipeline structure named `healthcare_staging2`. I purposefully rejected working directly on raw data to establish a secure professional roll-back environment.

####  Duplicate Mitigation Strategy
Real-world healthcare facilities frequently suffer from duplicate entry submissions due to system lags or double-clicking at registration desks. To isolate exact duplicate historical patient visits without crashing MySQL, I implemented a window formatting strategy using the built-in `ROW_NUMBER()` tool:

```sql
-- Injecting automated sequential row numbers partitioned by unique event identifiers
INSERT INTO healthcare_staging2
SELECT *,
       ROW_NUMBER() OVER(
 PARTITION BY bmi, systolic_bp, diastolic_bp,  cholesterol_mg_dl,fasting_blood_sugar, heart_rate_bpm,admission_type, primary_diagnosis, medication_adherence, primary_diagnosis, treatment_cost_usd,length_of_stay_days, readmission_30_days 
       ) AS row_num
FROM healthcare_staging;

-- Safely isolating and purging systemic duplicate records
DELETE FROM healthcare_staging2 WHERE row_num > 1;

-- Dropping the structural helper column to finalize a clean schema
ALTER TABLE healthcare_staging2 DROP COLUMN row_num;
```

####  Categorical Standardization Checks
I executed strict `SELECT DISTINCT` queries against high-risk text fields including `gender`, `admission_type`, and `medication_adherence` to hunt for structural typos. The upstream infrastructure proved highly sound, confirming clean, typo-free data structures across these parameters.

#### Numeric Boundary Auditing
I ran descriptive boundary checks using `MIN()` and `MAX()` functions across all numerical vitals and metrics (including age, blood pressure, heart rate, and costs). The numeric data boundaries fell perfectly within realistic parameters, showing no extreme outliers or negative figures.

---

### 3. Business Intelligence & Exploratory Findings (Excel Layer)
After transferring the pristine data stream to Excel, I built high-density summary models to transform raw records into immediate operational insights.

* **The Financial Driver:** By building an aggregated Pivot Model evaluating cost allocations across clinical categories, **Cardiology emerged as the absolute most expensive department** on average. This actionable insight pinpoints exactly where hospital administrators should focus budgeting optimization strategies.
* **Demographic Lifespans:** I utilized mathematical **Age Binning Brackets** to group patients into clear generational groups, mapping their hospitalization timelines cleanly without visual clutter.
* **Advanced Distribution Tracking:** I deployed an interactive **Slicer Engine** alongside a **Scatter Plot Density Cloud** to explore the underlying relationship between a patient's age and their corresponding length of stay in a hospital bed.

---

###  Next Milestone: Advanced Power BI Dashboarding (Coming Soon)
To transform this static exploratory model into a fully responsive, enterprise-grade reporting application, Phase 3 of this portfolio will focus on importing this clean schema directly into **Power BI Desktop**. I will engineer live interactive visual matrices to automate these clinical metrics permanently.


