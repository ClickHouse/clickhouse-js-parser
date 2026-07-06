DROP TABLE IF EXISTS dictionary_source_table;

CREATE TABLE dictionary_source_table
(
    id UInt64,
    value String
)
ENGINE = TinyLog();

INSERT INTO dictionary_source_table;

DROP DICTIONARY IF EXISTS test_dictionary;

CREATE DICTIONARY test_dictionary
(
    id UInt64,
    value String
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(FLAT());

SELECT dictGet('test_dictionary', 'value', 0);

SELECT dictGet('test_dictionary', 'value', 0, 'DefaultValue'); --{serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH}

SELECT dictGetOrDefault('test_dictionary', 'value', 1, 'DefaultValue');

SELECT dictGetOrDefault('test_dictionary', 'value', 1, 'DefaultValue', 1); --{serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH}

DROP DICTIONARY test_dictionary;

DROP TABLE dictionary_source_table;

CREATE TABLE dictionary_source_table
(
    key UInt64,
    start UInt64,
    `end` UInt64,
    value String
)
ENGINE = TinyLog();

INSERT INTO dictionary_source_table;

DROP DICTIONARY IF EXISTS range_hashed_dictionary;

CREATE DICTIONARY range_hashed_dictionary
(
    key UInt64,
    start UInt64,
    `end` UInt64,
    value String
)
PRIMARY KEY key
SOURCE(clickhouse(TABLE 'dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
RANGE(MIN start MAX `end`)
LAYOUT(RANGE_HASHED());

SELECT dictGet('range_hashed_dictionary', 'value', 0, toUInt64(4));

SELECT dictGet('range_hashed_dictionary', 'value', 4, toUInt64(6), 'DefaultValue'); --{serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH}

SELECT dictGetOrDefault('range_hashed_dictionary', 'value', 1, toUInt64(6), 'DefaultValue');

SELECT dictGetOrDefault('range_hashed_dictionary', 'value', 1, toUInt64(6), 'DefaultValue', 1); --{serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH}

DROP DICTIONARY range_hashed_dictionary;