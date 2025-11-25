-- Huge updates can lock many rows and thrash the buffer pool.
-- Naive
UPDATE orders
SET status = 'ARCHIVED'
WHERE created_at < '2020-01-01';

-- For millions of rows, this is painful.
-- Better: batch in chunks
UPDATE orders
SET status = 'ARCHIVED'
WHERE created_at < '2020-01-01'
    LIMIT 10000;

-- Run this repeatedly in a loop from app / script until rows affected = 0.
-- Also ensure an index:
CREATE INDEX idx_orders_created_at ON orders(created_at);

-- Without index on the filter column, each batch still scans a lot of rows.