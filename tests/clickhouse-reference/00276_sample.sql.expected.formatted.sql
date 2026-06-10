-- Tags: no-azure-blob-storage
-- no-azure-blob-storage: too slow
DROP TABLE IF EXISTS sample_00276;

SET allow_deprecated_syntax_for_merge_tree = '1';

SET min_insert_block_size_rows = '0', min_insert_block_size_bytes = '0';

SET max_block_size = '10';

CREATE TABLE sample_00276
(
    d Date DEFAULT '2000-01-01',
    x UInt8
)
ENGINE = MergeTree(d, x, x, 10);

INSERT INTO sample_00276 (x) SELECT toUInt8(number) AS x
FROM `system`.numbers
LIMIT 256;

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276;

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 1;

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 1/10;

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 1/10;

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 1/10;

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 10/100;

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 1/10;

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 2/100;

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 1/10 OFFSET 1/10;

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 1/10 OFFSET 9/10;

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 1/10 OFFSET 10/10;

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 1/10 OFFSET 19/20;

SELECT count() >= 100
FROM sample_00276 SAMPLE 100;

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 1000;

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 1/2;

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 1/2 OFFSET 1/2;

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 1/2
SETTINGS parallel_replicas_count = '3';

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 1/2
SETTINGS
    parallel_replicas_count = '3',
    parallel_replica_offset = '0';

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 1/2
SETTINGS
    parallel_replicas_count = '3',
    parallel_replica_offset = '1';

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 1/2
SETTINGS
    parallel_replicas_count = '3',
    parallel_replica_offset = '2';

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 1/2 OFFSET 1/2
SETTINGS parallel_replicas_count = '3';

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 1/2 OFFSET 1/2
SETTINGS
    parallel_replicas_count = '3',
    parallel_replica_offset = '0';

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 1/2 OFFSET 1/2
SETTINGS
    parallel_replicas_count = '3',
    parallel_replica_offset = '1';

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 1/2 OFFSET 1/2
SETTINGS
    parallel_replicas_count = '3',
    parallel_replica_offset = '2';

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM (
        SELECT x
        FROM sample_00276 SAMPLE 1/10 OFFSET 0/10
        UNION ALL
        SELECT x
        FROM sample_00276 SAMPLE 1/10 OFFSET 1/10
        UNION ALL
        SELECT x
        FROM sample_00276 SAMPLE 1/10 OFFSET 2/10
        UNION ALL
        SELECT x
        FROM sample_00276 SAMPLE 1/10 OFFSET 3/10
        UNION ALL
        SELECT x
        FROM sample_00276 SAMPLE 1/10 OFFSET 4/10
        UNION ALL
        SELECT x
        FROM sample_00276 SAMPLE 1/10 OFFSET 5/10
        UNION ALL
        SELECT x
        FROM sample_00276 SAMPLE 1/10 OFFSET 6/10
        UNION ALL
        SELECT x
        FROM sample_00276 SAMPLE 1/10 OFFSET 7/10
        UNION ALL
        SELECT x
        FROM sample_00276 SAMPLE 1/10 OFFSET 8/10
        UNION ALL
        SELECT x
        FROM sample_00276 SAMPLE 1/10 OFFSET 9/10
    );

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 5/100 OFFSET 35/100;

SELECT
    count(),
    min(x),
    max(x),
    sum(x),
    uniqExact(x)
FROM sample_00276 SAMPLE 5/100 OFFSET 4/10;

SELECT count()
FROM (
        SELECT
            x,
            count() AS c
        FROM (
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 0/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 1/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 2/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 3/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 4/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 5/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 6/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 7/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 8/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 9/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 10/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 11/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 12/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 13/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 14/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 15/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 16/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 17/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 18/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 19/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 20/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 21/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 22/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 23/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 24/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 25/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 26/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 27/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 28/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 29/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 30/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 31/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 32/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 33/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 34/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 35/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 36/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 37/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 38/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 39/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 40/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 41/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 42/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 43/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 44/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 45/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 46/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 47/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 48/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 49/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 50/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 51/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 52/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 53/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 54/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 55/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 56/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 57/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 58/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 59/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 60/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 61/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 62/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 63/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 64/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 65/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 66/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 67/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 68/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 69/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 70/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 71/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 72/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 73/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 74/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 75/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 76/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 77/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 78/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 79/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 80/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 81/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 82/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 83/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 84/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 85/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 86/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 87/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 88/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 89/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 90/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 91/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 92/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 93/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 94/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 95/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 96/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 97/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 98/100
                UNION ALL
                SELECT *
                FROM sample_00276 SAMPLE 1/100 OFFSET 99/100
            )
        GROUP BY x
        HAVING c = 1
        ORDER BY x ASC
    );

DROP TABLE sample_00276;

SET max_block_size = '8192';

CREATE TABLE sample_00276
(
    d Date DEFAULT '2000-01-01',
    x UInt16
)
ENGINE = MergeTree(d, x, x, 10);

INSERT INTO sample_00276 (x) SELECT toUInt16(number) AS x
FROM `system`.numbers
LIMIT 65536;