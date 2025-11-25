-- Use WHERE for row filtering before grouping; HAVING is for group filters. Misusing HAVING can cause unnecessary work.
-- Naive
SELECT user_id, COUNT(*) AS c
FROM orders
GROUP BY user_id
HAVING created_at >= '2025-11-01';

-- This groups all rows, then filters groups.
-- Better
SELECT user_id, COUNT(*) AS c
FROM orders
WHERE created_at >= '2025-11-01'
GROUP BY user_id;

-- Less data processed, better use of index on created_at.