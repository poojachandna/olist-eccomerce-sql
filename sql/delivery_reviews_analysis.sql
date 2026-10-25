-- Delivered orders only; delivery lead time and on-time percentage.
SELECT COUNT(*) AS delivered_orders,
 ROUND(AVG(EXTRACT(EPOCH FROM (order_delivered_customer_date-order_purchase_timestamp))/86400)::NUMERIC,2) AS avg_delivery_days,
 ROUND(100.0*COUNT(*) FILTER (WHERE order_delivered_customer_date<=order_estimated_delivery_date)/NULLIF(COUNT(*),0),2) AS on_time_pct
FROM orders WHERE order_status='delivered'
AND order_purchase_timestamp IS NOT NULL
AND order_delivered_customer_date IS NOT NULL
AND order_estimated_delivery_date IS NOT NULL;

-- Monthly delivery reliability; ignore partial boundary months for interpretation.
SELECT DATE_TRUNC('month',order_purchase_timestamp)::DATE AS order_month,
 COUNT(*) AS delivered_orders,
 ROUND(100.0*COUNT(*) FILTER (WHERE order_delivered_customer_date<=order_estimated_delivery_date)/NULLIF(COUNT(*),0),2) AS on_time_pct
FROM orders WHERE order_status='delivered'
AND order_purchase_timestamp IS NOT NULL
AND order_delivered_customer_date IS NOT NULL
AND order_estimated_delivery_date IS NOT NULL
GROUP BY 1 ORDER BY 1;

-- Review score distribution (per review record, not per order).
SELECT review_score,COUNT(*) AS review_records
FROM order_reviews GROUP BY 1 ORDER BY 1;

-- Review score vs delivery timing. Aggregate reviews to one row per order first.
WITH review_per_order AS (
 SELECT order_id,AVG(review_score::NUMERIC) AS avg_review_score
 FROM order_reviews WHERE review_score IS NOT NULL GROUP BY order_id
)
SELECT CASE WHEN o.order_delivered_customer_date<=o.order_estimated_delivery_date
 THEN 'on_time' ELSE 'late' END AS delivery_group,
 COUNT(*) AS orders_with_reviews,
 ROUND(AVG(r.avg_review_score),2) AS avg_review_score
FROM orders o JOIN review_per_order r ON o.order_id=r.order_id
WHERE o.order_status='delivered'
AND o.order_delivered_customer_date IS NOT NULL
AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY 1 ORDER BY 1;
