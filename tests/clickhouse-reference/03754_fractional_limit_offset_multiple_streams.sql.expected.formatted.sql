SET max_block_size = '65409';

SELECT count()
FROM (
        SELECT number
        FROM numbers_mt(2000)
        LIMIT 0.5
    );

SELECT count()
FROM (
        SELECT number
        FROM numbers_mt(2000)
        LIMIT 0.9
    );

SELECT count()
FROM (
        SELECT number
        FROM numbers_mt(2000)
        LIMIT 0.1
    );

SET max_block_size = '10';

SET max_block_size = '3';

SELECT count()
FROM (
        SELECT number
        FROM numbers_mt(2000)
        LIMIT 0.5
        OFFSET 500
    );

SELECT count()
FROM (
        SELECT number
        FROM numbers_mt(2000)
        LIMIT 0.25
        OFFSET 1200
    );

SELECT count()
FROM (
        SELECT number
        FROM numbers_mt(2000)
        LIMIT 0.5
        OFFSET 1000
    );

SELECT count()
FROM (
        SELECT number
        FROM numbers_mt(2000)
        LIMIT 0.9
        OFFSET 500
    );

SELECT count()
FROM (
        SELECT number
        FROM numbers_mt(2000)
        LIMIT 0.25
        OFFSET 500
    );

SELECT count()
FROM (
        SELECT number
        FROM numbers_mt(2000)
        LIMIT 0.5
        OFFSET 1500
    );

SELECT count()
FROM (
        SELECT number
        FROM numbers_mt(2000)
        LIMIT 0.5
        OFFSET 0.25
    );

SELECT count()
FROM (
        SELECT number
        FROM numbers_mt(2000)
        LIMIT 0.25
        OFFSET 0.6
    );

SELECT count()
FROM (
        SELECT number
        FROM numbers_mt(2000)
        LIMIT 0.5
        OFFSET 0.5
    );

SELECT count()
FROM (
        SELECT number
        FROM numbers_mt(2000)
        LIMIT 0.9
        OFFSET 0.25
    );

SELECT count()
FROM (
        SELECT number
        FROM numbers_mt(2000)
        LIMIT 0.25
        OFFSET 0.25
    );

SELECT count()
FROM (
        SELECT number
        FROM numbers_mt(2000)
        OFFSET 0.5
    );

SELECT count()
FROM (
        SELECT number
        FROM numbers_mt(2000)
        OFFSET 0.9
    );

SELECT count()
FROM (
        SELECT number
        FROM numbers_mt(2000)
        OFFSET 0.1
    );