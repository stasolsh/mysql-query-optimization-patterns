-- Example: Orders joined with line items; you only need aggregate per order.
-- Naive
SELECT o.id, o.user_id, SUM(oi.price * oi.qty) AS total
FROM orders o
         JOIN order_items oi ON oi.order_id = o.id
WHERE o.created_at >= '2025-11-01'
  AND o.status = 'PAID'
ORDER BY o.created_at DESC
    LIMIT 100;

-- MySQL must:
-- Join many line items
-- Aggregate
-- Then sort + limit
-- Better: isolate the join + aggregate in a derived table
SELECT o.id, o.user_id, agg.total
FROM orders o
         JOIN (
    SELECT order_id, SUM(price * qty) AS total
    FROM order_items
    GROUP BY order_id
) agg ON agg.order_id = o.id
WHERE o.created_at >= '2025-11-01'
  AND o.status = 'PAID'
ORDER BY o.created_at DESC
    LIMIT 100;

-- Also ensure indexes:
CREATE INDEX idx_orders_status_created ON orders(status, created_at);
CREATE INDEX idx_order_items_order ON order_items(order_id);

-- Sometimes the “naive” and “better” will be planned similarly, but this pattern often helps clarity and can help MySQL avoid doing unnecessary work.