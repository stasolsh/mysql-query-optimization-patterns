-- Heavy join between large tables, but only a small subset is needed.
-- Naive
SELECT o.*, u.email
FROM orders o
         JOIN users u ON u.id = o.user_id
WHERE o.created_at >= '2025-11-01';

-- If orders is huge and users is also big, and the filter is more naturally on users, flip the pattern:
-- Two-step
CREATE TEMPORARY TABLE active_users ENGINE=Memory AS
SELECT id
FROM users
WHERE last_login >= '2025-10-01';

CREATE INDEX idx_active_users_id ON active_users(id);

SELECT o.*, u.email
FROM orders o
         JOIN active_users au ON au.id = o.user_id
         JOIN users u ON u.id = au.id
WHERE o.created_at >= '2025-11-01';

-- Now the join is limited to “active” users only; the DB has less to do.
-- (Obviously this is more complex; use it for heavy analytics/reporting queries.)