-- Naive
SELECT DISTINCT u.id, u.email
FROM users u
         JOIN orders o ON o.user_id = u.id
WHERE o.status = 'PAID';

-- Here, you just want users who have paid orders, but the join duplicates users (one row per order).

-- Better: aggregate or EXISTS
SELECT u.id, u.email
FROM users u
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.user_id = u.id
      AND o.status = 'PAID'
);

-- Now no need for DISTINCT.

-- Or via GROUP BY:
SELECT u.id, u.email
FROM users u
         JOIN (
    SELECT user_id
    FROM orders
    WHERE status = 'PAID'
    GROUP BY user_id
) o ON u.id = o.user_id;

-- Why better:
-- DISTINCT performs a sort or hash to remove duplicates.
-- EXISTS stops at first match per user.