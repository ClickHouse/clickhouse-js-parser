-- Tags: no-parallel, no-fasttest
DROP DATABASE IF EXISTS database_for_dict;

CREATE DATABASE database_for_dict;

DROP TABLE IF EXISTS database_for_dict.dict_source;

CREATE TABLE database_for_dict.dict_source
(
    id UInt64,
    parent_id UInt64,
    value String
)
ENGINE = Memory();

INSERT INTO database_for_dict.dict_source;

DROP DICTIONARY IF EXISTS database_for_dict.dictionary_with_hierarchy;

CREATE DICTIONARY database_for_dict.dictionary_with_hierarchy
(
    id UInt64,
    parent_id UInt64 HIERARCHICAL,
    value String
)
PRIMARY KEY id
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' DB 'database_for_dict' TABLE 'dict_source'))
LIFETIME(MIN 1 MAX 1)
LAYOUT(HASHED());

SELECT dictIsIn('database_for_dict.dictionary_with_hierarchy', toUInt64(2), toUInt64(1));

SELECT dictIsIn('database_for_dict.dictionary_with_hierarchy', toUInt64(22), toUInt64(11));

SELECT dictIsIn('database_for_dict.dictionary_with_hierarchy', materialize(toUInt64(22)), toUInt64(11));

SELECT dictIsIn('database_for_dict.dictionary_with_hierarchy', toUInt64(11), materialize(toUInt64(22)));

SELECT dictIsIn('database_for_dict.dictionary_with_hierarchy', materialize(toUInt64(22)), materialize(toUInt64(11)));

SELECT dictIsIn('database_for_dict.dictionary_with_hierarchy', toUInt64(22), toUInt64(111));

SELECT dictIsIn('database_for_dict.dictionary_with_hierarchy', materialize(toUInt64(22)), toUInt64(111));

SELECT dictIsIn('database_for_dict.dictionary_with_hierarchy', toUInt64(11), materialize(toUInt64(222)));

SELECT dictIsIn('database_for_dict.dictionary_with_hierarchy', materialize(toUInt64(22)), materialize(toUInt64(111)));

SELECT dictGetHierarchy('database_for_dict.dictionary_with_hierarchy', toUInt64(11));

SELECT dictGetHierarchy('database_for_dict.dictionary_with_hierarchy', toUInt64(22));

SELECT dictGetHierarchy('database_for_dict.dictionary_with_hierarchy', materialize(toUInt64(11)));

SELECT dictGetHierarchy('database_for_dict.dictionary_with_hierarchy', materialize(toUInt64(22)));

CREATE DICTIONARY database_for_dict.dictionary_with_hierarchy
(
    id UInt64,
    parent_id UInt64 HIERARCHICAL,
    value String
)
PRIMARY KEY id
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' DB 'database_for_dict' TABLE 'dict_source'))
LIFETIME(MIN 1 MAX 1)
LAYOUT(FLAT());

CREATE DICTIONARY database_for_dict.dictionary_with_hierarchy
(
    id UInt64,
    parent_id UInt64 HIERARCHICAL,
    value String
)
PRIMARY KEY id
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' DB 'database_for_dict' TABLE 'dict_source'))
LIFETIME(MIN 1 MAX 1)
LAYOUT(CACHE(SIZE_IN_CELLS 10));

DROP DICTIONARY database_for_dict.dictionary_with_hierarchy;

DROP TABLE database_for_dict.dict_source;

DROP DATABASE database_for_dict;