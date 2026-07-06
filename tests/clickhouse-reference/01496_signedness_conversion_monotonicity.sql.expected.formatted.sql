DROP TABLE IF EXISTS test1;

CREATE TABLE test1
(
    i Int64
)
ENGINE = MergeTree()
ORDER BY i;

INSERT INTO test1;

SELECT count()
FROM test1
WHERE toInt16(i) = 1777;