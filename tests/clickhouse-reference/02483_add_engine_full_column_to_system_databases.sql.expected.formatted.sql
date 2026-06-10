DROP DATABASE IF EXISTS CLICKHOUSE_DATABASE;

CREATE DATABASE IF NOT EXISTS CLICKHOUSE_DATABASE
ENGINE = Replicated('some/path/' || currentDatabase() || '/replicated_database_test', 'shard_1', 'replica_1')
SETTINGS max_broken_tables_ratio = '1';

SELECT engine_full
FROM `system`.databases
WHERE name = current_database();