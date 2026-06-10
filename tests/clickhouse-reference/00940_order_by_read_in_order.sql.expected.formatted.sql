DROP TABLE IF EXISTS pk_order;

SET optimize_read_in_order = '1';

CREATE TABLE pk_order
(
    a UInt64,
    b UInt64,
    c UInt64,
    d UInt64
)
ENGINE = MergeTree()
ORDER BY (a, b);

INSERT INTO pk_order (a, b, c, d);

INSERT INTO pk_order (a, b, c, d);

INSERT INTO pk_order (a, b, c, d);

SELECT b
FROM pk_order
ORDER BY
    a ASC,
    b ASC;

SELECT a
FROM pk_order
ORDER BY
    a ASC,
    b ASC;

SELECT
    a,
    b
FROM pk_order
ORDER BY
    a ASC,
    b ASC;

SELECT
    a,
    b
FROM pk_order
ORDER BY
    a DESC,
    b ASC;

SELECT
    a,
    b
FROM pk_order
ORDER BY
    a ASC,
    b DESC;

SELECT
    a,
    b
FROM pk_order
ORDER BY
    a DESC,
    b DESC;

SELECT a
FROM pk_order
ORDER BY a DESC;

SELECT
    a,
    b,
    c
FROM pk_order
ORDER BY
    a ASC,
    b ASC,
    c ASC;

SELECT
    a,
    b,
    c
FROM pk_order
ORDER BY
    a DESC,
    b ASC,
    c ASC;

SELECT
    a,
    b,
    c
FROM pk_order
ORDER BY
    a ASC,
    b DESC,
    c ASC;

SELECT
    a,
    b,
    c
FROM pk_order
ORDER BY
    a ASC,
    b ASC,
    c DESC;

SELECT
    a,
    b,
    c
FROM pk_order
ORDER BY
    a DESC,
    b DESC,
    c ASC;

SELECT
    a,
    b,
    c
FROM pk_order
ORDER BY
    a DESC,
    b ASC,
    c DESC;

SELECT
    a,
    b,
    c
FROM pk_order
ORDER BY
    a ASC,
    b DESC,
    c DESC;

SELECT
    a,
    b,
    c
FROM pk_order
ORDER BY
    a DESC,
    b DESC,
    c DESC;

CREATE TABLE pk_order
(
    d DateTime,
    a Int32,
    b Int32
)
ENGINE = MergeTree()
ORDER BY (d, a)
PARTITION BY toDate(d)
SETTINGS index_granularity = '1';

INSERT INTO pk_order SELECT
    toDateTime('2019-05-05 00:00:00') + toIntervalDay(number % 10),
    number,
    intHash32(number)
FROM numbers(100);

SET max_block_size = '1';

-- Currently checking number of read rows while reading in pk order not working precise. TODO: fix it.
-- SET max_rows_to_read = 10;
SELECT d
FROM pk_order
ORDER BY d ASC
LIMIT 5;

SELECT
    d,
    b
FROM pk_order
ORDER BY
    d ASC,
    b ASC
LIMIT 5;

SELECT
    d,
    a
FROM pk_order
ORDER BY
    d DESC,
    a DESC
LIMIT 5;

SELECT
    d,
    a
FROM pk_order
ORDER BY
    d DESC,
    -a ASC
LIMIT 5;

SELECT toStartOfHour(d) AS d1
FROM pk_order
ORDER BY d1 ASC
LIMIT 5;

DROP TABLE pk_order;

CREATE TABLE pk_order
(
    a Int,
    b Int
)
ENGINE = MergeTree()
ORDER BY a / b;

INSERT INTO pk_order SELECT
    number % 10 + 1,
    number % 6 + 1
FROM numbers(100);

SELECT *
FROM pk_order
ORDER BY
    a / b ASC,
    a ASC
LIMIT 5;