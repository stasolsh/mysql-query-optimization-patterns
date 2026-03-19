-- Pattern: Deep pagination with delayed join
-- Problem: OFFSET-based pagination becomes expensive on large pages because MySQL must skip many rows.
-- Better: First fetch only the IDs using an index-friendly query, then join back for full rows.

-- Example table:
-- posts(id, author_id, title, body, created_at)

-- Existing index:
-- CREATE INDEX idx_posts_created_at_id ON posts(created_at DESC, id DESC);

-- Less optimal query:
SELECT id, author_id, title, body, created_at
FROM posts
ORDER BY created_at DESC, id DESC
    LIMIT 100000, 20;

-- Possible issue:
-- MySQL must scan and discard 100000 rows before returning 20.
-- This gets slower as the OFFSET grows.

-- Better approach (delayed join):
SELECT p.id, p.author_id, p.title, p.body, p.created_at
FROM posts p
         JOIN (
    SELECT id
    FROM posts
    ORDER BY created_at DESC, id DESC
        LIMIT 100000, 20
) page_ids ON p.id = page_ids.id
ORDER BY p.created_at DESC, p.id DESC;

-- Why it can be faster:
-- 1) The inner query can use the index to scan only the narrow ID list
-- 2) It avoids reading large row payloads (like body) for skipped rows
-- 3) The outer join fetches full rows only for the final 20 results

-- Best long-term alternative (seek/keyset pagination):
-- Instead of OFFSET, use the last seen values:
-- WHERE (created_at, id) < ('2025-01-15 12:00:00', 987654)
-- ORDER BY created_at DESC, id DESC
-- LIMIT 20;

-- Notes:
-- Delayed join helps when OFFSET cannot be avoided (e.g. admin grids, legacy APIs).
-- Keyset pagination is usually the best option for user-facing infinite scroll or "next page" flows.