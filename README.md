#  Healthcare Revenue Cycle Management (RCM) & Claims Analytics

##  Project Overview
Revenue Cycle Management (RCM) in healthcare is a complex process where minor administrative mistakes can lead to major financial leaks. Unprocessed claims, missing authorizations, and uncollected balances directly impact a healthcare provider's cash flow.

This project focuses on building an end-to-end data pipeline—transitioning raw healthcare claims data from a flat Excel workbook into a fully normalized **PostgreSQL relational database**, and analyzing key financial performance metrics using advanced **SQL queries**.

---

##  Business Objectives
* **Assess Revenue Health:** Calculate top-level financial KPIs including Total Billed Amount, Net Collections, and Revenue Exposure from denied claims.
* **Identify High-Risk Providers:** Pinpoint specific providers driving significant denial volumes using rank-based window functions.
* **Uncover Root Causes for Denials:** Categorize denial reasons to pinpoint process bottlenecks in front-desk registration and clinical documentation.
* **Examine Aged Receivables (AR):** Analyze outstanding balances by aging status to minimize uncollectible bad debt.

---

##  Data Architecture & Tech Stack
* **Excel:** Initial data cleaning, structural validation, and formatting raw values for database ingestion.
* **PostgreSQL:** Relational database management system (RDBMS) storing normalized tables.
* **DBeaver:** Database GUI used for database setup, table mappings, and ETL data ingestion.
* **SQL (PostgreSQL dialect):** Advanced analytical querying including CTEs, Window Functions (`DENSE_RANK`, `SUM() OVER()`), Conditional Aggregations (`CASE WHEN`), and Foreign Key joins.

### Database Schema Architecture
The database follows a star-adjacent relational structure to optimize storage and query performance:
* **`claims` (Fact Table):** Stores individual claim transactions, amounts billed/paid, procedure codes, and status tags.
* **`payers` (Dimension Table):** Stores insurance payer types (`Commercial`, `Medicaid`, `Medicare`, `Self-Pay`).
* **`patients` (Dimension Table):** Stores unique patient ID references.
* **`providers` (Dimension Table):** Stores unique healthcare provider ID references.

---

## Key Insights & Analytical SQL Suite

### 1. Executive Summary & Financial KPIs
Calculates total claim volume, net collections, and total financial exposure tied up in denied status.
* **Key Finding:** Evaluates overall operational cash flow and sets the benchmark collection percentage across all 1,000 processed claims.

### 2. Payer Performance Breakdown
Joins the `claims` fact table with the `payers` dimension table to compare collection rates across insurance categories.
* **Key Finding:** Evaluates whether specific payer categories (e.g., Self-Pay vs. Commercial) present distinct reimbursement performance challenges.

### 3. High-Risk Provider Ranking (`DENSE_RANK()`)
Uses Common Table Expressions (CTEs) and window functions to rank providers based on total denied revenue.
* **Key Finding:** Isolates top revenue-loss providers without skipping rank places, creating an actionable list for internal auditing.

### 4. Root-Cause Denial Analysis (`SUM() OVER()`)
Calculates the dollar impact of each denial reason code alongside its percentage share of total denied dollars.
* **Key Finding:** Pinpoints administrative vulnerabilities—such as missing authorizations or incorrect billing details—to guide targeted staff retraining.

### 5. Aged Receivables (AR) Exposure Analysis
Aggregates active, uncollected balances across non-closed AR statuses (`On Hold`, `Open`, `Pending`, `Partially Paid`, `Denied`).
* **Key Finding:** Identifies high-risk outstanding balances sitting in pending or hold statuses before they transition into permanent uncollectible debt.

---

## How to Run This Project

### Prerequisites
1. **PostgreSQL** installed locally.
2. **DBeaver** (or any preferred SQL client).

### Setup Steps
1. **Clone the repository:**
   ```bash
   git clone [https://github.com/ItumelengKocha/healthcare-rcm-analytics.git](https://github.com/ItumelengKocha/healthcare-rcm-analytics.git)

###  Interactive Tableau Dashboard
**[View the Live Interactive Tableau Dashboard Here](https://public.tableau.com/views/RCM_17852672234410/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)**
<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/3526ff7c-f051-497f-a340-60cc73e2cde0" />


###  Python Data Analysis
Exploratory analysis of healthcare claims data using Python and Pandas, including data inspection, filtering, aggregation, and analysis.
 **[View the Python Pandas Notebook](./Healthcare_Python_Intro.ipynb)**
