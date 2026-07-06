CREATE TEMPORARY TABLE test
(
    arr Array(Array(LowCardinality(String)))
);

INSERT INTO test (arr);

SELECT arrayFilter((x -> 1), arr)
FROM test;