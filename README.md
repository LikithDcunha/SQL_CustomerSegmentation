# Customer Segmentation Analysis using RFM

This repository contains SQL code for performing a customer segmentation analysis using RFM (Recency, Frequency, and Monetary) analysis.

## Data

The data used for this analysis is stored in the SQL dump file named `sales_rfm.sql`. The dataset includes customer transaction data, including the purchase amount and date. 

To import the data into MySQL, you can follow these steps:

1. Create a new database named `SALES_RFM` by running the following command:

CREATE DATABASE SALES_RFM;


2. Make sure that you are inside the directory where the `sales_rfm.sql` file is located.
3. Run the following command to load the dump file into MySQL:

mysql -u your_username -p SALES_RFM < sales_rfm.sql


Make sure to replace `your_username` with your MySQL username.

4. Once the import is complete, you should see a message indicating that the table was successfully created inside the `SALES_RFM` database.

With the data now imported into MySQL, you can proceed with running the SQL script to calculate the RFM scores and segment the customers.

## SQL Script

The SQL script `customer_segmentation.sql` contains the code for calculating the RFM scores and segmenting the customers. 

The script uses window functions to calculate the RFM scores, which are then used to assign customers to segments based on their buying behavior.

## Instructions

To run this analysis, you will need to:

Import the customer transaction data into MySQL using the LOAD DATA INFILE command.
Run the SQL script to calculate the RFM scores and segment the customers.
Analyze the results and identify the different customer segments.



## Results

The customer segmentation analysis can help identify the most valuable customers, as well as those who are at risk of churn. By understanding the behavior of each customer segment, businesses can tailor their marketing and retention strategies to improve customer satisfaction and increase revenue.

## Work in Progress

This analysis is a work in progress, and we are continuously refining our methodology and exploring new ways to extract insights from the customer data. We welcome any feedback or suggestions for improving the analysis. 

## Conclusion

In conclusion, customer segmentation using RFM analysis is a powerful tool for identifying valuable customers and improving customer satisfaction. By analyzing customer behavior and identifying patterns, businesses can make data-driven decisions that lead to increased revenue and customer loyalty.
