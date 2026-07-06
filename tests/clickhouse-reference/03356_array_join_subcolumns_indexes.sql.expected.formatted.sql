-- Tags: no-parallel-replicas
SET enable_json_type = '1';

SET allow_experimental_variant_type = '1';

SET use_variant_as_common_type = '1';

SET enable_analyzer = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON(a Array(UInt32), b Array(UInt32), c UInt32),
    INDEX idx1 json.a TYPE set(0) GRANULARITY 1,
    INDEX idx2 json.c TYPE minmax() GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '1';

INSERT INTO test SELECT toJSONString(map('a', range(number % 3 + 1), 'b', range(number % 2 + 1), 'c', number))
FROM numbers(10);

SELECT json.a
FROM
    test
ARRAY JOIN json.b
WHERE has(json.a, 2);

EXPLAIN indexes = '1'
SELECT json.a
FROM
    test
ARRAY JOIN json.b
WHERE has(json.a, 2)
    AND json.c < 5;

DROP TABLE test;