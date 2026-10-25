-- Overall repeat purchase rate. Unique ID identifies shoppers across order-specific customer IDs.
WITH per_customer AS (
 SELECT c.customer_unique_id,COUNT(DISTINCT o.order_id) AS order_count
 FROM orders o JOIN customers c ON o.customer_id=c.customer_id
 WHERE c.customer_unique_id IS NOT NULL
 AND o.order_status NOT IN ('canceled','unavailable')
 GROUP BY c.customer_unique_id
)
SELECT COUNT(*) AS customers,
 COUNT(*) FILTER (WHERE order_count>1) AS repeat_customers,
 ROUND(100.0*COUNT(*) FILTER (WHERE order_count>1)/NULLIF(COUNT(*),0),2) AS repeat_rate_pct,
 ROUND(AVG(order_count),2) AS avg_orders_per_customer
FROM per_customer;

-- First-time vs repeat orders by month (using valid orders only).
WITH numbered AS (
 SELECT c.customer_unique_id,o.order_id,o.order_purchase_timestamp,
 ROW_NUMBER() OVER (PARTITION BY c.customer_unique_id ORDER BY o.order_purchase_timestamp,o.order_id) AS purchase_number
 FROM orders o JOIN customers c ON o.customer_id=c.customer_id
 WHERE o.order_status NOT IN ('canceled','unavailable')
 AND o.order_purchase_timestamp IS NOT NULL AND c.customer_unique_id IS NOT NULL
)
SELECT DATE_TRUNC('month',order_purchase_timestamp)::DATE AS order_month,
 COUNT(*) FILTER (WHERE purchase_number=1) AS first_orders,
 COUNT(*) FILTER (WHERE purchase_number>1) AS repeat_orders,
 ROUND(100.0*COUNT(*) FILTER (WHERE purchase_number>1)/NULLIF(COUNT(*),0),2) AS repeat_order_share_pct
FROM numbered GROUP BY 1 ORDER BY 1;

-- Customer value distribution (merchandise only; excludes freight).
WITH order_value AS (
 SELECT order_id,SUM(price) AS merchandise_value FROM order_items GROUP BY order_id
), per_customer AS (
 SELECT c.customer_unique_id,COUNT(*) AS orders,
 SUM(v.merchandise_value) AS lifetime_merchandise_value
 FROM orders o JOIN customers c ON o.customer_id=c.customer_id
 JOIN order_value v ON o.order_id=v.order_id
 WHERE o.order_status NOT IN ('canceled','unavailable')
 AND c.customer_unique_id IS NOT NULL GROUP BY c.customer_unique_id
)
SELECT COUNT(*) AS customers,ROUND(AVG(lifetime_merchandise_value),2) AS avg_customer_value_brl,
 ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY lifetime_merchandise_value)::NUMERIC,2) AS median_customer_value_brl,
 ROUND(MAX(lifetime_merchandise_value),2) AS max_customer_value_brl
FROM per_customer;
