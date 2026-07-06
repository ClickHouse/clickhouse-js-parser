SET send_logs_level = 'fatal';

DROP DATABASE IF EXISTS CLICKHOUSE_DATABASE;

SET allow_deprecated_database_ordinary = '1';

-- Creation of a database with Ordinary engine emits a warning.
CREATE DATABASE CLICKHOUSE_DATABASE
ENGINE = Ordinary(); -- Different inner table name with Atomic

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE CLICKHOUSE_DATABASE.my_table
ENGINE = MergeTree(day, day, 8192) AS
SELECT
    today() AS day,
    'mystring' AS str;

SHOW TABLES FROM CLICKHOUSE_DATABASE;

CREATE MATERIALIZED VIEW CLICKHOUSE_DATABASE.my_materialized_view
ENGINE = MergeTree(day, day, 8192)
AS
SELECT *
FROM CLICKHOUSE_DATABASE.my_table;

SELECT *
FROM CLICKHOUSE_DATABASE.my_materialized_view;

DROP DATABASE CLICKHOUSE_DATABASE;