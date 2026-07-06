DROP TABLE IF EXISTS test_hierarchy_source_table;

CREATE TABLE test_hierarchy_source_table
(
    id UInt64,
    parent_id UInt64
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO test_hierarchy_source_table;

DROP DICTIONARY IF EXISTS hierarchy_flat_dictionary_index;

CREATE DICTIONARY hierarchy_flat_dictionary_index
(
    id UInt64,
    parent_id UInt64 BIDIRECTIONAL
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'test_hierarchy_source_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(FLAT()); -- {serverError BAD_ARGUMENTS }

CREATE DICTIONARY hierarchy_flat_dictionary_index
(
    id UInt64,
    parent_id UInt64 HIERARCHICAL BIDIRECTIONAL
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'test_hierarchy_source_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(FLAT());

SELECT *
FROM hierarchy_flat_dictionary_index;

SELECT hierarchical_index_bytes_allocated > 0
FROM `system`.dictionaries
WHERE name = 'hierarchy_flat_dictionary_index'
    AND database = currentDatabase();

DROP DICTIONARY hierarchy_flat_dictionary_index;

DROP DICTIONARY IF EXISTS hierarchy_hashed_dictionary_index;

CREATE DICTIONARY hierarchy_hashed_dictionary_index
(
    id UInt64,
    parent_id UInt64 HIERARCHICAL BIDIRECTIONAL
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'test_hierarchy_source_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(FLAT());

SELECT *
FROM hierarchy_hashed_dictionary_index;

SELECT hierarchical_index_bytes_allocated > 0
FROM `system`.dictionaries
WHERE name = 'hierarchy_hashed_dictionary_index'
    AND database = currentDatabase();

DROP DICTIONARY hierarchy_hashed_dictionary_index;

DROP DICTIONARY IF EXISTS hierarchy_hashed_array_dictionary_index;

CREATE DICTIONARY hierarchy_hashed_array_dictionary_index
(
    id UInt64,
    parent_id UInt64 HIERARCHICAL
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'test_hierarchy_source_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED_ARRAY());

SELECT *
FROM hierarchy_hashed_array_dictionary_index;

SELECT hierarchical_index_bytes_allocated > 0
FROM `system`.dictionaries
WHERE name = 'hierarchy_hashed_array_dictionary_index'
    AND database = currentDatabase();

DROP DICTIONARY hierarchy_hashed_array_dictionary_index;

DROP TABLE test_hierarchy_source_table;