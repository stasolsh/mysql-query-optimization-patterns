--Covering means the index has all columns needed by the query, so MySQL never touches the table (just the index).

SELECT user_id, created_at, total
FROM orders
WHERE user_id = 123
ORDER BY created_at DESC
LIMIT 50;


--Create index:

    CREATE INDEX idx_orders_covering
    ON orders(user_id, created_at, total);


--Then EXPLAIN should show Using index in Extra, meaning it’s reading only the index pages.

--Great for frequently run, read-heavy queries.