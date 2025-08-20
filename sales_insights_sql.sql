

select * from df_orders;

CREATE INDEX idx_order_date ON df_orders(order_date);
CREATE INDEX idx_region ON df_orders(region);
CREATE INDEX idx_product_id ON df_orders(product_id);
CREATE INDEX idx_category_sub ON df_orders(category, sub_category);


--find top 10 highest reveue generating products 

select top 10 product_id, sum(quantity*sale_price) Sales
from df_orders
group by product_id
order by Sales desc;



--find top 5 highest selling products in each region

with cte as 

   (select  region, product_id, sum(quantity) Total_quantity
	from df_orders
	group by region , product_id )

select * from (
select *
, row_number() over(partition by region order by Total_quantity desc ) as rn
from cte) A
where rn<=5


--find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023

WITH CTE AS (
SELECT YEAR(ORDER_DATE) AS YEAR, MONTH(ORDER_DATE) AS MONTH, SUM(sale_price) AS SALES
FROM DF_ORDERS
GROUP BY YEAR(ORDER_DATE), MONTH(ORDER_DATE)
)
SELECT MONTH, 
       SUM(CASE WHEN YEAR = 2022 THEN SALES ELSE 0 END) AS SALE_2022
	,  SUM(CASE WHEN YEAR = 2023 THEN SALES ELSE 0 END) AS SALE_2023
	,  (SUM(CASE WHEN YEAR = 2022 THEN SALES ELSE 0 END) 
	   - SUM(CASE WHEN YEAR = 2023 THEN SALES ELSE 0 END)) AS SALE_DIFFERENCE
	,  ROUND((SUM(CASE WHEN YEAR = 2022 THEN SALES ELSE 0 END) 
	   - SUM(CASE WHEN YEAR = 2023 THEN SALES ELSE 0 END))*100
	   /NULLIF(SUM(CASE WHEN YEAR = 2022 THEN SALES ELSE 0 END),0),2) AS PER_GROWTH

FROM CTE
GROUP BY MONTH
ORDER BY MONTH

--for each category which month had highest sales 
WITH CTE AS (
SELECT CATEGORY, MONTH(ORDER_DATE) MONTH, YEAR(ORDER_DATE) YEAR , SUM(SALE_PRICE) SALES
FROM df_orders
GROUP BY CATEGORY, MONTH(ORDER_DATE) , YEAR(ORDER_DATE) 
)
SELECT * FROM
(SELECT *, ROW_NUMBER() OVER(PARTITION BY CATEGORY ORDER BY SALES DESC) RN
FROM CTE) A
WHERE RN = 1

--which sub category had highest growth by profit in 2023 compare to 2022

WITH CTE1 AS (
SELECT SUB_CATEGORY , YEAR(ORDER_DATE) AS YEAR, SUM(sale_price) AS SALES
FROM DF_ORDERS
GROUP BY SUB_CATEGORY, YEAR(ORDER_DATE)
)

, CTE2 AS (
SELECT SUB_CATEGORY,
       SUM(CASE WHEN YEAR = 2022 THEN SALES ELSE 0 END) AS SALE_2022
	,  SUM(CASE WHEN YEAR = 2023 THEN SALES ELSE 0 END) AS SALE_2023
	
FROM CTE1
GROUP BY SUB_CATEGORY
)
SELECT TOP 1  *, (SALE_2023-SALE_2022)*100/SALE_2022 AS PROFIT
FROM CTE2
ORDER BY PROFIT DESC



--- Find the top 5 cities generating the highest profit


SELECT TOP 5 city, SUM(profit) AS total_profit
FROM df_orders
GROUP BY city
ORDER BY total_profit DESC;


---

--- Find the top 3 shipping modes by total sales

SELECT TOP 3 ship_mode, SUM(quantity * sale_price) AS total_sales
FROM df_orders
GROUP BY ship_mode
ORDER BY total_sales DESC;


---

