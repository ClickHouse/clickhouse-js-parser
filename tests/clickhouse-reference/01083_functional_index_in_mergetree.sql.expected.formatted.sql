SET max_threads = '1';

CREATE TABLE IF NOT EXISTS functional_index_mergetree
(
    x Float64
)
ENGINE = MergeTree()
ORDER BY round(x);

INSERT INTO functional_index_mergetree;

SELECT *
FROM functional_index_mergetree
WHERE x > 7.42;

SELECT *
FROM functional_index_mergetree
WHERE x < 7.49;

SELECT *
FROM functional_index_mergetree
WHERE x < 7.5;

SELECT *
FROM functional_index_mergetree
WHERE NOT NOT x < 7.49;

SELECT *
FROM functional_index_mergetree
WHERE NOT NOT x < 7.5;

SELECT *
FROM functional_index_mergetree
WHERE NOT NOT x > 7.42;

SELECT *
FROM functional_index_mergetree
WHERE NOT x > 7.49;

SELECT *
FROM functional_index_mergetree
WHERE NOT x < 7.42;

SELECT *
FROM functional_index_mergetree
WHERE NOT x < 7.41;

SELECT *
FROM functional_index_mergetree
WHERE NOT x < 7.5;

SELECT *
FROM functional_index_mergetree
WHERE x > 7.41
    AND x < 7.51;

SELECT *
FROM functional_index_mergetree
WHERE NOT(x > 7.41
    AND x < 7.51);

SELECT *
FROM functional_index_mergetree
WHERE NOT x < 7.41
    AND NOT x > 7.49;

SELECT *
FROM functional_index_mergetree
WHERE NOT x < 7.42
    AND NOT x > 7.42;

SELECT *
FROM functional_index_mergetree
WHERE NOT x < 7.4
    AND NOT x > 7.49;

SELECT *
FROM functional_index_mergetree
WHERE NOT or(NOT x, toUInt64(x)
    AND NOT floor(x) > 6, x >= 7.42
    AND round(x) <= 7);

DROP TABLE functional_index_mergetree;