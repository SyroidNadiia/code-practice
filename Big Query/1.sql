
SELECT
	-- Add the column we want to count by
	COUNT(order_id)
FROM
	ecommerce.ecomm_order_details
-- Add the correct date part and value for each row, with the quarter coming first
WHERE EXTRACT(YEAR from order_purchase_timestamp) = 2017
AND EXTRACT(QUARTER from order_purchase_timestamp) = 4;

-- Fill in the query to find the three days with the most orders

SELECT
	-- First, add the date formatting for dates
	FORMAT_TIMESTAMP("%D", order_purchase_timestamp) AS order_date,
    order_id
FROM 
	ecommerce.ecomm_order_details
LIMIT 3;

-- Fill in the query to find the total number of orders in the seven days after Black Friday

SELECT
	COUNT(order_id)
FROM 
	ecommerce.ecomm_order_details
WHERE order_purchase_timestamp BETWEEN
	-- Add the correct date part and interval 
	TIMESTAMP('2017-11-24') AND TIMESTAMP_ADD(TIMESTAMP('2017-11-24'), INTERVAL 7 DAY)


-- Fill in the query to find the total number of orders in the seven days after Black Friday

SELECT
	COUNT(order_id)
FROM 
	ecommerce.ecomm_order_details
-- Fill in the correct column name
WHERE order_purchase_timestamp BETWEEN
	-- Add the correct function to subtract from a timestamp
	TIMESTAMP_SUB(TIMESTAMP('2017-11-24'), INTERVAL 30 DAY) AND TIMESTAMP('2017-11-24')


-- Finish the query to find the difference in days

SELECT
	-- Add in the function to find the difference between two dates
	DATE_DIFF(
      -- Finish the statement with the correct date part
      EXTRACT(DATE FROM order_purchase_timestamp),
      -- Add the function to find the current date
      CURRENT_DATE(),
      DAY
    )
FROM 
	ecommerce.ecomm_order_details
LIMIT 5;


-- Fill in the query to construct the array

SELECT
	ARRAY(SELECT 
          -- Add the column with the values you want in the array
          	product_id 
          FROM 
          	ecommerce.ecomm_products
          WHERE
          	-- Add the column we want to filter by
         	product_weight_g = 2220)


-- Complete the below query

SELECT
	-- Use dot notation to get the price of each item
	order_id, STRUCT(items.price)
FROM 
	ecommerce.ecomm_orders,
    -- Add the right column to the UNNEST function
    UNNEST(order_items) items
WHERE order_id = 'a0e747c954a595b0e3458c87ab1a4958';


-- Add the correct items to finish our filtered CTE

-- Create a new CTE with the name orders
WITH orders AS (
  SELECT order_id
  -- Add the correct column for the order item details
  FROM ecommerce.ecomm_orders, UNNEST(order_items) AS items
  -- Fill in the correct column for the item price 
  WHERE items.price > 150
)

SELECT
	-- Aggregate to find the total number of orders
	COUNT(order_id),
	-- Add the column for the status of the order
	order_status
FROM ecommerce.ecomm_order_details od
JOIN orders o USING (order_id)
GROUP BY order_status


WITH payments AS (
  SELECT
    -- Use the correct aggregate to find the highest number of payments
    MAX(payment_sequential) AS num_payments,
    order_id
  FROM ecommerce.ecomm_payments 
  -- Group the results by order
  GROUP BY order_id)
     
SELECT
  -- Add the correct function to find the length or number of order items
  ARRAY_LENGTH(o.order_items) AS num_items,
  MAX(p.num_payments) AS max_payments
FROM ecommerce.ecomm_orders o
JOIN payments p
-- Add the correct keyword to join using the same column
USING (order_id)
-- Add the correct function to find the length or number of order items
GROUP BY ARRAY_LENGTH(o.order_items)


-- Create a CTE named "orders" that handles the queries for the ecomm_orders table

