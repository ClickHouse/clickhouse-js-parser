SET enable_analyzer = '1';

DROP TABLE IF EXISTS test_multiple_array_join;

CREATE TABLE test_multiple_array_join
(
    id UInt64,
    person Nested(name String, surname String),
    properties Nested(key String, value String)
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO test_multiple_array_join;

INSERT INTO test_multiple_array_join;

SELECT *
FROM
    test_multiple_array_join
ARRAY JOIN person
ARRAY JOIN properties
ORDER BY `ALL` ASC;

DROP TABLE test_multiple_array_join;