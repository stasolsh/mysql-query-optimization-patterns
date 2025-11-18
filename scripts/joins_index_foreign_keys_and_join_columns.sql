-- Examp0le schema:

CREATE TABLE users (
                       id BIGINT PRIMARY KEY,
                       email VARCHAR(255),
                       created_at DATETIME
);

CREATE TABLE orders (
                        id BIGINT PRIMARY KEY,
                        user_id BIGINT,
                        total DECIMAL(10,2),
                        created_at DATETIME,
                        INDEX idx_orders_user_id (user_id),
                        CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Query:

SELECT u.email, o.id, o.total
FROM orders o
         JOIN users u ON o.user_id = u.id
WHERE o.created_at >= '2025-11-01';

-- Indexes that matter:
-- users.id is PK ⇒ indexed.
-- orders.user_id is indexed (good).
-- Considering the WHERE, you might also add:

CREATE INDEX idx_orders_created_user ON orders(created_at, user_id);

-- Now the planner can:
-- Filter orders by created_at using idx_orders_created_user.
-- Join from orders.user_id to users.id via primary key.

-- Bad: joining on unindexed columns leads to nested loops that scan many rows.