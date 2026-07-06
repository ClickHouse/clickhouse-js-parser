CREATE TABLE dict_data
(
    key UInt64,
    val UInt64
)
ENGINE = Memory();

CREATE DICTIONARY dict
(
    key UInt64 DEFAULT 0,
    val UInt64 DEFAULT 10
)
PRIMARY KEY key
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'dict_data' PASSWORD '' DB currentDatabase()))
LIFETIME(MIN 0 MAX 0)
LAYOUT(FLAT());

DETACH DATABASE CLICKHOUSE_DATABASE;

ATTACH DATABASE CLICKHOUSE_DATABASE;

SELECT
    query_count,
    status
FROM `system`.dictionaries
WHERE database = currentDatabase()
    AND name = 'dict';

SYSTEM RELOAD DICTIONARY dict;

SELECT dictGetUInt64('dict', 'val', toUInt64(0));