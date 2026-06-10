CREATE TABLE test
(
    number UInt64
)
ENGINE = MergeTree()
ORDER BY number;

SYSTEM STOP MERGES test;

INSERT INTO test SELECT number
FROM numbers(100000);

SELECT '-- count';

SELECT
    count(),
    _part
FROM test
GROUP BY _part
ORDER BY _part ASC;

SELECT
    count() > 0
    AND count() < 100000,
    _part
FROM test
WHERE rand(1) % 2 = 1
GROUP BY _part
ORDER BY _part ASC;

SELECT
    count() > 0
    AND count() < 100000,
    _part
FROM test
WHERE rand(2) % 2 = 1
GROUP BY _part
ORDER BY _part ASC
SETTINGS optimize_use_implicit_projections = '0';

SELECT
    count() > 0
    AND count() < 100000,
    _part
FROM test
WHERE rand(3) % 2 = 1
GROUP BY _part
ORDER BY _part ASC
SETTINGS optimize_trivial_count_query = '0';

SELECT
    count() > 0
    AND count() < 100000,
    _part
FROM test
WHERE rand(4) % 2 = 1
GROUP BY _part
ORDER BY _part ASC
SETTINGS
    optimize_trivial_count_query = '0',
    optimize_use_implicit_projections = '0';