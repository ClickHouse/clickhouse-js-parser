DROP DATABASE IF EXISTS CLICKHOUSE_DATABASE_1;

CREATE DATABASE CLICKHOUSE_DATABASE_1
SETTINGS distributed_ddl_task_timeout = '42';

SYSTEM FLUSH LOGS query_log;

SELECT `Settings`['distributed_ddl_task_timeout']
FROM `system`.query_log
WHERE current_database = currentDatabase()
    AND type != 'QueryStart'
    AND query LIKE 'CREATE DATABASE % SETTINGS %';