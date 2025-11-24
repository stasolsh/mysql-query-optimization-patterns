-- Each index slows down INSERT, UPDATE, DELETE (they must all be maintained).

-- Check indexes with:
SHOW INDEX FROM orders;

-- If you have:
-- INDEX (user_id)
-- INDEX (user_id, status)

-- The first is often redundant, because the second starts with user_id and can serve many same queries.

--Remove truly unused ones:
ALTER TABLE orders DROP INDEX idx_orders_user_id;

-- Use the Performance Schema (events_statements_summary_by_digest, index usage tables) or monitoring tools to see which indexes are never used.