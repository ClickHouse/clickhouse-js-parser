CREATE TABLE test_table
(
    i Int64
)
ENGINE = MergeTree()
ORDER BY i;

CREATE DICTIONARY test_dict
(
    y String,
    value UInt64 DEFAULT 0
)
PRIMARY KEY y
SOURCE(clickhouse(TABLE 'test_table'))
LAYOUT(DIRECT());

CREATE TABLE test_dict
(
    y Int64
)
ENGINE = MergeTree()
ORDER BY y; -- { serverError DICTIONARY_ALREADY_EXISTS }

CREATE DICTIONARY test_table
(
    y String,
    value UInt64 DEFAULT 0
)
PRIMARY KEY y
SOURCE(clickhouse(TABLE 'test_table'))
LAYOUT(DIRECT()); -- { serverError TABLE_ALREADY_EXISTS }

CREATE TABLE test_table
(
    y Int64
)
ENGINE = MergeTree()
ORDER BY y; -- { serverError TABLE_ALREADY_EXISTS }