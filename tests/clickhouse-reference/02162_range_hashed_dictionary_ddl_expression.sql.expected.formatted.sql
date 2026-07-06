DROP TABLE IF EXISTS `02162_test_table`;

CREATE TABLE `02162_test_table`
(
    id UInt64,
    value String,
    range_value UInt64
)
ENGINE = TinyLog();

INSERT INTO `02162_test_table`;

DROP DICTIONARY IF EXISTS `02162_test_dictionary`;

CREATE DICTIONARY `02162_test_dictionary`
(
    id UInt64,
    value String,
    range_value UInt64,
    start UInt64 EXPRESSION range_value,
    `end` UInt64 EXPRESSION range_value
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE '02162_test_table'))
LIFETIME(MIN 0 MAX 0)
RANGE(MIN start MAX `end`)
LAYOUT(RANGE_HASHED());

SELECT *
FROM `02162_test_dictionary`;

DROP DICTIONARY `02162_test_dictionary`;

DROP TABLE `02162_test_table`;