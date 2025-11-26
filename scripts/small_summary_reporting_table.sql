-- When you have heavy reports over large raw tables, precompute.
-- Raw:
SELECT DATE(created_at) AS d,
    COUNT(*) AS orders_count,
    SUM(total) AS revenue
FROM orders
WHERE created_at >= '2025-01-01'
GROUP BY DATE(created_at);

-- On millions of rows this is expensive every time.
-- Better: daily summary table
CREATE TABLE order_daily_summary (
                                     d DATE PRIMARY KEY,
                                     orders_count INT NOT NULL,
                                     revenue DECIMAL(18,2) NOT NULL
);

-- A nightly job:
INSERT INTO order_daily_summary (d, orders_count, revenue)
SELECT DATE(created_at) AS d,
    COUNT(*) AS orders_count,
    SUM(total) AS revenue
FROM orders
WHERE created_at >= CURDATE() - INTERVAL 1 DAY
  AND created_at <  CURDATE()
GROUP BY DATE(created_at)
ON DUPLICATE KEY UPDATE
                     orders_count = VALUES(orders_count),
                     revenue      = VALUES(revenue);

-- Then report:
SELECT *
FROM order_daily_summary
WHERE d >= '2025-01-01';

-- Near-instant vs re-aggregating raw data.