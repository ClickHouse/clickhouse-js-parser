DROP TABLE IF EXISTS test_table;

CREATE TABLE test_table
(
    uid Int64,
    start Int64,
    `end` Int64,
    insert_time DateTime
)
ENGINE = MergeTree()
ORDER BY (uid, start);

DROP DICTIONARY IF EXISTS test_dictionary;

CREATE DICTIONARY test_dictionary
(
    start Int64,
    `end` Int64,
    insert_time DateTime,
    uid Int64
)
PRIMARY KEY uid
SOURCE(clickhouse(TABLE 'test_table' UPDATE_FIELD 'insert_time' UPDATE_LAG 10))
LIFETIME(MIN 1 MAX 2)
RANGE(MIN start MAX `end`)
LAYOUT(RANGE_HASHED());

INSERT INTO test_table;

SELECT *
FROM test_dictionary;

SELECT dictGet('test_dictionary', 'insert_time', toUInt64(1), 10);

SELECT sleep(3)
FORMAT Null;

SELECT '--';

DROP DICTIONARY test_dictionary;

DROP TABLE test_table;