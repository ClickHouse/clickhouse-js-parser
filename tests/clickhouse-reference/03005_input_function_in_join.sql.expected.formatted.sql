DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    a Int8
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test SELECT x.number
FROM
    (
        SELECT number
        FROM `system`.numbers
        LIMIT 10
    ) AS x
INNER JOIN input('a UInt64') AS y
    ON x.number = y.a FORMAT CSV;

DROP TABLE test;