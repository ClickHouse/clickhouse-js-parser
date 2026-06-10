SELECT number
FROM numbers_mt(10000)
WHERE number % 10 = 0
ORDER BY number ASC
LIMIT 3
OFFSET 990;

SELECT number
FROM numbers_mt(10000)
WHERE number % 10 = 0
ORDER BY number ASC
LIMIT 20
OFFSET 999
SETTINGS max_block_size = '31';