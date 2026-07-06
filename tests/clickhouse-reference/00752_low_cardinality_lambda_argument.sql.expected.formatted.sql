SET allow_suspicious_low_cardinality_types = '1';

DROP TABLE IF EXISTS lc_lambda;

CREATE TABLE lc_lambda
(
    arr Array(LowCardinality(UInt64))
)
ENGINE = Memory();

INSERT INTO lc_lambda SELECT range(number)
FROM `system`.numbers
LIMIT 10;

SELECT arrayFilter((x -> x % 2 = 0), arr)
FROM lc_lambda;

DROP TABLE IF EXISTS test_array;

CREATE TABLE test_array
(
    resources_host Array(LowCardinality(String))
)
ENGINE = MergeTree()
ORDER BY resources_host;

INSERT INTO test_array;

SELECT arrayMap((i -> [resources_host[i]]), arrayEnumerate(resources_host))
FROM test_array;

SELECT arrayMap((x -> x + arrayMap((y -> x + y + toLowCardinality(1)), [])[1]), []);