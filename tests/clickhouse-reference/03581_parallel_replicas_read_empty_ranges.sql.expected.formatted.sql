SET allow_experimental_parallel_reading_from_replicas = '1', parallel_replicas_for_non_replicated_merge_tree = '1', cluster_for_parallel_replicas = 'test_cluster_one_shard_three_replicas_localhost';

DROP TABLE IF EXISTS `03581_data`;

CREATE TABLE `03581_data`
(
    key UInt32,
    val_minmax UInt32,
    val_set UInt32,
    INDEX skip_minmax val_minmax TYPE set(0) GRANULARITY 1,
    INDEX skip_set val_set TYPE set(0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS index_granularity = '10';

INSERT INTO `03581_data` SELECT
    number,
    number,
    number
FROM numbers(1000);

SELECT
    'Primary key:',
    count()
FROM `03581_data`
WHERE key = 2000;

SELECT
    'Skip index MinMax:',
    count()
FROM `03581_data`
WHERE val_minmax = 2000;

SELECT
    'Skip index Set:',
    count()
FROM `03581_data`
WHERE val_set = 2000;

SYSTEM FLUSH LOGS query_log;

SELECT read_rows
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND type = 'QueryFinish'
    AND query ILIKE '% from 03581_data where %'
ORDER BY event_time_microseconds DESC;

DROP TABLE `03581_data`;