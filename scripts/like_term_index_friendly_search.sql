-- Wildcard at the start kills index use.
-- Naive
SELECT id, title
FROM posts
WHERE title LIKE '%mysql%';

-- Index on title won’t help much; MySQL must scan.
-- Improved with prefix search
SELECT id, title
FROM posts
WHERE title LIKE 'mysql%';

-- Now the index helps:

CREATE INDEX idx_posts_title ON posts(title);

-- If you really need substring search
-- Use FULLTEXT (for text search):

ALTER TABLE posts
    ADD FULLTEXT INDEX ft_posts_title (title);

SELECT id, title
FROM posts
WHERE MATCH(title) AGAINST ('+mysql +query' IN BOOLEAN MODE);

-- Much faster than %…% on big tables.