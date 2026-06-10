CREATE TABLE t
(
    a String,
    b String,
    c String,
    d String
)
ORDER BY (a, b, c, d)
SETTINGS index_granularity = '10';

INSERT INTO t SELECT
    intDiv(number, 50),
    intDiv(number, 50),
    0,
    number % 10
FROM numbers(50 + 10);

SELECT count()
FROM t
WHERE a = '0'
    AND b = '0'
    AND (c, d) IN ('0', '5');

SELECT count()
FROM t
WHERE a = '0'
    AND b = '0'
    AND (c, d) IN ('0', '5')
SETTINGS optimize_use_implicit_projections = '0';

-- Have some granules where all rows pass the filter.
INSERT INTO t SELECT
    intDiv(number, 100),
    intDiv(number, 100),
    0,
    intDiv(number, 33)
FROM numbers(100 + 10);

SELECT count()
FROM t
WHERE a = '0'
    AND b = '0'
    AND (c, d) IN ('0', '2');

SELECT count()
FROM t
WHERE a = '0'
    AND b = '0'
    AND (c, d) IN ('0', '2')
SETTINGS optimize_use_implicit_projections = '0';