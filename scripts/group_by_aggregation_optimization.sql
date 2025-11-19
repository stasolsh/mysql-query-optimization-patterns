-- Example:

SELECT user_id, COUNT(*) AS orders_count
FROM orders
WHERE created_at >= '2025-11-01'
GROUP BY user_id;

-- Good index:

CREATE INDEX idx_orders_created_user ON orders(created_at, user_id);

-- That helps because:
-- MySQL can read rows already grouped by user_id within the created_at range.

-- For some queries, it can use index-only scans.

-- For aggregations over large tables, consider:
-- Pre-aggregated summary tables updated periodically (daily stats, etc).
-- Using ROLLUP or window functions in MySQL 8 where appropriate.