CREATE TABLE IF NOT EXISTS dict_source
(
    key UInt64,
    value String
)
ENGINE = MergeTree()
ORDER BY key;

CREATE DICTIONARY dict
(
    key UInt64,
    value String
)
PRIMARY KEY key
SOURCE(clickhouse(TABLE 'dict_source'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(DIRECT()); -- { serverError BAD_ARGUMENTS }