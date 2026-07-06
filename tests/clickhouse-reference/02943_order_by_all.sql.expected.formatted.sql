-- Tests that sort expression ORDER BY ALL
DROP TABLE IF EXISTS order_by_all;

CREATE TABLE order_by_all
(
    a String,
    b Nullable(Int32)
)
ENGINE = Memory();

INSERT INTO order_by_all;

SELECT '-- no modifiers';

SET enable_analyzer = '0';

SELECT
    a,
    b
FROM order_by_all
ORDER BY `ALL` ASC;

SELECT
    b,
    a
FROM order_by_all
ORDER BY `ALL` ASC;

SET enable_analyzer = '1';

SELECT
    a,
    b
FROM order_by_all
ORDER BY `ALL` ASC;

SELECT
    a,
    b
FROM order_by_all
ORDER BY `ALL` DESC;

SELECT
    b,
    a
FROM order_by_all
ORDER BY `ALL` ASC NULLS FIRST;

SELECT
    b,
    a
FROM order_by_all
ORDER BY `ALL` ASC NULLS LAST;

SELECT *
FROM order_by_all
ORDER BY `all` ASC;

DROP TABLE order_by_all;

CREATE TABLE order_by_all
(
    a String,
    b Nullable(Int32),
    `all` UInt64
)
ENGINE = Memory();

INSERT INTO order_by_all;

SELECT
    a,
    b,
    `all`
FROM order_by_all
ORDER BY `all` ASC; -- { serverError UNEXPECTED_EXPRESSION }

SELECT
    a,
    b,
    `all`
FROM order_by_all
ORDER BY `all` ASC
SETTINGS enable_order_by_all = false;

SELECT a
FROM order_by_all
ORDER BY `all` ASC; -- { serverError UNEXPECTED_EXPRESSION }

SELECT a
FROM order_by_all
ORDER BY `all` ASC
SETTINGS enable_order_by_all = false;

SELECT *
FROM order_by_all
ORDER BY `all` ASC
SETTINGS enable_order_by_all = false;

SELECT
    a,
    b AS `all`
FROM order_by_all
ORDER BY `all` ASC; -- { serverError UNEXPECTED_EXPRESSION }

SELECT
    a,
    b AS `all`
FROM order_by_all
ORDER BY `all` ASC
SETTINGS enable_order_by_all = false;

SELECT format('{} {}', a, b) AS `all`
FROM order_by_all
ORDER BY `all` ASC; -- { serverError UNEXPECTED_EXPRESSION }

SELECT format('{} {}', a, b) AS `all`
FROM order_by_all
ORDER BY `all` ASC
SETTINGS enable_order_by_all = false;

SELECT
    a,
    b,
    `all`
FROM order_by_all
ORDER BY
    `all` ASC,
    a ASC;