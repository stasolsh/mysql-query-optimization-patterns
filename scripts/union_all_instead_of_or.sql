-- Pattern: Rewrite OR into UNION ALL for better index usage
-- Problem: OR across different indexed columns can lead to index_merge or poor plans.
-- Better: Split into separate queries so each branch can use the best index.

-- Example table:
-- orders(id, customer_id, sales_rep_id, status, created_at)

-- Existing indexes:
-- CREATE INDEX idx_orders_customer_id ON orders(customer_id);
-- CREATE INDEX idx_orders_sales_rep_id ON orders(sales_rep_id);

-- Less optimal query:
SELECT id, customer_id, sales_rep_id, status
FROM orders
WHERE customer_id = 101
   OR sales_rep_id = 101;

-- Possible issue:
-- MySQL may choose index_merge, or scan more rows than necessary.
-- This often becomes slower on large tables.

-- Better approach:
SELECT id, customer_id, sales_rep_id, status
FROM orders
WHERE customer_id = 101

UNION ALL

SELECT id, customer_id, sales_rep_id, status
FROM orders
WHERE sales_rep_id = 101
  AND customer_id <> 101; -- prevent duplicates

-- Why it can be faster:
-- 1) First SELECT uses idx_orders_customer_id
-- 2) Second SELECT uses idx_orders_sales_rep_id
-- 3) Each branch can use a clean, selective index lookup
-- 4) Often avoids less efficient index_merge plans

-- Notes:
-- Use UNION ALL (not UNION) when possible to avoid unnecessary duplicate elimination.
-- Add a de-duplication condition manually if overlap is possible.