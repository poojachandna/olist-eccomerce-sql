-- Revenue definition: sum of order_items.price for non-canceled/non-unavailable orders.
-- Excludes freight; not profit. Aggregate items BEFORE joining to avoid fanout.
WITH order_value AS (
 SELECT order_id, SUM(price) AS merchandise_value, SUM(freight_value) AS freight_value
 FROM order_items GROUP BY order_id
)
SELECT COUNT(*) AS orders_with_items,
 ROUND(SUM(v.merchandise_value),2) AS merchandise_revenue_brl,
 ROUND(AVG(v.merchandise_value),2) AS avg_order_value_brl,
 ROUND(SUM(v.freight_value),2) AS freight_charged_brl
FROM orders o JOIN order_value v ON o.order_id=v.order_id
WHERE o.order_status NOT IN ('canceled','unavailable');

-- Monthly merchandise revenue and AOV.
WITH order_value AS (
 SELECT order_id,SUM(price) AS merchandise_value FROM order_items GROUP BY order_id
)
SELECT DATE_TRUNC('month',o.order_purchase_timestamp)::DATE AS order_month,
 COUNT(*) AS orders_with_items, ROUND(SUM(v.merchandise_value),2) AS revenue_brl,
 ROUND(AVG(v.merchandise_value),2) AS aov_brl
FROM orders o JOIN order_value v ON o.order_id=v.order_id
WHERE o.order_status NOT IN ('canceled','unavailable')
GROUP BY 1 ORDER BY 1;

-- Revenue by state.
WITH order_value AS (
 SELECT order_id,SUM(price) AS merchandise_value FROM order_items GROUP BY order_id
)
SELECT c.customer_state,COUNT(*) AS orders_with_items,
 ROUND(SUM(v.merchandise_value),2) AS revenue_brl,
 ROUND(AVG(v.merchandise_value),2) AS aov_brl
FROM orders o JOIN order_value v ON o.order_id=v.order_id
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.order_status NOT IN ('canceled','unavailable')
GROUP BY 1 ORDER BY revenue_brl DESC;

-- Payment methods: payment records, not unique orders; split payments possible.
SELECT payment_type, COUNT(*) AS payment_records,
 COUNT(DISTINCT order_id) AS distinct_orders,
 ROUND(SUM(payment_value),2) AS payment_value_brl
FROM order_payments GROUP BY 1 ORDER BY payment_value_brl DESC;
