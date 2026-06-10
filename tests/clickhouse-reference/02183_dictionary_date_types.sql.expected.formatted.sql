DROP TABLE IF EXISTS `02183_dictionary_source_table`;

CREATE TABLE `02183_dictionary_source_table`
(
    id UInt64,
    value_date Date,
    value_date_32 Date32,
    value_date_time DateTime,
    value_date_time_64 DateTime64
)
ENGINE = TinyLog();

INSERT INTO `02183_dictionary_source_table`;

SELECT *
FROM `02183_dictionary_source_table`;

DROP DICTIONARY IF EXISTS `02183_flat_dictionary`;

CREATE DICTIONARY `02183_flat_dictionary`
(
    id UInt64,
    value_date Date,
    value_date_32 Date32,
    value_date_time DateTime,
    value_date_time_64 DateTime64
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE '02183_dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(FLAT());

SELECT *
FROM `02183_flat_dictionary`;

DROP DICTIONARY `02183_flat_dictionary`;

DROP DICTIONARY IF EXISTS `02183_hashed_dictionary`;

CREATE DICTIONARY `02183_hashed_dictionary`
(
    id UInt64,
    value_date Date,
    value_date_32 Date32,
    value_date_time DateTime,
    value_date_time_64 DateTime64
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE '02183_dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

SELECT *
FROM `02183_hashed_dictionary`;

DROP DICTIONARY `02183_hashed_dictionary`;

DROP DICTIONARY IF EXISTS `02183_hashed_array_dictionary`;

CREATE DICTIONARY `02183_hashed_array_dictionary`
(
    id UInt64,
    value_date Date,
    value_date_32 Date32,
    value_date_time DateTime,
    value_date_time_64 DateTime64
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE '02183_dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED_ARRAY());

SELECT *
FROM `02183_hashed_array_dictionary`;

DROP DICTIONARY `02183_hashed_array_dictionary`;

DROP DICTIONARY IF EXISTS `02183_cache_dictionary`;

CREATE DICTIONARY `02183_cache_dictionary`
(
    id UInt64,
    value_date Date,
    value_date_32 Date32,
    value_date_time DateTime,
    value_date_time_64 DateTime64
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE '02183_dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(CACHE(SIZE_IN_CELLS 10));

SELECT dictGet('02183_cache_dictionary', 'value_date', 0);

SELECT *
FROM `02183_cache_dictionary`;

DROP DICTIONARY `02183_cache_dictionary`;

DROP DICTIONARY IF EXISTS `02183_direct_dictionary`;

CREATE DICTIONARY `02183_direct_dictionary`
(
    id UInt64,
    value_date Date,
    value_date_32 Date32,
    value_date_time DateTime,
    value_date_time_64 DateTime64
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE '02183_dictionary_source_table'))
LAYOUT(DIRECT());

SELECT *
FROM `02183_direct_dictionary`;

DROP DICTIONARY `02183_direct_dictionary`;

DROP TABLE `02183_dictionary_source_table`;

DROP TABLE IF EXISTS `02183_ip_trie_dictionary_source_table`;

CREATE TABLE `02183_ip_trie_dictionary_source_table`
(
    prefix String,
    value_date Date,
    value_date_32 Date32,
    value_date_time DateTime,
    value_date_time_64 DateTime64
)
ENGINE = TinyLog();

INSERT INTO `02183_ip_trie_dictionary_source_table`;

SELECT *
FROM `02183_ip_trie_dictionary_source_table`;

DROP DICTIONARY IF EXISTS `02183_ip_trie_dictionary`;

CREATE DICTIONARY `02183_ip_trie_dictionary`
(
    prefix String,
    value_date Date,
    value_date_32 Date32,
    value_date_time DateTime,
    value_date_time_64 DateTime64
)
PRIMARY KEY prefix
SOURCE(clickhouse(TABLE '02183_ip_trie_dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(IP_TRIE(ACCESS_TO_KEY_FROM_ATTRIBUTES 1));

SELECT *
FROM `02183_ip_trie_dictionary`;

DROP DICTIONARY `02183_ip_trie_dictionary`;

DROP TABLE `02183_ip_trie_dictionary_source_table`;

DROP TABLE IF EXISTS `02183_polygon_dictionary_source_table`;

CREATE TABLE `02183_polygon_dictionary_source_table`
(
    key Array(Array(Array(Tuple(Float64, Float64)))),
    value_date Date,
    value_date_32 Date32,
    value_date_time DateTime,
    value_date_time_64 DateTime64
)
ENGINE = TinyLog();

INSERT INTO `02183_polygon_dictionary_source_table`;

DROP DICTIONARY IF EXISTS `02183_polygon_dictionary`;

CREATE DICTIONARY `02183_polygon_dictionary`
(
    key Array(Array(Array(Tuple(Float64, Float64)))),
    value_date Date,
    value_date_32 Date32,
    value_date_time DateTime,
    value_date_time_64 DateTime64
)
PRIMARY KEY key
SOURCE(clickhouse(TABLE '02183_polygon_dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(POLYGON(STORE_POLYGON_KEY_COLUMN 1));

SELECT *
FROM `02183_polygon_dictionary`;

DROP DICTIONARY `02183_polygon_dictionary`;

DROP TABLE `02183_polygon_dictionary_source_table`;

DROP TABLE IF EXISTS `02183_range_dictionary_source_table`;

CREATE TABLE `02183_range_dictionary_source_table`
(
    key UInt64,
    start UInt64,
    `end` UInt64,
    value_date Date,
    value_date_32 Date32,
    value_date_time DateTime,
    value_date_time_64 DateTime64
)
ENGINE = TinyLog();

INSERT INTO `02183_range_dictionary_source_table`;

SELECT *
FROM `02183_range_dictionary_source_table`;

CREATE DICTIONARY `02183_range_dictionary`
(
    key UInt64,
    start UInt64,
    `end` UInt64,
    value_date Date,
    value_date_32 Date32,
    value_date_time DateTime,
    value_date_time_64 DateTime64
)
PRIMARY KEY key
SOURCE(clickhouse(TABLE '02183_range_dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
RANGE(MIN start MAX `end`)
LAYOUT(RANGE_HASHED());

SELECT *
FROM `02183_range_dictionary`;

DROP DICTIONARY `02183_range_dictionary`;

DROP TABLE `02183_range_dictionary_source_table`;