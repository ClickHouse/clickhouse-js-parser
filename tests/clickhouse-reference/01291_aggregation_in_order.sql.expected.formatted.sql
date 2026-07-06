DROP TABLE IF EXISTS pk_order;

SET optimize_aggregation_in_order = '1';

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

-- Order after group by in order is determined
SELECT
    a,
    b
FROM pk_order
GROUP BY
    a,
    b
ORDER BY
    a ASC,
    b ASC;

SELECT a
FROM pk_order
GROUP BY a
ORDER BY a ASC;

SELECT
    a,
    b,
    sum(c),
    avg(d)
FROM pk_order
GROUP BY
    a,
    b
ORDER BY
    a ASC,
    b ASC;

SELECT
    a,
    sum(c),
    avg(d)
FROM pk_order
GROUP BY a
ORDER BY a ASC;

SELECT
    -a,
    sum(c),
    avg(d)
FROM pk_order
GROUP BY -a
ORDER BY -a ASC;

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

SELECT
    d,
    max(b)
FROM pk_order
GROUP BY
    d,
    a
ORDER BY
    d ASC,
    a ASC
LIMIT 5;

SELECT
    toString(d),
    avg(a)
FROM pk_order
GROUP BY toString(d)
ORDER BY toString(d) ASC
LIMIT 5;

SELECT
    toStartOfHour(d) AS d1,
    min(a),
    max(b)
FROM pk_order
GROUP BY d1
ORDER BY d1 ASC
LIMIT 5;

DROP TABLE pk_order;