-- Tags: no-parallel
DROP DATABASE IF EXISTS test_01676 SYNC;

CREATE DATABASE test_01676;

CREATE TABLE test_01676.dict_data
(
    key UInt64,
    value UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_01676.dict_data;

CREATE DICTIONARY test_01676.dict
(
    key UInt64,
    value UInt64
)
PRIMARY KEY key
SOURCE(clickhouse(DB 'test_01676' TABLE 'dict_data' HOST '127.0.0.1' PORT tcpPort()))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

CREATE TABLE test_01676.table
(
    x UInt64,
    y UInt64 DEFAULT dictGet('test_01676.dict', 'value', x)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_01676.table (x);

INSERT INTO test_01676.table;

SELECT *
FROM test_01676.table
ORDER BY x ASC;

SELECT status
FROM `system`.dictionaries
WHERE database = 'test_01676'
    AND name = 'dict';

DETACH DATABASE test_01676;

ATTACH DATABASE test_01676;

-- It can be not loaded, or not even finish attaching in case of asynchronous tables loading.
SELECT COALESCE((
        SELECT status
        FROM `system`.dictionaries
        WHERE database = 'test_01676'
            AND name = 'dict'
    )::Nullable(String), 'NOT_LOADED');

INSERT INTO test_01676.table (x);

DROP DATABASE test_01676;