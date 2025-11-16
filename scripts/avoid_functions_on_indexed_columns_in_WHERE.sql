-- When you wrap an indexed column in a function, MySQL often can’t use the index efficiently.

-- Example: date filter
-- BAD
SELECT id, total
FROM orders
WHERE DATE(created_at) = '2025-11-15';

-- DATE(created_at) blocks the index.

-- Better: range predicate
SELECT id, total
FROM orders
WHERE created_at >= '2025-11-15 00:00:00'
  AND created_at <  '2025-11-16 00:00:00';

-- Now an index on created_at (or composite starting with it) can be used with range type.

-- Same idea for LOWER(column), TRIM(column), etc.—either:
-- Store normalized data (e.g., all lowercase), or Use a generated column with its own index:

ALTER TABLE users
    ADD COLUMN email_norm VARCHAR(255)
        GENERATED ALWAYS AS (LOWER(email)) STORED,
  ADD INDEX idx_users_email_norm (email_norm);

SELECT *
FROM users
WHERE email_norm = 'user@example.com';