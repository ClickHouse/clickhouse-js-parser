DROP TABLE IF EXISTS dictionary_non_nullable_source_table;

CREATE TABLE dictionary_non_nullable_source_table
(
    id UInt64,
    value String
)
ENGINE = TinyLog();

INSERT INTO dictionary_non_nullable_source_table;

DROP DICTIONARY IF EXISTS test_dictionary_non_nullable;

CREATE DICTIONARY test_dictionary_non_nullable
(
    id UInt64,
    value String
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'dictionary_non_nullable_source_table'))
LAYOUT(DIRECT());

SELECT dictGet('test_dictionary_non_nullable', 'value', NULL);

SELECT dictGet('test_dictionary_non_nullable', 'value', arrayJoin([toUInt64(0), NULL, 1]));

DROP DICTIONARY test_dictionary_non_nullable;

DROP TABLE dictionary_non_nullable_source_table;

DROP TABLE IF EXISTS dictionary_nullable_source_table;

CREATE TABLE dictionary_nullable_source_table
(
    id UInt64,
    value Nullable(String)
)
ENGINE = TinyLog();

INSERT INTO dictionary_nullable_source_table;

DROP DICTIONARY IF EXISTS test_dictionary_nullable;

CREATE DICTIONARY test_dictionary_nullable
(
    id UInt64,
    value Nullable(String)
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'dictionary_nullable_source_table'))
LAYOUT(DIRECT());

SELECT dictGet('test_dictionary_nullable', 'value', NULL);

SELECT dictGet('test_dictionary_nullable', 'value', arrayJoin([toUInt64(0), NULL, 1, 2]));

DROP DICTIONARY test_dictionary_nullable;

DROP TABLE dictionary_nullable_source_table;