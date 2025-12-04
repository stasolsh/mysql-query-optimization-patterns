-- For very big tables (billions of rows) with a strong time dimension, use partitioning.
-- Example: monthly partitions by created_at:
ALTER TABLE orders
    PARTITION BY RANGE (YEAR(created_at)*100 + MONTH(created_at)) (
    PARTITION p202501 VALUES LESS THAN (202502),
    PARTITION p202502 VALUES LESS THAN (202503),
    PARTITION pmax   VALUES LESS THAN MAXVALUE
    );

-- Then queries like:
SELECT *
FROM orders
WHERE created_at >= '2025-01-01'
  AND created_at <  '2025-02-01';

-- MySQL can “prune” and touch only relevant partitions.
-- This doesn’t magically fix missing indexes, but it reduces data scanned.