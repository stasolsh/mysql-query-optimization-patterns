-- Schema:

CREATE TABLE posts (
                       id BIGINT PRIMARY KEY,
                       title VARCHAR(255)
);

CREATE TABLE tags (
                      id BIGINT PRIMARY KEY,
                      name VARCHAR(255)
);

CREATE TABLE post_tags (
                           post_id BIGINT NOT NULL,
                           tag_id BIGINT NOT NULL,
                           PRIMARY KEY (post_id, tag_id),
                           INDEX idx_post_tags_tag (tag_id),
                           FOREIGN KEY (post_id) REFERENCES posts(id),
                           FOREIGN KEY (tag_id) REFERENCES tags(id)
);

-- Query: posts with certain tags
-- Naive:
SELECT p.*
FROM posts p
         JOIN post_tags pt ON pt.post_id = p.id
         JOIN tags t ON t.id = pt.tag_id
WHERE t.name = 'mysql';


-- Better indexes:

CREATE INDEX idx_tags_name ON tags(name);
-- `post_tags` already has index on tag_id and PK(post_id,tag_id)

-- For multiple tags (e.g., posts that have both tag A and tag B):
-- Naive:

SELECT DISTINCT p.*
FROM posts p
         JOIN post_tags pt ON pt.post_id = p.id
         JOIN tags t ON t.id = pt.tag_id
WHERE t.name IN ('mysql', 'performance');

-- Better approach:

SELECT p.*
FROM posts p
         JOIN post_tags pt1 ON pt1.post_id = p.id
         JOIN tags t1 ON t1.id = pt1.tag_id AND t1.name = 'mysql'
         JOIN post_tags pt2 ON pt2.post_id = p.id
         JOIN tags t2 ON t2.id = pt2.tag_id AND t2.name = 'performance';

-- Now you’re explicitly requiring both tags; good indexes help.