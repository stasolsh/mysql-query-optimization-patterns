-- BAD (if the table has many columns, big blobs, etc.)
SELECT *
FROM orders
WHERE user_id = 123
ORDER BY created_at DESC
    LIMIT 50;

-- Problems:
-- Reads more data from disk/memory
-- May prevent index-only scans (covering index can’t cover “all columns” if you don’t know which ones are needed).

--Better:

SELECT id, user_id, total, created_at
FROM orders
WHERE user_id = 123
ORDER BY created_at DESC
    LIMIT 50;

--Ask only for the columns you need, especially in hot endpoints (e.g., API list calls).