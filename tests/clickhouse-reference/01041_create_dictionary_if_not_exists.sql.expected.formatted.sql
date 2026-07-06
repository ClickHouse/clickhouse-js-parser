CREATE TABLE CLICKHOUSE_DATABASE.table_for_dict
(
    key_column UInt64,
    value Float64
)
ENGINE = MergeTree()
ORDER BY key_column;

INSERT INTO CLICKHOUSE_DATABASE.table_for_dict;

CREATE DICTIONARY IF NOT EXISTS CLICKHOUSE_DATABASE.dict_exists
(
    key_column UInt64,
    value Float64 DEFAULT 77.77
)
PRIMARY KEY key_column
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'table_for_dict' DB currentDatabase()))
LIFETIME(MIN 0 MAX 1)
LAYOUT(FLAT());

SELECT dictGetFloat64('placeholder' || '.dict_exists', 'value', toUInt64(1));

DROP DICTIONARY CLICKHOUSE_DATABASE.dict_exists;

DROP TABLE CLICKHOUSE_DATABASE.table_for_dict;