--- Find the discount impact – average profit margin % with and without discount


SELECT 
   CASE WHEN discount = 0 THEN 'No Discount' ELSE 'Discount Applied' END AS discount_flag,
   ROUND(SUM(profit)*100.0 / NULLIF(SUM(sale_price),0),2) AS profit_margin_percent
FROM df_orders
GROUP BY CASE WHEN discount = 0 THEN 'No Discount' ELSE 'Discount Applied' END;


---

--- Find the highest revenue product per year


WITH yearly_sales AS (
    SELECT YEAR(order_date) AS year, product_id, SUM(quantity * sale_price) AS sales
    FROM df_orders
    GROUP BY YEAR(order_date), product_id
)
SELECT *
FROM (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY year ORDER BY sales DESC) rn
    FROM yearly_sales
) t
WHERE rn = 1;

---

--- Calculate total sales and profit contribution by segment

SELECT segment,
       SUM(sale_price) AS total_sales,
       SUM(profit) AS total_profit,
       ROUND(SUM(sale_price)*100.0 / SUM(SUM(sale_price)) OVER(),2) AS sales_contribution_pct,
       ROUND(SUM(profit)*100.0 / SUM(SUM(profit)) OVER(),2) AS profit_contribution_pct
FROM df_orders
GROUP BY segment
ORDER BY total_sales DESC;

---

--- Identify the state with the highest average order value (AOV)


SELECT state,
       ROUND(SUM(quantity * sale_price) * 1.0 / COUNT(DISTINCT order_id),2) AS avg_order_value
FROM df_orders
GROUP BY state
ORDER BY avg_order_value DESC;


---

--- Find the top 5 most profitable sub-categories in the West region

SELECT TOP 5 sub_category, SUM(profit) AS total_profit
FROM df_orders
WHERE region = 'West'
GROUP BY sub_category
ORDER BY total_profit DESC;


---

--- Find cumulative monthly sales trend


WITH monthly_sales AS (
    SELECT YEAR(order_date) AS year, MONTH(order_date) AS month, SUM(quantity * sale_price) AS sales
    FROM df_orders
    GROUP BY YEAR(order_date), MONTH(order_date)
)
SELECT year, month, sales,
       SUM(sales) OVER(PARTITION BY year ORDER BY month) AS cumulative_sales
FROM monthly_sales
ORDER BY year, month;


---

--- Find top 10 orders with the highest discounts given

SELECT TOP 10 order_id, discount, sale_price, profit
FROM df_orders
ORDER BY discount DESC;

---

--- Find region-wise profit margins


SELECT region,
       SUM(profit) AS total_profit,
       SUM(sale_price) AS total_sales,
       ROUND(SUM(profit)*100.0 / NULLIF(SUM(sale_price),0),2) AS profit_margin_pct
FROM df_orders
GROUP BY region
ORDER BY profit_margin_pct DESC;



--- Find the product category with the highest discount impact on profit

WITH CTE AS (
    SELECT 
        category,
        SUM(discount) AS total_discount,
        SUM(profit) AS total_profit,
        SUM(sale_price) AS total_sales
    FROM df_orders
    GROUP BY category
)
SELECT category,
       total_discount,
       total_profit,
       ROUND((total_profit * 1.0 / NULLIF(total_sales,0))*100,2) AS profit_margin
FROM CTE
ORDER BY total_discount DESC;

---

--- Find the city with the highest profit margin (%) in each region

WITH CTE AS (
    SELECT 
        region,
        city,
        SUM(sale_price) AS total_sales,
        SUM(profit) AS total_profit,
        ROUND((SUM(profit) * 100.0 / NULLIF(SUM(sale_price),0)), 2) AS profit_margin
    FROM df_orders
    GROUP BY region, city
)
SELECT region, city, profit_margin
FROM (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY region ORDER BY profit_margin DESC) AS rn
    FROM CTE
) A
WHERE rn = 1;
