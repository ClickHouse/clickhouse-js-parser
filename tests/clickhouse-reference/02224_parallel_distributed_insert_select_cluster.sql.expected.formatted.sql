DROP TABLE IF EXISTS dst_02224;

DROP TABLE IF EXISTS src_02224;

CREATE TABLE dst_02224
(
    key Int
)
ENGINE = Memory();

CREATE TABLE src_02224
(
    key Int
)
ENGINE = Memory();

INSERT INTO src_02224;

-- { echoOn }
TRUNCATE TABLE dst_02224;

INSERT INTO FUNCTION cluster('test_cluster_two_shards', currentDatabase(), dst_02224, key) SELECT *
FROM cluster('test_cluster_two_shards', currentDatabase(), src_02224, key)
SETTINGS
    parallel_distributed_insert_select = '1',
    max_distributed_depth = '1'; -- { serverError TOO_LARGE_DISTRIBUTED_DEPTH }

SELECT *
FROM dst_02224;

INSERT INTO FUNCTION cluster('test_cluster_two_shards', currentDatabase(), dst_02224, key) SELECT *
FROM cluster('test_cluster_two_shards', currentDatabase(), src_02224, key)
SETTINGS
    parallel_distributed_insert_select = '1',
    max_distributed_depth = '2';

INSERT INTO FUNCTION cluster('test_cluster_two_shards', currentDatabase(), dst_02224, key) SELECT *
FROM cluster('test_cluster_two_shards', currentDatabase(), src_02224, key)
SETTINGS
    parallel_distributed_insert_select = '2',
    max_distributed_depth = '1';

INSERT INTO FUNCTION remote('127.{1,2}', currentDatabase(), dst_02224, key) SELECT *
FROM remote('127.{1,2}', currentDatabase(), src_02224, key)
SETTINGS
    parallel_distributed_insert_select = '2',
    max_distributed_depth = '1';

-- { echoOff }
DROP TABLE src_02224;

DROP TABLE dst_02224;