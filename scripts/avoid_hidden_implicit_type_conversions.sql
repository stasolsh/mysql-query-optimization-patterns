-- If user_id is an INT, but you compare it with a string:

SELECT * FROM orders WHERE user_id = '123';  -- string literal

-- MySQL usually converts the string to INT and still can use the index.
-- But if types get more complex (collations, charsets), you can get surprises.

-- Bad cases:

WHERE string_col = 123 -- numeric literal on varchar

-- MySQL might cast string_col to number and ignore the index. Always use the correct type literal and column types.