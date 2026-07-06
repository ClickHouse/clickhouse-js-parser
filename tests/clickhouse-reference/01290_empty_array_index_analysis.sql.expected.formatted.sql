DROP TABLE IF EXISTS count_lc_test;

CREATE TABLE count_lc_test
(
    s LowCardinality(String),
    arr Array(LowCardinality(String)),
    num UInt64
)
ENGINE = MergeTree()
ORDER BY (s, arr);

INSERT INTO count_lc_test (num, arr);

SELECT '--- notEmpty';

SELECT *
FROM count_lc_test
WHERE notEmpty(arr);

SELECT *
FROM count_lc_test
WHERE empty(arr);

SELECT *
FROM count_lc_test
WHERE arr = [];

SELECT *
FROM count_lc_test
WHERE arr != [];

SELECT *
FROM count_lc_test
WHERE arr > [];

SELECT *
FROM count_lc_test
WHERE arr < [];

SELECT *
FROM count_lc_test
WHERE arr >= [];

SELECT *
FROM count_lc_test
WHERE arr <= [];

DROP TABLE count_lc_test;

CREATE TABLE count_lc_test
(
    s LowCardinality(String),
    arr Array(String),
    num UInt64
)
ENGINE = MergeTree()
ORDER BY (s, arr);