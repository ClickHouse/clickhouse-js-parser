DROP TABLE IF EXISTS order_by_another;

CREATE TABLE order_by_another
(
    a Nullable(UInt64),
    b UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO order_by_another;

SELECT
    a,
    b
FROM order_by_another
ORDER BY
    a ASC NULLS LAST,
    b ASC
LIMIT 4;

SELECT
    a,
    b
FROM order_by_another
ORDER BY
    a ASC NULLS FIRST,
    b ASC
LIMIT 4;

SELECT
    a,
    b
FROM order_by_another
ORDER BY
    a DESC NULLS LAST,
    b ASC
LIMIT 4;

SELECT
    a,
    b
FROM order_by_another
ORDER BY
    a DESC NULLS FIRST,
    b ASC
LIMIT 4;

SELECT
    a,
    b
FROM order_by_another
ORDER BY
    a ASC NULLS LAST,
    b DESC
LIMIT 4;

SELECT
    a,
    b
FROM order_by_another
ORDER BY
    a ASC NULLS FIRST,
    b DESC
LIMIT 4;

SELECT
    a,
    b
FROM order_by_another
ORDER BY
    a DESC NULLS LAST,
    b DESC
LIMIT 4;

SELECT
    a,
    b
FROM order_by_another
ORDER BY
    a DESC NULLS FIRST,
    b DESC
LIMIT 4;