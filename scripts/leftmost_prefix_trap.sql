-- Pattern: Composite index leftmost prefix rule
-- Problem: A composite index is much less useful when the query skips the leading column.
-- Better: Match the query shape to the index, or add a more suitable index.

-- Example table:
-- users(id, country, city, last_login)

-- Existing composite index:
-- CREATE INDEX idx_users_country_city ON users(country, city);

-- Less optimal query:
SELECT id, country, city
FROM users
WHERE city = 'Munich';

-- Possible issue:
-- The index starts with country, but the query filters only by city.
-- MySQL cannot efficiently use idx_users_country_city for a selective lookup here.
-- It may scan many rows or fall back to a less efficient plan.

-- Better query shape (matches the index):
SELECT id, country, city
FROM users
WHERE country = 'Germany'
  AND city = 'Munich';

-- Alternative if city-only lookups are common:
-- CREATE INDEX idx_users_city ON users(city);

-- Why it matters:
-- 1) Composite indexes are most effective when filtering starts from the leftmost column
-- 2) (country, city) supports:
--      WHERE country = ...
--      WHERE country = ... AND city = ...
--    but not efficiently:
--      WHERE city = ...
-- 3) This is one of the most common indexing mistakes in real systems

-- Notes:
-- Think of a composite index as sorted first by country, then by city inside each country.
-- If you skip country, MySQL cannot jump directly to a single city efficiently.