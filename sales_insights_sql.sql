select * from df_orders;

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



