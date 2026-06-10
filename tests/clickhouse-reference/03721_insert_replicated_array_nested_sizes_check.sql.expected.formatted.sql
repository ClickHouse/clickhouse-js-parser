SET enable_analyzer = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    a Array(UInt64)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test SELECT range(number)
FROM
    numbers(3)
ARRAY JOIN range(number + 1);

SELECT *
FROM test;

DROP TABLE test;