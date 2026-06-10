DROP TABLE IF EXISTS t0;

DROP TABLE IF EXISTS test_table_join_1;

DROP TABLE IF EXISTS test_table_join_2;

CREATE TABLE test_table_join_1
(
    id UInt8,
    value String
)
ENGINE = TinyLog();

CREATE TABLE test_table_join_2
(
    id UInt16,
    value String
)
ENGINE = TinyLog();

INSERT INTO test_table_join_1;

INSERT INTO test_table_join_2;

CREATE TABLE t0
(
    i Int64,
    j Int16
)
ENGINE = MergeTree()
ORDER BY i;

INSERT INTO t0;

SET join_algorithm = 'parallel_hash';

SELECT i
FROM
    t0
ANY INNER JOIN (
        SELECT 3 AS k
    ) AS x
    ON x.k = j;

INSERT INTO t0 SELECT
    number,
    number
FROM numbers_mt(100000)
WHERE number != 3;

SELECT *
FROM
    test_table_join_1 AS t1
ANY INNER JOIN test_table_join_2 AS t2
    USING (id)
ORDER BY
    id ASC,
    t1.value ASC;