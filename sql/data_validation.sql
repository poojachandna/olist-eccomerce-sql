-- Inspect imported row counts. All nine tables should have > 0 rows.
SELECT 'customers' AS table_name, COUNT(*) AS rows FROM customers
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL SELECT 'product_category_name_translation', COUNT(*) FROM product_category_name_translation;

-- Date coverage and statuses. 2018-09/10 are incomplete; exclude from growth conclusions.
SELECT MIN(order_purchase_timestamp) AS first_order,
       MAX(order_purchase_timestamp) AS last_order,
       COUNT(*) FILTER (WHERE order_purchase_timestamp IS NULL) AS missing_purchase_dates
FROM orders;
SELECT order_status, COUNT(*) AS orders FROM orders GROUP BY 1 ORDER BY 2 DESC;

-- Relationship quality.
SELECT COUNT(*) AS orders_without_customer
FROM orders o LEFT JOIN customers c ON o.customer_id=c.customer_id
WHERE c.customer_id IS NULL;
SELECT COUNT(*) AS items_without_product
FROM order_items i LEFT JOIN products p ON i.product_id=p.product_id
WHERE p.product_id IS NULL;
