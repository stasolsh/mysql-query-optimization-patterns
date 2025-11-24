-- Bad pattern:
SELECT *
FROM orders
WHERE status = 'PAID'
   OR status = 'SHIPPED';

-- Equivalent, friendlier to indexes:
SELECT *
FROM orders
WHERE status IN ('PAID', 'SHIPPED');

-- Index:
CREATE INDEX idx_orders_status ON orders(status);


-- MySQL can use range on the index (status between 'PAID' and 'SHIPPED'), which is generally better.
-- When you have complex ORs mixing different columns:
SELECT *
FROM orders
WHERE (user_id = 123 AND status = 'PAID')
   OR (user_id = 456 AND status = 'PENDING');

-- Sometimes it’s faster to split into UNION:
SELECT * FROM orders
WHERE user_id = 123 AND status = 'PAID'
UNION ALL
SELECT * FROM orders
WHERE user_id = 456 AND status = 'PENDING';

-- Each branch can then use its own index.