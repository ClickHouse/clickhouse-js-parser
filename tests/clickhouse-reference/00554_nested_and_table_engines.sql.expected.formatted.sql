DROP TABLE IF EXISTS nested;

CREATE TABLE nested
(
    x UInt8,
    n Nested(a UInt64, b String)
)
ENGINE = TinyLog();

INSERT INTO nested;

INSERT INTO nested;

SELECT *
FROM nested
ORDER BY x ASC;

SELECT
    x,
    n.a
FROM nested
ORDER BY x ASC;

SELECT
    n.a,
    n.b
FROM nested
ORDER BY n.a ASC;

CREATE TABLE nested
(
    x UInt8,
    n Nested(a UInt64, b String)
)
ENGINE = Log();

CREATE TABLE nested
(
    x UInt8,
    n Nested(a UInt64, b String)
)
ENGINE = StripeLog();

CREATE TABLE nested
(
    x UInt8,
    n Nested(a UInt64, b String)
)
ENGINE = Memory();

CREATE TABLE nested
(
    x UInt8,
    n Nested(a UInt64, b String)
)
ENGINE = MergeTree()
ORDER BY x;

DROP TABLE nested;