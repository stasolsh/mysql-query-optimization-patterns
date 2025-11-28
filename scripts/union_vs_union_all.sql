-- UNION removes duplicates → extra sort / hash.
-- Naive
SELECT user_id
FROM orders
WHERE status = 'PAID'
UNION
SELECT user_id
FROM orders
WHERE status = 'SHIPPED';

-- If you know they can’t overlap or you don’t care about duplicates:
-- Better
SELECT user_id
FROM orders
WHERE status = 'PAID'
UNION ALL
SELECT user_id
FROM orders
WHERE status = 'SHIPPED';

-- No dedup step → faster.