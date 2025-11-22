-- NOT IN + NULLs can produce weird results and is often slower.

-- Naive
SELECT u.*
FROM users u
WHERE u.id NOT IN (
    SELECT user_id
    FROM banned_users
);

-- If banned_users.user_id contains NULL, the whole NOT IN logic can break (returns no rows).
-- Better
SELECT u.*
FROM users u
WHERE NOT EXISTS (
    SELECT 1
    FROM banned_users b
    WHERE b.user_id = u.id
);

-- Indexes:
CREATE INDEX idx_banned_users_user_id ON banned_users(user_id);