SELECT
    count(),
    uniq(dummy)
FROM remote('127.0.0.{2,3}', `system`.one)
SETTINGS distributed_group_by_no_merge = '1';

SELECT
    count(),
    uniq(dummy)
FROM remote('127.0.0.{2,3,4,5}', `system`.one)
SETTINGS distributed_group_by_no_merge = '1';

SELECT
    count(),
    uniq(dummy)
FROM remote('127.0.0.{2,3}', `system`.one)
LIMIT 1
SETTINGS distributed_group_by_no_merge = '1';

SET max_distributed_connections = '1';

SET max_threads = '1';

SELECT *
FROM (
        SELECT
            any(_shard_num) AS shard_num,
            count(),
            uniq(dummy)
        FROM remote('127.0.0.{2,3}', `system`.one)
    )
ORDER BY shard_num ASC
LIMIT 1
SETTINGS distributed_group_by_no_merge = '2';

SELECT *
FROM (
        SELECT
            any(_shard_num) AS shard_num,
            count(),
            uniq(dummy)
        FROM remote('127.0.0.{2,3}', `system`.one)
    )
ORDER BY shard_num ASC
LIMIT 1
OFFSET 1
SETTINGS distributed_group_by_no_merge = '2';

SELECT dummy AS d
FROM remote('127.0.0.{2,3}', `system`.one)
ORDER BY d ASC
SETTINGS distributed_group_by_no_merge = '2';

DROP TABLE IF EXISTS data_00184;

CREATE TABLE data_00184
ENGINE = Memory() AS
SELECT *
FROM numbers(2);

SELECT number
FROM remote('127.0.0.{2,3}', currentDatabase(), data_00184)
ORDER BY number DESC
SETTINGS distributed_group_by_no_merge = '2';

SELECT number
FROM remote('127.0.0.{2,3}', currentDatabase(), data_00184)
ORDER BY number DESC
LIMIT 1
SETTINGS distributed_group_by_no_merge = '2';

SELECT number
FROM remote('127.0.0.{2,3}', currentDatabase(), data_00184)
LIMIT 1 BY number
SETTINGS distributed_group_by_no_merge = '2';

SELECT number
FROM remote('127.0.0.{2,3}', currentDatabase(), data_00184)
LIMIT 1 BY number
LIMIT 1
SETTINGS distributed_group_by_no_merge = '2';

SELECT uniq(number) AS u
FROM remote('127.0.0.{2,3}', currentDatabase(), data_00184)
GROUP BY number
ORDER BY u DESC
SETTINGS distributed_group_by_no_merge = '2';

SELECT n
FROM remote('127.0.0.{2,3}', currentDatabase(), data_00184)
GROUP BY number AS n
ORDER BY n ASC
SETTINGS distributed_group_by_no_merge = '2';

SELECT n
FROM remote('127.0.0.{2,3}', currentDatabase(), data_00184)
ORDER BY number AS n ASC
LIMIT 1
SETTINGS distributed_group_by_no_merge = '2';

SELECT assumeNotNull(argMax(dummy, 1))
FROM remote('127.1', `system`.one)
SETTINGS distributed_group_by_no_merge = '2';

DROP TABLE data_00184;