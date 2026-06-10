-- https://github.com/ClickHouse/ClickHouse/issues/37729
SET enable_analyzer = '1';

DROP TABLE IF EXISTS nested_test;

DROP TABLE IF EXISTS join_test;

CREATE TABLE nested_test
(
    s String,
    nest Nested(x UInt64, y UInt64)
)
ENGINE = MergeTree()
ORDER BY s;

CREATE TABLE join_test
(
    id Int64,
    y UInt64
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO nested_test;

INSERT INTO join_test;

SELECT s
FROM
    nested_test AS t1
ARRAY JOIN nest
INNER JOIN join_test AS t2
    ON nest.y = t2.y
ORDER BY `ALL` ASC;