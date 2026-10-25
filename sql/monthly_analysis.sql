-- Monthly order volumes (all statuses); note partial months at dataset boundaries.
SELECT DATE_TRUNC('month',order_purchase_timestamp)::DATE AS order_month,
 COUNT(*) AS total_orders
FROM orders WHERE order_purchase_timestamp IS NOT NULL
GROUP BY 1 ORDER BY 1;

-- Month-on-month change; do not interpret incomplete boundary months as business decline.
WITH monthly AS (
 SELECT DATE_TRUNC('month',order_purchase_timestamp)::DATE AS order_month,
 COUNT(*) AS total_orders FROM orders
 WHERE order_purchase_timestamp IS NOT NULL GROUP BY 1
), with_previous AS (
 SELECT *, LAG(total_orders) OVER (ORDER BY order_month) AS previous_month_orders
 FROM monthly
)
SELECT order_month, total_orders, previous_month_orders,
 ROUND(100.0*(total_orders-previous_month_orders)/NULLIF(previous_month_orders,0),2) AS mom_growth_pct
FROM with_previous ORDER BY order_month;

-- Full-year comparison (2017 only is a complete calendar year in this dataset).
SELECT EXTRACT(YEAR FROM order_purchase_timestamp)::INT AS order_year,
 COUNT(*) AS orders
FROM orders GROUP BY 1 ORDER BY 1;
