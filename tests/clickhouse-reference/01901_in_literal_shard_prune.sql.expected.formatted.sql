-- Tags: shard
SET optimize_skip_unused_shards = '1';

SET force_optimize_skip_unused_shards = '1';

DROP TABLE IF EXISTS d;

DROP TABLE IF EXISTS dp;

CREATE TABLE d
(
    i UInt8
)
ENGINE = Memory();

CREATE TABLE dp AS d
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), d, i);

INSERT INTO d;

SELECT *
FROM dp
WHERE i IN (1);