DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    a Date,
    b UInt32,
    c UInt64,
    p Nested(at1 String, at2 String)
)
ENGINE = MergeTree()
ORDER BY b
PARTITION BY a
SETTINGS index_granularity = '8192';

INSERT INTO test (a, b, c, p.at1, p.at2);

SELECT b
FROM
    test
ARRAY JOIN p
WHERE b = 1
    AND c IN (
        SELECT c
        FROM test
    );

DROP TABLE test;