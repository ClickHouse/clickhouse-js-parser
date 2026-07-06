DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    v Variant(Array(Nullable(String)))
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test SELECT ['hello', NULL, 'world'];

SELECT v.`Array(Nullable(String))`.`null`
FROM test;

DROP TABLE test;