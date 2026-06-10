DROP TABLE IF EXISTS `02185_range_dictionary_source_table`;

CREATE TABLE `02185_range_dictionary_source_table`
(
    id UInt64,
    start Nullable(UInt64),
    `end` Nullable(UInt64),
    value String
)
ENGINE = TinyLog();

INSERT INTO `02185_range_dictionary_source_table`;

SELECT *
FROM `02185_range_dictionary_source_table`;

DROP DICTIONARY IF EXISTS `02185_range_dictionary`;

CREATE DICTIONARY `02185_range_dictionary`
(
    id UInt64,
    start UInt64,
    `end` UInt64,
    value String DEFAULT 'DefaultValue'
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE '02185_range_dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
RANGE(MIN start MAX `end`)
LAYOUT(RANGE_HASHED(CONVERT_NULL_RANGE_BOUND_TO_OPEN 1));

SELECT *
FROM `02185_range_dictionary`;

SELECT dictGet('02185_range_dictionary', 'value', 0, 0);

SELECT dictGet('02185_range_dictionary', 'value', 0, 5001);

SELECT dictGet('02185_range_dictionary', 'value', 0, 10001);

SELECT dictHas('02185_range_dictionary', 0, 0);

SELECT dictHas('02185_range_dictionary', 0, 5001);

SELECT dictHas('02185_range_dictionary', 0, 10001);

DROP DICTIONARY `02185_range_dictionary`;

CREATE DICTIONARY `02185_range_dictionary`
(
    id UInt64,
    start UInt64,
    `end` UInt64,
    value String DEFAULT 'DefaultValue'
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE '02185_range_dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
RANGE(MIN start MAX `end`)
LAYOUT(RANGE_HASHED(CONVERT_NULL_RANGE_BOUND_TO_OPEN 0));

DROP TABLE `02185_range_dictionary_source_table`;