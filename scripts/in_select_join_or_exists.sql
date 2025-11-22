-- Naive
SELECT o.*
FROM orders o
WHERE o.user_id IN (
    SELECT u.id
    FROM users u
    WHERE u.country = 'BG'
);

-- Problems:
-- Subquery might be executed inefficiently or treated as a dependent subquery.
-- Harder for MySQL to use good join strategies.

-- Better: JOIN
SELECT o.*
FROM orders o
         JOIN users u ON o.user_id = u.id
WHERE u.country = 'BG';

-- Indexes that help:
CREATE INDEX idx_users_country_id ON users(country, id);
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- Or if you only need existence:

SELECT o.*
FROM orders o
WHERE EXISTS (
    SELECT 1
    FROM users u
    WHERE u.id = o.user_id
      AND u.country = 'BG'
);

-- EXISTS is often more semantically clear for “filter by existence”.