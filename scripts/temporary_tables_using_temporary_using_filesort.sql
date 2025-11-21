-- In EXPLAIN, Extra value like:
-- Using temporary
-- Using filesort

-- Means MySQL is:
-- Building a temporary table for query execution (e.g., complex GROUP BY)
-- Doing an extra sort pass
-- Not always bad, but red flags for heavy queries.

-- Ways to reduce:
-- Add appropriate indexes for GROUP BY/ORDER BY.
-- Simplify ORDER BY expressions (avoid functions).
-- Break huge queries into a couple of smaller steps with temporary tables you control:

CREATE TEMPORARY TABLE recent_orders AS
SELECT *
FROM orders
WHERE created_at >= '2025-11-01';

SELECT user_id, COUNT(*)
FROM recent_orders
GROUP BY user_id;

-- Sometimes this is faster and easier for MySQL to plan.