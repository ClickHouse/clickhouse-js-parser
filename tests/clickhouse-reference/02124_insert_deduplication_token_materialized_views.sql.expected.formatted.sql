DROP TABLE IF EXISTS test SYNC;

DROP TABLE IF EXISTS test_mv_a SYNC;

DROP TABLE IF EXISTS test_mv_b SYNC;

DROP TABLE IF EXISTS test_mv_c SYNC;

SET deduplicate_blocks_in_dependent_materialized_views = '0';

CREATE TABLE test
(
    test String,
    A Int64,
    B Int64
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_02124/{table}', '1')
ORDER BY tuple();

CREATE MATERIALIZED VIEW test_mv_a
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_02124/{table}', '1')
ORDER BY tuple()
AS
SELECT
    test,
    A,
    count() AS c
FROM test
GROUP BY
    test,
    A;

CREATE MATERIALIZED VIEW test_mv_b
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_02124/{table}', '1')
ORDER BY tuple()
PARTITION BY A
AS
SELECT
    test,
    A,
    count() AS c
FROM test
GROUP BY
    test,
    A;

CREATE MATERIALIZED VIEW test_mv_c
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_02124/{table}', '1')
ORDER BY tuple()
AS
SELECT
    test,
    A,
    count() AS c
FROM test
GROUP BY
    test,
    A;

SET max_partitions_per_insert_block = '1';

INSERT INTO test SELECT
    'case1',
    number % 3,
    1
FROM numbers(9)
ORDER BY `ALL` ASC
SETTINGS materialized_views_ignore_errors = '1';

SET max_partitions_per_insert_block = '0';

INSERT INTO test SELECT
    'case1',
    number % 3,
    1
FROM numbers(9)
ORDER BY `ALL` ASC;

INSERT INTO test SELECT
    'case1',
    number % 3,
    2
FROM numbers(9)
ORDER BY `ALL` ASC;

SELECT
    (
        SELECT count()
        FROM test
        WHERE test = 'case1'
    ),
    (
        SELECT sum(c)
        FROM test_mv_a
        WHERE test = 'case1'
    ),
    (
        SELECT sum(c)
        FROM test_mv_b
        WHERE test = 'case1'
    ),
    (
        SELECT sum(c)
        FROM test_mv_c
        WHERE test = 'case1'
    );

SET deduplicate_blocks_in_dependent_materialized_views = '1';

INSERT INTO test SELECT
    'case2',
    number % 3,
    1
FROM numbers(9)
ORDER BY `ALL` ASC
SETTINGS materialized_views_ignore_errors = '1';

INSERT INTO test SELECT
    'case2',
    number % 3,
    1
FROM numbers(9)
ORDER BY `ALL` ASC;

INSERT INTO test SELECT
    'case2',
    number % 3,
    2
FROM numbers(9)
ORDER BY `ALL` ASC;

SELECT
    (
        SELECT count()
        FROM test
        WHERE test = 'case2'
    ),
    (
        SELECT sum(c)
        FROM test_mv_a
        WHERE test = 'case2'
    ),
    (
        SELECT sum(c)
        FROM test_mv_b
        WHERE test = 'case2'
    ),
    (
        SELECT sum(c)
        FROM test_mv_c
        WHERE test = 'case2'
    );

INSERT INTO test SELECT
    'case3',
    number % 3,
    1
FROM numbers(9)
ORDER BY `ALL` ASC
SETTINGS
    insert_deduplication_token = 'case3test1',
    materialized_views_ignore_errors = '1';

INSERT INTO test SELECT
    'case3',
    number % 3,
    1
FROM numbers(9)
ORDER BY `ALL` ASC
SETTINGS insert_deduplication_token = 'case3test1';

INSERT INTO test SELECT
    'case3',
    number % 3,
    2
FROM numbers(9)
ORDER BY `ALL` ASC
SETTINGS insert_deduplication_token = 'case3test2';

SELECT
    (
        SELECT count()
        FROM test
        WHERE test = 'case3'
    ),
    (
        SELECT sum(c)
        FROM test_mv_a
        WHERE test = 'case3'
    ),
    (
        SELECT sum(c)
        FROM test_mv_b
        WHERE test = 'case3'
    ),
    (
        SELECT sum(c)
        FROM test_mv_c
        WHERE test = 'case3'
    );

INSERT INTO test SELECT
    'case4',
    number % 3,
    1
FROM numbers(9)
ORDER BY `ALL` ASC
SETTINGS insert_deduplication_token = 'case4test1'; -- { serverError TOO_MANY_PARTS }

INSERT INTO test SELECT
    'case4',
    number % 3,
    2
FROM numbers(9)
ORDER BY `ALL` ASC
SETTINGS insert_deduplication_token = 'case4test2';

SELECT
    (
        SELECT count()
        FROM test
        WHERE test = 'case4'
    ),
    (
        SELECT sum(c)
        FROM test_mv_a
        WHERE test = 'case4'
    ),
    (
        SELECT sum(c)
        FROM test_mv_b
        WHERE test = 'case4'
    ),
    (
        SELECT sum(c)
        FROM test_mv_c
        WHERE test = 'case4'
    );

DROP TABLE test SYNC;

DROP TABLE test_mv_a SYNC;

DROP TABLE test_mv_b SYNC;

DROP TABLE test_mv_c SYNC;