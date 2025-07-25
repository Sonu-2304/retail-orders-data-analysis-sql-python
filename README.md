# 📊 Retail Sales Analysis Project (Python + SQL Server)

## 📁 Project Category

**Level**: Intermediate – Advanced
**Tools**: Python (Pandas), SQL Server Management Studio (SSMS), SQLAlchemy, Jupyter Notebook
**Dataset**: Retail sales dataset from Kaggle

---

## 📌 Overview

This project focuses on performing end-to-end **retail data analysis** using both **Python** for data cleaning and **SQL Server (SSMS)** for business intelligence. The goal is to simulate a real-world workflow where raw sales data is cleaned, transformed, and loaded into a database for deep analysis using SQL.

---

## 🛠️ Tools & Technologies

* **Python** (Pandas) – For data cleaning and transformation
* **SQL Server (SSMS)** – For querying and generating insights
* **SQLAlchemy** – For connecting Python with SQL Server
* **Jupyter Notebook** – For scripting and documenting the workflow

---

## 🔄 Project Workflow

### 1. 📥 Data Loading

* Downloaded the retail dataset from **Kaggle**.
* Imported the CSV into **Pandas** using `read_csv()`.

### 2. 🧹 Data Cleaning & Processing

* Handled missing/null values and standardized column names.
* Parsed and formatted `date` fields.
* Dropped irrelevant columns.
* Engineered new features like:

  * `Sale Price = Quantity × Unit Price`
  * `Profit = Sale Price - Cost`

### 3. 🗃️ Database Integration

* Connected Python to **SQL Server** using **SQLAlchemy**.
* Created SQL tables and inserted the cleaned data using Pandas `.to_sql()` method.

### 4. 🧠 Data Analysis Using SQL

Performed SQL analysis to answer business questions:

* Top-selling products and their revenue.
* Month-over-month sales growth.
* Regional sales performance.
* Category and sub-category wise profit trends.
* Seasonal or quarterly spikes in demand.

---

## 📂 Project Structure

```
retail-sales-analysis/
│
├── notebook/
│   └── retail_data_cleaning.ipynb       # Python code for data processing
│
├── queries/
│   └── retail_analysis_queries.sql      # SQL queries for analysis
│
├── dataset/
│   └── retail_data.csv                  # Original/raw dataset
│
└── README.md                            # Project documentation
```

---

## 💡 Sample SQL Queries

```sql
-- 📅 Month-over-month sales comparison between 2022 and 2023
WITH CTE AS (
    SELECT 
        YEAR(ORDER_DATE) AS YEAR,
        MONTH(ORDER_DATE) AS MONTH,
        SUM(sale_price) AS SALES
    FROM DF_ORDERS
    GROUP BY YEAR(ORDER_DATE), MONTH(ORDER_DATE)
)
SELECT 
    MONTH, 
    SUM(CASE WHEN YEAR = 2022 THEN SALES ELSE 0 END) AS SALE_2022,
    SUM(CASE WHEN YEAR = 2023 THEN SALES ELSE 0 END) AS SALE_2023,
    (SUM(CASE WHEN YEAR = 2023 THEN SALES ELSE 0 END) - 
     SUM(CASE WHEN YEAR = 2022 THEN SALES ELSE 0 END)) AS SALE_DIFFERENCE,
    ROUND(
        (SUM(CASE WHEN YEAR = 2023 THEN SALES ELSE 0 END) - 
         SUM(CASE WHEN YEAR = 2022 THEN SALES ELSE 0 END)) * 100.0 / 
        NULLIF(SUM(CASE WHEN YEAR = 2022 THEN SALES ELSE 0 END), 0),
        2
    ) AS PERCENT_GROWTH
FROM CTE
GROUP BY MONTH
ORDER BY MONTH;

-- 📈 Which sub-category had the highest sales growth from 2022 to 2023
WITH CTE1 AS (
    SELECT 
        SUB_CATEGORY, 
        YEAR(ORDER_DATE) AS YEAR, 
        SUM(sale_price) AS SALES
    FROM DF_ORDERS
    GROUP BY SUB_CATEGORY, YEAR(ORDER_DATE)
),
CTE2 AS (
    SELECT 
        SUB_CATEGORY,
        SUM(CASE WHEN YEAR = 2022 THEN SALES ELSE 0 END) AS SALE_2022,
        SUM(CASE WHEN YEAR = 2023 THEN SALES ELSE 0 END) AS SALE_2023
    FROM CTE1
    GROUP BY SUB_CATEGORY
)
SELECT TOP 1 *, 
       (SALE_2023 - SALE_2022) * 100.0 / NULLIF(SALE_2022, 0) AS GROWTH_PERCENT
FROM CTE2
ORDER BY GROWTH_PERCENT DESC;

```

---

## 📈 Key Takeaways

* Learned how to bridge **Python and SQL Server** in a seamless workflow.
* Gained hands-on experience in **data cleaning**, **ETL**, and **KPI analysis**.
* Understood business performance metrics like **monthly trends**, **profitability**, and **regional demand**.
* Practiced writing **optimized SQL queries** in a production-like setup.

---

## 📊 Visualization Ideas

* Build a **Power BI or Tableau dashboard** to visualize:

  * Sales by month/region
  * Profit by category
  * Heatmaps of product performance
* Or use **Matplotlib/Seaborn** in Python for plotting.

---

## 🚀 Future Improvements

* Add support for **multiple years** of data to track long-term trends.
* Introduce **stored procedures** or **views** for reusable queries.
* Schedule automated ETL using Python or SSIS.
* Integrate customer segmentation and RFM analysis.

---

## 📌 Notes

* The SQL Server instance was connected locally using **SQLAlchemy**.
* This project mimics a real-world **data pipeline** and can be extended for BI reporting.



