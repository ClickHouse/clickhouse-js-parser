-- Tags: no-fasttest, no-replicated-database, no-shared-merge-tree
-- no-shared-merge-tree -- smt doesn't support aux zookeepers
DROP TABLE IF EXISTS test_zk_connection_table;

CREATE TABLE test_zk_connection_table
(
    key UInt64
)
ENGINE = ReplicatedMergeTree('zookeeper2:/clickhouse/{database}/02731_zk_connection/{shard}', '{replica}')
ORDER BY tuple();

SET session_timezone = 'UTC';

-- NOTE: Durind the query execution, now() can be evaluated a bit earlier than connected_time
SELECT
    name,
    host,
    port,
    index,
    is_expired,
    keeper_api_version,
    connected_time >= yesterday()
    AND connected_time <= now() + toIntervalSecond(3),
    abs(session_uptime_elapsed_seconds - zookeeperSessionUptime()) < 10,
    enabled_feature_flags
FROM `system`.zookeeper_connection
WHERE name = 'default';

-- keeper_api_version will by 0 for auxiliary_zookeeper2, because we fail to get /api_version due to chroot
-- I'm not sure if it's a bug or a useful trick to fallback to basic api
-- Also, auxiliary zookeeper is created lazily
SELECT
    name,
    host,
    port,
    index,
    is_expired,
    keeper_api_version,
    connected_time >= yesterday()
    AND connected_time <= now() + toIntervalSecond(3)
FROM `system`.zookeeper_connection
WHERE name != 'default';