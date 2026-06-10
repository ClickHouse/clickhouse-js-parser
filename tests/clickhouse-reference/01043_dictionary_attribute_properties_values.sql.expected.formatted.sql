CREATE TABLE CLICKHOUSE_DATABASE.dicttbl
(
    key Int64,
    value_default String,
    value_expression String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO CLICKHOUSE_DATABASE.dicttbl;

CREATE DICTIONARY CLICKHOUSE_DATABASE.dict
(
    key Int64 DEFAULT -1,
    value_default String DEFAULT 'world',
    value_expression String DEFAULT 'xxx' EXPRESSION 'toString(127 * 172)'
)
PRIMARY KEY key
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE 'dicttbl' DB currentDatabase()))
LIFETIME(MIN 0 MAX 1)
LAYOUT(FLAT());

SELECT dictGetString('placeholder' || '.dict', 'value_default', toUInt64(12));

SELECT dictGetString('placeholder' || '.dict', 'value_default', toUInt64(14));

SELECT dictGetString('placeholder' || '.dict', 'value_expression', toUInt64(12));

SELECT dictGetString('placeholder' || '.dict', 'value_expression', toUInt64(14));