WITH orders AS (
SELECT order_id, items.product_id, items.price
FROM ecommerce.ecomm_orders, UNNEST(order_items) items 
WHERE items.price > 100
)

SELECT
	order_id,
	AVG(p.product_weight_g) as avg_weight
FROM orders o
JOIN ecommerce.ecomm_products p ON o.product_id = p.product_id
GROUP BY o.order_id;


-- Complete the query to count all the products over 5000 grams

SELECT
  product_category_name_english,
  
  -- Add the function name and conditional expression
  COUNTIF(product_weight_g > 5000)
FROM ecommerce.ecomm_products

-- Add the correct column for grouping
GROUP BY product_category_name_english; 


-- Write a query that finds all product categories and their average weight with an average weight over 10,000 grams

SELECT
	-- Add the product_category_name_english column and the average weight
    product_category_name_english,
    AVG(product_weight_g)
FROM ecommerce.ecomm_products
-- Add the GROUP BY statement
GROUP BY product_category_name_english
-- Add the HAVING condition on the average weight aggregate
HAVING AVG(product_weight_g) > 10000;



-- Finish the query below by adding the ANY_VALUE function

SELECT
  product_weight_g,
    -- Complete the query by adding the ANY_VALUE function on the product category column
	ANY_VALUE(product_category_name_english HAVING MAX(product_photos_qty)) AS random_product
FROM ecommerce.ecomm_products
GROUP BY product_weight_g;



-- Complete the query using LOGICAL_AND

SELECT
  customer_id,
  -- Fill in the LOGICAL_AND function
  LOGICAL_AND(order_status = "delivered") as all_delivered
FROM ecommerce.ecomm_order_details
GROUP BY customer_id;


-- Fill in the query to find the distinct product categories for each order

SELECT
    o.order_id,  
    -- Use the STRING_AGG to find distinct values and separate them by a comma with a space
    STRING_AGG(DISTINCT product_category_name_english, ', ') AS categories
FROM
    ecommerce.ecomm_orders o, UNNEST(order_items) items
JOIN
    ecommerce.ecomm_products p ON items.product_id = p.product_id
-- Find the number of items in the order_items column
WHERE ARRAY_LENGTH(o.order_items) > 1
GROUP BY
    order_id;


-- Complete the query to approximate the number of customers that have ordered each product

SELECT
  items.product_id,
  -- Add the correct syntax for the approximate distinct count
  APPROX_COUNT_DISTINCT(od.customer_id) AS estimated_unique_customers
FROM ecommerce.ecomm_orders o, UNNEST(o.order_items) items
JOIN ecommerce.ecomm_order_details od USING (order_id)
GROUP BY items.product_id;


-- Complete the query to approximate the top three customers that have ordered each product

SELECT
  items.product_id,
  -- Add the correct syntax for the approximate count of top customers
  APPROX_TOP_COUNT(customer_id, 3) AS top_customers
FROM ecommerce.ecomm_orders o, UNNEST(o.order_items) items
JOIN ecommerce.ecomm_order_details od USING (order_id)
GROUP BY items.product_id;


-- Complete the query to approximate the quantile bins for each customer's orders


SELECT
  od.customer_id,
  -- Add the correct syntax for the approximate quantiles
  APPROX_QUANTILES(items.price, 4) AS sales_quantiles
FROM ecommerce.ecomm_orders o, UNNEST(o.order_items) items
JOIN ecommerce.ecomm_order_details od USING (order_id)
-- Find results for customers with more than eight orders
WHERE ARRAY_LENGTH(o.order_items) > 8
GROUP BY od.customer_id;



-- Complete the query to order customers by the total amount spent

-- First, write a CTE to group customers and find their total amount spent
WITH orders AS (
  SELECT
  -- Add the correct columns and aggregate functions
  od.customer_id,
  SUM(items.price) as all_items
  FROM ecommerce.ecomm_orders o, UNNEST(o.order_items) items
  JOIN ecommerce.ecomm_order_details od USING (order_id)
  GROUP BY od.customer_id
)

