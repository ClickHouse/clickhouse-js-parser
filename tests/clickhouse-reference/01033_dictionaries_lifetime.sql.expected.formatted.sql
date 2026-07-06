SET send_logs_level = 'fatal';

CREATE TABLE CLICKHOUSE_DATABASE.table_for_dict
(
    key_column UInt64,
    second_column UInt8,
    third_column String
)
ENGINE = MergeTree()
ORDER BY key_column;

INSERT INTO CLICKHOUSE_DATABASE.table_for_dict;

DROP DATABASE IF EXISTS CLICKHOUSE_DATABASE_1;

CREATE DATABASE CLICKHOUSE_DATABASE_1;

CREATE DICTIONARY CLICKHOUSE_DATABASE_1.dict1
(
    key_column UInt64 DEFAULT 0,
    second_column UInt8 DEFAULT 1,
    third_column String DEFAULT 'qqq'
)
PRIMARY KEY key_column
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'table_for_dict' PASSWORD '' DB currentDatabase()))
LIFETIME(MIN 1 MAX 10)
LAYOUT(FLAT());

SELECT dictGetUInt8('placeholder' || '.dict1', 'second_column', toUInt64(100500));

SELECT
    lifetime_min,
    lifetime_max
FROM `system`.dictionaries
WHERE database = 'placeholder'
    AND name = 'dict1';

DROP DICTIONARY IF EXISTS CLICKHOUSE_DATABASE_1.dict1;

DROP TABLE IF EXISTS CLICKHOUSE_DATABASE.table_for_dict;

DROP DATABASE IF EXISTS CLICKHOUSE_DATABASE;