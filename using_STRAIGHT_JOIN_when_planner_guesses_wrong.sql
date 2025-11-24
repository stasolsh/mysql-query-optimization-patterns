-- In rare cases, MySQL’s join order choice is bad.

SELECT STRAIGHT_JOIN u.email, o.id
FROM users u
JOIN orders o ON o.user_id = u.id
WHERE u.id IN (1,2,3);

-- STRAIGHT_JOIN forces the written join order: first users, then orders.
-- Use sparingly and only after verifying via EXPLAIN/benchmarks.