DROP TABLE IF EXISTS `02183_dictionary_test_table`;

CREATE TABLE `02183_dictionary_test_table`
(
    id UInt64
)
ENGINE = TinyLog();

INSERT INTO `02183_dictionary_test_table`;

SELECT *
FROM `02183_dictionary_test_table`;

DROP DICTIONARY IF EXISTS `02183_flat_dictionary`;

CREATE DICTIONARY `02183_flat_dictionary`
(
    id UInt64
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE '02183_dictionary_test_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(FLAT());

SELECT dictGet('02183_flat_dictionary', 'value', 0); -- {serverError BAD_ARGUMENTS}

SELECT dictHas('02183_flat_dictionary', 0);

SELECT dictHas('02183_flat_dictionary', 1);

SELECT dictHas('02183_flat_dictionary', 2);

SELECT *
FROM `02183_flat_dictionary`;

DROP DICTIONARY `02183_flat_dictionary`;

DROP DICTIONARY IF EXISTS `02183_hashed_dictionary`;

CREATE DICTIONARY `02183_hashed_dictionary`
(
    id UInt64
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE '02183_dictionary_test_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

SELECT dictHas('02183_hashed_dictionary', 0);

SELECT dictHas('02183_hashed_dictionary', 1);

SELECT dictHas('02183_hashed_dictionary', 2);

SELECT *
FROM `02183_hashed_dictionary`;

DROP DICTIONARY `02183_hashed_dictionary`;

DROP DICTIONARY IF EXISTS `02183_hashed_array_dictionary`;

CREATE DICTIONARY `02183_hashed_array_dictionary`
(
    id UInt64
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE '02183_dictionary_test_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED_ARRAY());

SELECT dictHas('02183_hashed_array_dictionary', 0);

SELECT dictHas('02183_hashed_array_dictionary', 1);

SELECT dictHas('02183_hashed_array_dictionary', 2);

SELECT *
FROM `02183_hashed_array_dictionary`;

DROP DICTIONARY `02183_hashed_array_dictionary`;

DROP DICTIONARY IF EXISTS `02183_cache_dictionary`;

CREATE DICTIONARY `02183_cache_dictionary`
(
    id UInt64
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE '02183_dictionary_test_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(CACHE(SIZE_IN_CELLS 10));

SELECT dictHas('02183_cache_dictionary', 0);

SELECT dictHas('02183_cache_dictionary', 1);

SELECT dictHas('02183_cache_dictionary', 2);

SELECT *
FROM `02183_cache_dictionary`;

DROP DICTIONARY `02183_cache_dictionary`;

DROP DICTIONARY IF EXISTS `02183_direct_dictionary`;

CREATE DICTIONARY `02183_direct_dictionary`
(
    id UInt64
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE '02183_dictionary_test_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

SELECT dictHas('02183_direct_dictionary', 0);

SELECT dictHas('02183_direct_dictionary', 1);

SELECT dictHas('02183_direct_dictionary', 2);

SELECT *
FROM `02183_direct_dictionary`;

DROP DICTIONARY `02183_direct_dictionary`;

DROP TABLE `02183_dictionary_test_table`;

DROP TABLE IF EXISTS ip_trie_dictionary_source_table;

CREATE TABLE ip_trie_dictionary_source_table
(
    prefix String
)
ENGINE = TinyLog();

INSERT INTO ip_trie_dictionary_source_table;

DROP DICTIONARY IF EXISTS `02183_ip_trie_dictionary`;

CREATE DICTIONARY `02183_ip_trie_dictionary`
(
    prefix String
)
PRIMARY KEY prefix
SOURCE(clickhouse(TABLE 'ip_trie_dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(IP_TRIE());

SELECT dictHas('02183_ip_trie_dictionary', tuple(IPv4StringToNum('127.0.0.0')));

SELECT dictHas('02183_ip_trie_dictionary', tuple(IPv4StringToNum('127.0.0.1')));

SELECT *
FROM `02183_ip_trie_dictionary`;

DROP DICTIONARY `02183_ip_trie_dictionary`;

DROP TABLE ip_trie_dictionary_source_table;

DROP TABLE IF EXISTS `02183_polygon_dictionary_source_table`;

CREATE TABLE `02183_polygon_dictionary_source_table`
(
    key Array(Array(Array(Tuple(Float64, Float64))))
)
ENGINE = TinyLog();

INSERT INTO `02183_polygon_dictionary_source_table`;

DROP DICTIONARY IF EXISTS `02183_polygon_dictionary`;

CREATE DICTIONARY `02183_polygon_dictionary`
(
    key Array(Array(Array(Tuple(Float64, Float64))))
)
PRIMARY KEY key
SOURCE(clickhouse(TABLE '02183_polygon_dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(POLYGON(STORE_POLYGON_KEY_COLUMN 1));

SELECT dictHas('02183_polygon_dictionary', tuple(0.5, 0.5));

SELECT dictHas('02183_polygon_dictionary', tuple(1.5, 1.5));

SELECT *
FROM `02183_polygon_dictionary`;

DROP DICTIONARY `02183_polygon_dictionary`;

DROP TABLE `02183_polygon_dictionary_source_table`;

DROP TABLE IF EXISTS `02183_range_dictionary_source_table`;

CREATE TABLE `02183_range_dictionary_source_table`
(
    key UInt64,
    start UInt64,
    `end` UInt64
)
ENGINE = TinyLog();

INSERT INTO `02183_range_dictionary_source_table`;

DROP DICTIONARY IF EXISTS `02183_range_dictionary`;

CREATE DICTIONARY `02183_range_dictionary`
(
    key UInt64,
    start UInt64,
    `end` UInt64
)
PRIMARY KEY key
SOURCE(clickhouse(TABLE '02183_range_dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
RANGE(MIN start MAX `end`)
LAYOUT(RANGE_HASHED());

SELECT *
FROM `02183_range_dictionary`;

SELECT dictHas('02183_range_dictionary', 0, 0);

SELECT dictHas('02183_range_dictionary', 0, 2);

DROP DICTIONARY `02183_range_dictionary`;

DROP TABLE `02183_range_dictionary_source_table`;