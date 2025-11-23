-- Sorting in subqueries that are only used to filter or join is often wasted work.
-- Naive
SELECT *
FROM users u
WHERE u.id IN (
    SELECT DISTINCT user_id
    FROM orders
    WHERE created_at >= '2025-11-01'
    ORDER BY created_at DESC
);


-- The inner ORDER BY does nothing useful for the outer query; it’s just extra work.
-- Better
SELECT *
FROM users u
WHERE u.id IN (
    SELECT user_id
    FROM orders
    WHERE created_at >= '2025-11-01'
);

-- Or better yet: EXISTS as above.