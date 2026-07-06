DROP TABLE IF EXISTS `02181_test_table`;

CREATE TABLE `02181_test_table`
(
    id UInt64,
    value String
)
ENGINE = TinyLog();

INSERT INTO `02181_test_table`;

DROP DICTIONARY IF EXISTS `02181_test_dictionary`;

CREATE DICTIONARY `02181_test_dictionary`
(
    id UInt64,
    value String
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE '02181_test_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

DETACH TABLE `02181_test_dictionary`; --{serverError CANNOT_DETACH_DICTIONARY_AS_TABLE}

ATTACH TABLE `02181_test_dictionary`; --{serverError INCORRECT_QUERY}

DETACH DICTIONARY `02181_test_dictionary`;

ATTACH DICTIONARY `02181_test_dictionary`;

SELECT *
FROM `02181_test_dictionary`;

DROP DICTIONARY `02181_test_dictionary`;

DROP TABLE `02181_test_table`;