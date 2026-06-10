-- Tags: no-parallel
DROP DATABASE IF EXISTS test_dict_db;

CREATE DATABASE test_dict_db;

SET check_table_dependencies = '0';

CREATE TABLE test_dict_db.table1
(
    col1 String,
    col2 Int16,
    col3 String,
    col4 Int32,
    col5 String,
    col6 Nullable(Float64),
    col7 Nullable(Float64),
    col8 Nullable(DateTime('UTC')),
    col9 Nullable(String),
    col10 Nullable(String),
    col11 Nullable(String),
    col12 Nullable(String),
    col13 Nullable(Int32),
    col14 Nullable(DateTime('UTC')),
    col15 Nullable(DateTime('UTC')),
    col16 Nullable(DateTime('UTC')),
    col17 Nullable(DateTime('UTC')),
    col18 Nullable(DateTime('UTC')),
    col19 Nullable(DateTime('UTC')),
    col20 Nullable(String)
)
ENGINE = MergeTree()
ORDER BY (col1, col2, col3, col4, col5);

INSERT INTO test_dict_db.table1;

CREATE DICTIONARY test_dict_db.table1_dict
(
    col1 String,
    col2 Int16,
    col3 String,
    col4 Int32,
    col5 String,
    col6 Float64,
    col7 Float64,
    col8 DateTime('UTC'),
    col9 String,
    col10 String,
    col11 String,
    col12 String,
    col13 Int32,
    col14 DateTime('UTC'),
    col15 DateTime('UTC'),
    col16 DateTime('UTC'),
    col17 DateTime('UTC'),
    col18 DateTime('UTC'),
    col19 DateTime('UTC'),
    col20 String
)
PRIMARY KEY col1, col2, col3, col4, col5
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() DB test_dict_db TABLE table1 USER 'default'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(COMPLEX_KEY_HASHED());

SELECT
    dictGet('test_dict_db.table1_dict', 'col6', (col1, col2, col3, col4, col5)),
    dictGet('test_dict_db.table1_dict', 'col7', (col1, col2, col3, col4, col5)),
    dictGet('test_dict_db.table1_dict', 'col8', (col1, col2, col3, col4, col5)),
    dictGet('test_dict_db.table1_dict', 'col9', (col1, col2, col3, col4, col5))
FROM test_dict_db.table1
WHERE dictHas('test_dict_db.table1_dict', (col1, col2, col3, col4, col5)); -- { serverError CANNOT_INSERT_NULL_IN_ORDINARY_COLUMN }

DROP TABLE test_dict_db.table1;

CREATE TABLE test_dict_db.table1
(
    col1 String,
    col2 Int16,
    col3 String,
    col4 Int32,
    col5 String,
    col6 Float64,
    col7 Float64,
    col8 DateTime('UTC'),
    col9 String,
    col10 String,
    col11 String,
    col12 String,
    col13 Int32,
    col14 DateTime('UTC'),
    col15 DateTime('UTC'),
    col16 DateTime('UTC'),
    col17 DateTime('UTC'),
    col18 DateTime('UTC'),
    col19 DateTime('UTC'),
    col20 String
)
ENGINE = MergeTree()
ORDER BY (col1, col2, col3, col4, col5);

SET input_format_null_as_default = '1';

SYSTEM RELOAD DICTIONARY test_dict_db.table1_dict;

SELECT
    dictGet('test_dict_db.table1_dict', 'col6', (col1, col2, col3, col4, col5)),
    dictGet('test_dict_db.table1_dict', 'col7', (col1, col2, col3, col4, col5)),
    dictGet('test_dict_db.table1_dict', 'col8', (col1, col2, col3, col4, col5)),
    dictGet('test_dict_db.table1_dict', 'col9', (col1, col2, col3, col4, col5))
FROM test_dict_db.table1
WHERE dictHas('test_dict_db.table1_dict', (col1, col2, col3, col4, col5))
ORDER BY
    col1 ASC,
    col2 ASC,
    col3 ASC,
    col4 ASC,
    col5 ASC,
    col14 ASC,
    col17 ASC;