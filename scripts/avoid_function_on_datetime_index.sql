-- Pattern: Avoid wrapping indexed datetime columns in functions
-- Problem: Applying DATE() to an indexed DATETIME/TIMESTAMP column prevents efficient index range scans.
-- Better: Rewrite the predicate as a half-open range.

-- Example table:
-- orders(id, customer_id, status, created_at)

-- Existing index:
-- CREATE INDEX idx_orders_created_at ON orders(created_at);

-- Less optimal query:
SELECT id, customer_id, status, created_at
FROM orders
WHERE DATE(created_at) = '2025-01-15';

-- Possible issue:
-- MySQL cannot efficiently use idx_orders_created_at for a range scan
-- because the function DATE() is applied to the indexed column.
-- This can lead to scanning many more rows than necessary.

-- Better approach:
SELECT id, customer_id, status, created_at
FROM orders
WHERE created_at >= '2025-01-15 00:00:00'
  AND created_at <  '2025-01-16 00:00:00';

-- Why it is faster:
-- 1) MySQL can use idx_orders_created_at as a proper range scan
-- 2) Fewer rows are examined
-- 3) Better performance on large tables
-- 4) This pattern also works well with ORDER BY created_at

-- Notes:
-- Prefer half-open ranges [start, end) for date filtering.
-- This avoids edge-case issues with time precision.
-- The same idea applies to YEAR(), MONTH(), and other functions on indexed date columns.