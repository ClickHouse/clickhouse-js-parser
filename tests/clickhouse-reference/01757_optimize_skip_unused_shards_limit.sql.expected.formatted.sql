-- Tags: shard
DROP TABLE IF EXISTS dist_01757;

CREATE TABLE dist_01757 AS `system`.one
ENGINE = Distributed(test_cluster_two_shards, `system`, one, dummy);

SET optimize_skip_unused_shards = '1';

SET force_optimize_skip_unused_shards = '2';

-- in
SELECT *
FROM dist_01757
WHERE dummy IN (0,)
FORMAT Null;

SELECT *
FROM dist_01757
WHERE dummy IN (0, 1)
FORMAT Null
SETTINGS optimize_skip_unused_shards_limit = '2';

-- in negative
SELECT *
FROM dist_01757
WHERE dummy IN (0, 1)
SETTINGS optimize_skip_unused_shards_limit = '1'; -- { serverError UNABLE_TO_SKIP_UNUSED_SHARDS }

-- or negative
SELECT *
FROM dist_01757
WHERE dummy = 0
    OR dummy = 1
SETTINGS optimize_skip_unused_shards_limit = '1'; -- { serverError UNABLE_TO_SKIP_UNUSED_SHARDS }

-- or
SELECT *
FROM dist_01757
WHERE dummy = 0
    OR dummy = 1
FORMAT Null
SETTINGS optimize_skip_unused_shards_limit = '2';

-- and negative
-- disabled for analyzer cause new implementation consider `dummy = 0 and dummy = 1` as constant False.
SELECT *
FROM dist_01757
WHERE dummy = 0
    AND dummy = 1
SETTINGS
    optimize_skip_unused_shards_limit = '1',
    enable_analyzer = '0'; -- { serverError UNABLE_TO_SKIP_UNUSED_SHARDS }

SELECT *
FROM dist_01757
WHERE dummy = 0
    AND dummy = 2
    AND dummy = 3
SETTINGS
    optimize_skip_unused_shards_limit = '1',
    enable_analyzer = '0'; -- { serverError UNABLE_TO_SKIP_UNUSED_SHARDS }

SELECT *
FROM dist_01757
WHERE dummy = 0
    AND dummy = 2
    AND dummy = 3
SETTINGS
    optimize_skip_unused_shards_limit = '2',
    enable_analyzer = '0'; -- { serverError UNABLE_TO_SKIP_UNUSED_SHARDS }

-- and
SELECT *
FROM dist_01757
WHERE dummy = 0
    AND dummy = 1
SETTINGS optimize_skip_unused_shards_limit = '2';

SELECT *
FROM dist_01757
WHERE dummy = 0
    AND dummy = 1
    AND dummy = 3
SETTINGS optimize_skip_unused_shards_limit = '3';

-- ARGUMENT_OUT_OF_BOUND error
SELECT *
FROM dist_01757
WHERE dummy IN (0, 1)
SETTINGS optimize_skip_unused_shards_limit = '0'; -- { serverError ARGUMENT_OUT_OF_BOUND }

SELECT *
FROM dist_01757
WHERE dummy IN (0, 1)
SETTINGS optimize_skip_unused_shards_limit = '9223372036854775808'; -- { serverError ARGUMENT_OUT_OF_BOUND }

DROP TABLE dist_01757;

-- fuzzed
SELECT *
FROM remote('127.0.0.{1,2}', numbers(40), number)
ORDER BY 'a' ASC
LIMIT 1 BY number
SETTINGS
    optimize_skip_unused_shards = '1',
    force_optimize_skip_unused_shards = '0'
FORMAT Null;