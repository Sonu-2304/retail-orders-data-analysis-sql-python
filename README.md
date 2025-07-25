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
-- Top 5 highest-selling products
SELECT product_name, SUM(sale_price) AS total_sales
FROM sales_data
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 5;

-- Month-over-month sales growth
SELECT 
    FORMAT(order_date, 'yyyy-MM') AS month,
    SUM(sale_price) AS monthly_sales
FROM sales_data
GROUP BY FORMAT(order_date, 'yyyy-MM')
ORDER BY month;
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



