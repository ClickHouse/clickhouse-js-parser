DROP TABLE IF EXISTS ttl_00933_2;

CREATE TABLE ttl_00933_2
(
    d DateTime,
    a Int DEFAULT 111 TTL d + toIntervalDay(1)
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY toDayOfMonth(d);

INSERT INTO ttl_00933_2;

INSERT INTO ttl_00933_2;

INSERT INTO ttl_00933_2;

INSERT INTO ttl_00933_2;

OPTIMIZE TABLE ttl_00933_2 FINAL;

SELECT a
FROM ttl_00933_2
ORDER BY a ASC;

CREATE TABLE ttl_00933_2
(
    d DateTime,
    a Int,
    b DEFAULT a * 2 TTL d + toIntervalDay(1)
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY toDayOfMonth(d);

INSERT INTO ttl_00933_2;

INSERT INTO ttl_00933_2;

INSERT INTO ttl_00933_2;

INSERT INTO ttl_00933_2;

SELECT
    a,
    b
FROM ttl_00933_2
ORDER BY a ASC;

CREATE TABLE ttl_00933_2
(
    d DateTime,
    a Int,
    b DEFAULT 222 TTL d + toIntervalDay(1)
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY toDayOfMonth(d);

INSERT INTO ttl_00933_2;

INSERT INTO ttl_00933_2;

INSERT INTO ttl_00933_2;

INSERT INTO ttl_00933_2;