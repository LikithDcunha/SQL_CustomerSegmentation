USE DATABASE sales_rfm;

SELECT OrderDate
From sales_data_Sample
Limit 20;

UPDATE sales_data_Sample
SET OrderDate = STR_TO_DATE(OrderDate, '%m/%d/%Y %H:%i');


-- inspection of data for plotting 
SELECT distinct STATUS FROM sales_data_Sample;  -- Use for plotting
SELECT distinct DEALSIZE FROM sales_data_Sample; -- Use for plotting
SELECT distinct STATUS FROM sales_data_Sample;  -- Use for plotting
SELECT distinct Country FROM sales_data_Sample;  -- Use for plotting 
SELECT distinct productline FROM sales_data_Sample ; -- Use for plotting
SELECT distinct TERRITORY FROM sales_data_Sample ; -- Use for plotting

SELECT distinct month_id FROM sales_data_Sample
Where year_id = 2005
ORDER by 1 ASC ;


-- Analysis --


-- Grouping sales by productline
SELECT  productline , ROUND(SUM(sales),2) Revenue
FROM sales_data_Sample
GROUP BY productline
ORDER BY SUM(sales) DESC ;


-- Grouping sales by Year
SELECT  year_id , ROUND(SUM(sales),2) Revenue_year
FROM sales_data_Sample
GROUP BY year_id
ORDER BY SUM(sales) DESC ;

-- Grouping sales/Revenue by dealsize
SELECT dealsize, ROUND(SUM(sales),2) Revenue_per_DEAL
FROM sales_data_Sample
GROUP BY DEALSIZE
ORDER BY 2 DESC;

-- Grouping sales for each month 
SELECT month_id, ROUND(SUM(sales), 2 ) Revenue
FROM sales_data_Sample
Where year_id = 2003 -- Change year to get sales for that year
GROUP by month_id 
ORDER BY 2 DESC;

-- Which month had the highest Revenue ? Which month had the highest Frequency of orders?

SELECT month_id, ROUND(SUM(sales)) Revenue, COUNT(ordernumber) FREQUENCY
FROM sales_data_Sample 
Where year_id = 2004 
GROUP BY month_id
ORDER BY 2 DESC;   

-- Month no. 11 is the best month. But what is the best product line?

SELECT month_id,Productline, ROUND(SUM(sales)) Revenue, COUNT(ordernumber) FREQUENCY
FROM sales_data_Sample 
Where year_id = 2003 and month_id = 11  -- input year (2004, 2005) for yearly data 
GROUP BY month_id, Productline
ORDER BY 3 DESC;   

-- who is the best customer. in terms of RFM : Recency , Frequency , Monetary.

with rfm as 
(    
    SELECT customername, 
        SUM(sales) MonetaryValue,
        AVG(sales) AvgMonetaryValue,
        Count(ordernumber) FREQUENCY,
        max(STR_TO_DATE(OrderDate, '%m/%d/%Y')) lastOrderDate,  -- using str_to_date to convert text to date format
        (SELECT max(STR_TO_DATE(OrderDate, '%m/%d/%Y')) FROM sales_data_Sample) max_orderDate,
        DATEDIFF((SELECT max(STR_TO_DATE(OrderDate, '%m/%d/%Y')) FROM sales_data_Sample),max(STR_TO_DATE(OrderDate, '%m/%d/%Y'))) Recency
    FROM sales_data_Sample
    GROUP BY customername
),
rfm_calc as 
(
    SELECT *,
        NTILE(4) OVER(order by rfm.Recency DESC) rfm_recency, -- closer the last order date to max order date, Higher is rfm_recency
        NTILE(4) OVER(order by rfm.FREQUENCY) rfm_frequency, -- higher frequecy higher rfm_frequency
        NTILE(4) OVER(order by rfm.MonetaryValue) rfm_monetary
    FROM RFM 
)
    SELECT  *, rfm_calc.rfm_recency + rfm_calc.rfm_frequency + rfm_calc.rfm_monetary as rfm_cell,
            concat(cast(rfm_calc.rfm_recency AS VARCHAR), cast(rfm_calc.rfm_frequency as VARCHAR), cast(rfm_calc.rfm_monetary as VARCHAR)) rfm_str
    From rfm_calc;


--- debugged code
DROP TABLE IF EXISTS Temporary_rfm;
CREATE TEMPORARY TABLE Temporary_rfm AS
with rfm as 
(    
    SELECT customername, 
        SUM(sales) MonetaryValue,
        AVG(sales) AvgMonetaryValue,
        Count(ordernumber) FREQUENCY,
        max(OrderDate) lastOrderDate,  -- using str_to_date to convert text to date format
        (SELECT max(OrderDate) FROM sales_data_Sample) max_orderDate,
        DATEDIFF((SELECT max(OrderDate) FROM sales_data_Sample),max(OrderDate)) Recency
    FROM sales_data_Sample
    GROUP BY customername
),
rfm_calc as 
(
    SELECT *,
        NTILE(4) OVER(order by rfm.Recency DESC) rfm_recency, -- closer the last order date to max order date, Higher is rfm_recency
        NTILE(4) OVER(order by rfm.FREQUENCY) rfm_frequency, -- higher frequecy higher rfm_frequency
        NTILE(4) OVER(order by rfm.MonetaryValue) rfm_monetary
    FROM rfm 
)
SELECT *, 
    rfm_calc.rfm_recency + rfm_calc.rfm_frequency + rfm_calc.rfm_monetary AS rfm_cell,
    CONCAT(CAST(rfm_calc.rfm_recency AS CHAR), CAST(rfm_calc.rfm_frequency AS CHAR), CAST(rfm_calc.rfm_monetary AS CHAR)) AS rfm_str
from rfm_calc; 

select CUSTOMERNAME , rfm_recency, rfm_frequency, rfm_monetary,rfm_str,
case 
		when rfm_str in (111, 112 , 121, 122, 123, 132, 211, 212, 114, 141) then 'lost_customers'
        when rfm_str in (133, 134, 143, 244, 334, 343, 344, 144) then 'slipping away, cannot lose'
        when rfm_str in (311, 411, 331) then 'new customers'
        when rfm_str in (222, 223, 233, 322) then 'potential churners'
        when rfm_str in (323, 333,321, 422, 332, 432) then 'active'
        when rfm_str in (433, 434, 443, 444) then 'loyal'
    end rfm_segment
From Temporary_rfm;
    
    








