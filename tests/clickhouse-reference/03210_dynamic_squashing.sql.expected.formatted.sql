-- Tags: long
-- Random settings limits: index_granularity=(100, None)
SET allow_experimental_dynamic_type = '1';

SET max_block_size = '1000';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    d Dynamic
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test SELECT multiIf(number < 1000, NULL::Dynamic(max_types = 1), number < 3000, range(number % 5)::Dynamic(max_types = 1), number::Dynamic(max_types = 1))
FROM numbers(100000);

SELECT DISTINCT
    dynamicType(d) AS type,
    isDynamicElementInSharedData(d) AS flag
FROM test
ORDER BY type ASC;

DROP TABLE test;

CREATE TABLE test
(
    d Dynamic(max_types = 1)
)
ENGINE = MergeTree()
ORDER BY tuple();

TRUNCATE TABLE test;

INSERT INTO test SELECT multiIf(number < 1000, 'Str'::Dynamic(max_types = 1), number < 3000, range(number % 5)::Dynamic(max_types = 1), number::Dynamic(max_types = 1))
FROM numbers(100000);