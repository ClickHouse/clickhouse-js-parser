SET max_block_size = '10';

SELECT number
FROM numbers(20)
ORDER BY number ASC
LIMIT 0.5;

SELECT number
FROM numbers(20)
ORDER BY number ASC
LIMIT 0.9;

SELECT number
FROM numbers(10)
ORDER BY number ASC
LIMIT 0.1;

SET max_block_size = '3';

SELECT number
FROM numbers(20)
ORDER BY number ASC
LIMIT 0.5
OFFSET 5;

SELECT number
FROM numbers(20)
ORDER BY number ASC
LIMIT 0.25
OFFSET 12;

SELECT number
FROM numbers(20)
ORDER BY number ASC
LIMIT 0.5
OFFSET 10;

SELECT number
FROM numbers(20)
ORDER BY number ASC
LIMIT 0.9
OFFSET 5;

SELECT number
FROM numbers(15)
ORDER BY number ASC
LIMIT 0.5
OFFSET 5;

SELECT number
FROM numbers(14)
ORDER BY number ASC
LIMIT 0.5
OFFSET 5;

SELECT number
FROM numbers(20)
ORDER BY number ASC
LIMIT 0.25
OFFSET 5;

SELECT number
FROM numbers(20)
ORDER BY number ASC
LIMIT 0.5
OFFSET 15;

SELECT number
FROM numbers(20)
ORDER BY number ASC
LIMIT 0.05
OFFSET 5;

SELECT number
FROM numbers(20)
ORDER BY number ASC
LIMIT 0.5
OFFSET 0.25;

SELECT number
FROM numbers(20)
ORDER BY number ASC
LIMIT 0.25
OFFSET 0.6;

SELECT number
FROM numbers(20)
ORDER BY number ASC
LIMIT 0.5
OFFSET 0.5;

SELECT number
FROM numbers(20)
ORDER BY number ASC
LIMIT 0.9
OFFSET 0.25;

SELECT number
FROM numbers(20)
ORDER BY number ASC
LIMIT 0.25
OFFSET 0.25;

SELECT number
FROM numbers(15)
ORDER BY number ASC
LIMIT 0.5
OFFSET 0.33;

SELECT number
FROM numbers(20)
ORDER BY number ASC
LIMIT 0.05
OFFSET 0.25;

SELECT number
FROM numbers(20)
ORDER BY number ASC
OFFSET 0.5;

SELECT number
FROM numbers(20)
ORDER BY number ASC
OFFSET 0.9;

SELECT number
FROM numbers(10)
ORDER BY number ASC
OFFSET 0.1;