SELECT
	customer_id,
	all_items,
-- Fill in the RANK window function and OVER clause
RANK() OVER(ORDER BY all_items DESC)
FROM orders
ORDER BY all_items DESC;


-- Complete the query to find the previous and next price for all items in an order

SELECT
  od.customer_id,
  items.price, 
-- Add the correct column for the item price
  LAG(items.price) OVER(
    -- Partition, or group the window function by the customer ID
    PARTITION BY od.customer_id
    -- Order data by the order purchase timestamp
    ORDER BY od.order_purchase_timestamp) as lag,
  LEAD(items.price) OVER(
    PARTITION BY od.customer_id 
    ORDER BY od.order_purchase_timestamp) as lead
FROM ecommerce.ecomm_orders o, UNNEST(o.order_items) items
JOIN ecommerce.ecomm_order_details od USING (order_id)
WHERE ARRAY_LENGTH(o.order_items) < 4
ORDER BY ARRAY_LENGTH(o.order_items) DESC;


-- Complete the query to find the rolling average

SELECT
  order_id,
  order_purchase_timestamp,
  -- Aggregate the price to find the average item price
  AVG(item.price) 
  OVER(
    -- Order the query by the purchase timestamp
    ORDER BY od.order_purchase_timestamp 
    -- Start the rows window as a between statement
     ROWS BETWEEN 9 PRECEDING
    -- Create the window for the nine previous rows
    -- Stop the window at the current row
    AND CURRENT ROW) as rolling_avg
FROM ecommerce.ecomm_order_details od
JOIN ecommerce.ecomm_orders o 
USING (order_id), unnest(o.order_items) as item
ORDER BY order_purchase_timestamp;


-- Complete the query to find the rolling average
SELECT
  order_id,
  order_purchase_timestamp,
  -- Aggregate the price to find the average
  AVG(item.price) 
  OVER(
    -- Order the query by the purchase timestamp
    ORDER BY order_purchase_timestamp 
    -- Build the complete row-based window
    ROWS BETWEEN CURRENT ROW AND 9 FOLLOWING) as forward_rolling_avg
FROM ecommerce.ecomm_order_details od
JOIN ecommerce.ecomm_orders o 
USING (order_id), unnest(o.order_items) as item
ORDER BY order_purchase_timestamp;


-- Complete the query to find the rolling average

SELECT
  order_id,
  order_purchase_timestamp,
-- Write the complete window statement for the five preceding and five following rows  
AVG(item.price) 
  OVER(
    ORDER BY order_purchase_timestamp
    ROWS BETWEEN 5 PRECEDING AND 5 FOLLOWING) as rolling_avg
FROM ecommerce.ecomm_order_details od
JOIN ecommerce.ecomm_orders o 
USING (order_id), unnest(o.order_items) as item
ORDER BY order_purchase_timestamp;


SELECT
  order_id,
  order_purchase_timestamp,
  
  AVG(item.price) OVER (
    ORDER BY order_purchase_timestamp
    ROWS BETWEEN 9 PRECEDING AND CURRENT ROW
  ) AS rolling_avg
FROM ecommerce.ecomm_order_details od
JOIN ecommerce.ecomm_orders o 
USING (order_id), UNNEST(o.order_items) AS item
QUALIFY rolling_avg > 500
ORDER BY order_purchase_timestamp;



WITH orders AS (
  SELECT order_id, item.product_id
  FROM ecommerce.ecomm_orders, UNNEST(order_items) item
  LIMIT 10
),
products AS (
  SELECT product_id
  FROM ecommerce.ecomm_products
  LIMIT 10000
)
SELECT
	COUNT(*) AS orders
FROM orders o
-- Add the correct join to include all the values from the "orders" table
LEFT OUTER JOIN products p ON p.product_id = o.product_id;


