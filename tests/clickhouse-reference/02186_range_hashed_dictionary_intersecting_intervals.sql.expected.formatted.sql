DROP TABLE IF EXISTS `02186_range_dictionary_source_table`;

CREATE TABLE `02186_range_dictionary_source_table`
(
    id UInt64,
    start Date,
    `end` Date,
    value String
)
ENGINE = TinyLog();

INSERT INTO `02186_range_dictionary_source_table`;

INSERT INTO `02186_range_dictionary_source_table`;

INSERT INTO `02186_range_dictionary_source_table`;

SELECT *
FROM `02186_range_dictionary_source_table`
ORDER BY `ALL` ASC;

DROP DICTIONARY IF EXISTS `02186_range_dictionary`;

CREATE DICTIONARY `02186_range_dictionary`
(
    id UInt64,
    start Date,
    `end` Date,
    value String
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE '02186_range_dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
RANGE(MIN start MAX `end`)
LAYOUT(RANGE_HASHED(RANGE_LOOKUP_STRATEGY 'min'));

SELECT *
FROM `02186_range_dictionary`;

SELECT dictGet('02186_range_dictionary', 'value', toUInt64(1), toDate('2020-01-01'));

SELECT dictGet('02186_range_dictionary', 'value', toUInt64(1), toDate('2020-01-02'));

SELECT dictGet('02186_range_dictionary', 'value', toUInt64(1), toDate('2020-01-03'));

DROP DICTIONARY `02186_range_dictionary`;

CREATE DICTIONARY `02186_range_dictionary`
(
    id UInt64,
    start Date,
    `end` Date,
    value String
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE '02186_range_dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
RANGE(MIN start MAX `end`)
LAYOUT(RANGE_HASHED(RANGE_LOOKUP_STRATEGY 'max'));

SELECT *
FROM `02186_range_dictionary`
ORDER BY `ALL` ASC;

DROP TABLE `02186_range_dictionary_source_table`;