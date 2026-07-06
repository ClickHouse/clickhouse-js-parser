-- { echo }
SELECT
    (1, 2).-1,
    (1, 2).-2;

SELECT ().-1; -- { serverError NOT_FOUND_COLUMN_IN_BLOCK }

SELECT (1, 2, 3).-4; -- { serverError NOT_FOUND_COLUMN_IN_BLOCK }

SELECT (1, 2).-1000000000000000044885712678075916785549312; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT tupleElement((1, 'hello'), -10, 2);

DROP TABLE IF EXISTS a1;

DROP TABLE IF EXISTS a2;

CREATE TABLE a1
(
    i int,
    hash_key int
)
PARTITION BY (i, hash_key);

CREATE TABLE a2
(
    i int,
    j int,
    hash_key int
)
PARTITION BY (i, j, hash_key);

INSERT INTO a1;

INSERT INTO a2;

SELECT *
FROM (
        SELECT (_partition_value).-1
        FROM a1
        UNION ALL
        SELECT (_partition_value).-1
        FROM a2
    )
ORDER BY `all` ASC;

DROP TABLE a1;

DROP TABLE a2;

SET enable_analyzer = '1';

SET optimize_functions_to_subcolumns = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    tuple Tuple(b UInt32, c Int32)
)
ENGINE = Memory();

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT tupleElement(tuple, -1)
FROM test;

DROP TABLE test;