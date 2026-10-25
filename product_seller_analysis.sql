-- Category performance; product name translation may be missing.
SELECT COALESCE(t.product_category_name_english,p.product_category_name,'unknown') AS category,
 COUNT(*) AS items_sold,COUNT(DISTINCT i.order_id) AS distinct_orders,
 ROUND(SUM(i.price),2) AS merchandise_revenue_brl
FROM order_items i JOIN orders o ON i.order_id=o.order_id
JOIN products p ON i.product_id=p.product_id
LEFT JOIN product_category_name_translation t ON p.product_category_name=t.product_category_name
WHERE o.order_status NOT IN ('canceled','unavailable')
GROUP BY 1 ORDER BY merchandise_revenue_brl DESC LIMIT 20;

-- Top sellers by merchandise value; seller revenue is not seller profit.
SELECT i.seller_id,s.seller_state,COUNT(DISTINCT i.order_id) AS orders,
 ROUND(SUM(i.price),2) AS merchandise_revenue_brl
FROM order_items i JOIN orders o ON i.order_id=o.order_id
JOIN sellers s ON i.seller_id=s.seller_id
WHERE o.order_status NOT IN ('canceled','unavailable')
GROUP BY 1,2 ORDER BY merchandise_revenue_brl DESC LIMIT 20;

-- Top products by units sold.
SELECT i.product_id,COUNT(*) AS units_sold,
 ROUND(SUM(i.price),2) AS merchandise_revenue_brl
FROM order_items i JOIN orders o ON i.order_id=o.order_id
WHERE o.order_status NOT IN ('canceled','unavailable')
GROUP BY 1 ORDER BY units_sold DESC LIMIT 20;
