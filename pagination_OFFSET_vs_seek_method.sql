-- Classic pagination:

SELECT id, title
FROM posts
ORDER BY created_at DESC
    LIMIT 50 OFFSET 10000;

-- For big offsets, MySQL still has to skip many rows ⇒ slow.

-- Seek method (a lot faster):

-- First page
SELECT id, title, created_at
FROM posts
ORDER BY created_at DESC
    LIMIT 50;

-- Next page: send the last seen created_at, e.g. '2025-11-15 12:00:00'
SELECT id, title, created_at
FROM posts
WHERE created_at < '2025-11-15 12:00:00'
ORDER BY created_at DESC
    LIMIT 50;

-- Indexed on (created_at, id):

CREATE INDEX idx_posts_created_id ON posts(created_at DESC, id DESC);

-- Now MySQL can range-scan and stop, no large skip.