-- Scenario: You query by (user_id, status) and sort by created_at:

SELECT id, user_id, total, created_at
FROM orders
WHERE user_id = 123
  AND status = 'PAID'
ORDER BY created_at DESC
    LIMIT 20;

-- Bad: only index on user_id
CREATE INDEX idx_orders_userid ON orders(user_id);


-- MySQL may still do filesort, read many rows and then filter by status.

-- Better: composite index
CREATE INDEX idx_orders_user_status_created
    ON orders(user_id, status, created_at);


-- Now MySQL can:

-- Do a range scan on (user_id, status)

-- Already read rows ordered by created_at

-- Stop after 20 rows ⇒ fast and avoids Using filesort.