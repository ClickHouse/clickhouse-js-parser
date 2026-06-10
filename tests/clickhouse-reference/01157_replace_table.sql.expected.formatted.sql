-- Tags: no-ordinary-database
DROP TABLE IF EXISTS t;

DROP TABLE IF EXISTS dist;

DROP TABLE IF EXISTS buf;

DROP TABLE IF EXISTS `join`;

CREATE TABLE t
(
    n UInt64,
    s String DEFAULT 's' || toString(n)
)
ENGINE = Memory();

CREATE TABLE dist
(
    n int
)
ENGINE = Distributed(test_shard_localhost, currentDatabase(), t);

CREATE TABLE buf
(
    n int
)
ENGINE = Buffer(currentDatabase(), dist, 1, 10, 100, 10, 100, 1000, 1000);

SYSTEM STOP DISTRIBUTED SENDS dist;

INSERT INTO buf;

REPLACE TABLE buf
(
    n int
)
ENGINE = Distributed(test_shard_localhost, currentDatabase(), dist);

REPLACE TABLE dist
(
    n int
)
ENGINE = Buffer(currentDatabase(), t, 1, 10, 100, 10, 100, 1000, 1000);

SYSTEM STOP DISTRIBUTED SENDS buf;

INSERT INTO buf;

REPLACE TABLE buf
(
    n int
)
ENGINE = Buffer(currentDatabase(), dist, 1, 10, 100, 10, 100, 1000, 1000);

REPLACE TABLE dist
(
    n int
)
ENGINE = Distributed(test_shard_localhost, currentDatabase(), t);

INSERT INTO buf;

REPLACE TABLE buf
(
    n int
)
ENGINE = Null();

REPLACE TABLE dist
(
    n int
)
ENGINE = Null();

SELECT *
FROM t
ORDER BY n ASC;

-- table is not created if select fails
CREATE OR REPLACE TABLE `join`
ENGINE = Join(`ANY`, `INNER`, n) AS
SELECT *
FROM t
WHERE throwIf(n); -- { serverError FUNCTION_THROW_IF_VALUE_IS_NON_ZERO }

SELECT count()
FROM `system`.tables
WHERE database = currentDatabase()
    AND name = 'join';

-- table is created and filled
CREATE OR REPLACE TABLE `join`
ENGINE = Join(`ANY`, `INNER`, n) AS
SELECT *
FROM t;

SELECT *
FROM
    numbers(10) AS t
ANY INNER JOIN `join`
    ON t.number = `join`.n
ORDER BY n ASC;

-- table is not replaced if select fails
INSERT INTO t (n);

REPLACE TABLE `join`
ENGINE = Join(`ANY`, `INNER`, n) AS
SELECT *
FROM t
WHERE throwIf(n); -- { serverError FUNCTION_THROW_IF_VALUE_IS_NON_ZERO }

-- table is replaced
REPLACE TABLE `join`
ENGINE = Join(`ANY`, `INNER`, n) AS
SELECT *
FROM t;

SELECT name
FROM `system`.tables
WHERE database = currentDatabase()
ORDER BY name ASC;

DROP TABLE t;

DROP TABLE dist;

DROP TABLE buf;

DROP TABLE `join`;