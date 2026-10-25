-- Geographic order volume; each order joins to one customer row.
SELECT c.customer_state, COUNT(*) AS total_orders,
 ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER (),2) AS order_share_pct
FROM orders o JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_state ORDER BY total_orders DESC;

-- Orders per unique customer, by state. Cross-state customers may appear in multiple states.
SELECT c.customer_state, COUNT(*) AS total_orders,
 COUNT(DISTINCT c.customer_unique_id) AS unique_customers,
 ROUND(COUNT(*)::NUMERIC/NULLIF(COUNT(DISTINCT c.customer_unique_id),0),2) AS orders_per_customer
FROM orders o JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_state ORDER BY orders_per_customer DESC, total_orders DESC;
