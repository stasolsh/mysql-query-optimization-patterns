-- Naive
SELECT *
FROM orders
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY);

-- Index on created_at is usable, but NOW() is evaluated repeatedly, and sometimes planners mis-estimate.
-- For super-hot queries, you can simplify and stabilize the predicate:

-- Better: bind parameter
-- From your app:
-- compute once in app:
cutoff = 2025-11-08 12:00:00

SELECT *
FROM orders
WHERE created_at >= ?;   -- bind cutoff

-- Still uses the same index but avoids dynamic expressions inside the SQL text. Easier for query cache/plan cache (in engines that have it).