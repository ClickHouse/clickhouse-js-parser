DROP DICTIONARY IF EXISTS range_dictionary;

DROP TABLE IF EXISTS range_dictionary_nullable_source_table;

CREATE TABLE range_dictionary_nullable_source_table
(
    key UInt64,
    start_date Date,
    end_date Date,
    value Nullable(UInt64)
)
ENGINE = TinyLog();

INSERT INTO range_dictionary_nullable_source_table;

CREATE DICTIONARY range_dictionary
(
    key UInt64,
    start_date Date,
    end_date Date,
    value Nullable(UInt64) DEFAULT NULL
)
PRIMARY KEY key
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() TABLE 'range_dictionary_nullable_source_table'))
LIFETIME(MIN 1 MAX 1000)
RANGE(MIN start_date MAX end_date)
LAYOUT(RANGE_HASHED());

SELECT dictGetOrDefault('range_dictionary', 'value', toUInt64(2), toDate(toLowCardinality(materialize('2019-05-15'))), 2);