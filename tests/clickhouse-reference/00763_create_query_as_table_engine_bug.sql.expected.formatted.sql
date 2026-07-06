DROP TABLE IF EXISTS t;

DROP TABLE IF EXISTS td;

CREATE TABLE t
(
    val UInt32
)
ENGINE = MergeTree()
ORDER BY val;

CREATE TABLE td AS t
ENGINE = Distributed(test_shard_localhost, currentDatabase(), 't');

SELECT engine
FROM `system`.tables
WHERE database = currentDatabase()
    AND name = 'td';