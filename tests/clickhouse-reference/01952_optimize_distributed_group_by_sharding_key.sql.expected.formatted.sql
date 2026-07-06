-- Tags: distributed
SET optimize_skip_unused_shards = '1';

SET optimize_distributed_group_by_sharding_key = '1';

SET prefer_localhost_replica = '1';

SET enable_analyzer = '0';

-- { echo }
EXPLAIN
SELECT DISTINCT k1
FROM remote('127.{1,2}', view(    SELECT
        1 AS k1,
        2 AS k2,
        3 AS v
    FROM numbers(2)), cityHash64(k1, k2)); -- not optimized

EXPLAIN
SELECT DISTINCT
    k1,
    k2
FROM remote('127.{1,2}', view(    SELECT
        1 AS k1,
        2 AS k2,
        3 AS v
    FROM numbers(2)), cityHash64(k1, k2)); -- optimized

EXPLAIN
SELECT k2
FROM remote('127.{1,2}', view(    SELECT
        1 AS k1,
        2 AS k2,
        3 AS v
    FROM numbers(2)), cityHash64(k1, k2))
LIMIT 1 BY k1; -- not optimized

EXPLAIN
SELECT v
FROM remote('127.{1,2}', view(    SELECT
        1 AS k1,
        2 AS k2,
        3 AS v
    FROM numbers(2)), cityHash64(k1, k2))
LIMIT 1 BY k1, k2; -- optimized

EXPLAIN
SELECT DISTINCT k1
FROM remote('127.{1,2}', view(    SELECT
        1 AS k1,
        2 AS k2,
        3 AS v
    FROM numbers(2)), cityHash64(k1, k2))
ORDER BY v ASC; -- not optimized

EXPLAIN
SELECT DISTINCT
    k1,
    k2
FROM remote('127.{1,2}', view(    SELECT
        1 AS k1,
        2 AS k2,
        3 AS v
    FROM numbers(2)), cityHash64(k1, k2))
ORDER BY v ASC; -- optimized

EXPLAIN
SELECT k2
FROM remote('127.{1,2}', view(    SELECT
        1 AS k1,
        2 AS k2,
        3 AS v
    FROM numbers(2)), cityHash64(k1, k2))
ORDER BY v ASC
LIMIT 1 BY k1; -- not optimized

EXPLAIN
SELECT v
FROM remote('127.{1,2}', view(    SELECT
        1 AS k1,
        2 AS k2,
        3 AS v
    FROM numbers(2)), cityHash64(k1, k2))
ORDER BY v ASC
LIMIT 1 BY k1, k2; -- optimized

SET enable_analyzer = '1';