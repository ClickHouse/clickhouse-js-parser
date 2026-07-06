-- Tags: no-parallel, memory-engine
DROP DATABASE IF EXISTS test_01191;

CREATE DATABASE test_01191
ENGINE = Atomic();

CREATE TABLE test_01191._
(
    n UInt64,
    s String
)
ENGINE = Memory();

CREATE TABLE test_01191.t
(
    n UInt64,
    s String
)
ENGINE = Memory();

CREATE DICTIONARY test_01191.dict
(
    n UInt64,
    s String
)
PRIMARY KEY n
SOURCE(clickhouse(HOST 'localhost' PORT tcpPort() USER 'default' TABLE '_' DB 'test_01191'))
LAYOUT(DIRECT());

INSERT INTO test_01191._;

SELECT
    name,
    status
FROM `system`.dictionaries
WHERE database = 'test_01191';

SELECT
    name,
    engine
FROM `system`.tables
WHERE database = 'test_01191'
ORDER BY name ASC;

RENAME DICTIONARY test_01191.table TO test_01191.table1; -- {serverError UNKNOWN_TABLE}

EXCHANGE DICTIONARY test_01191._ AND test_01191.dict; -- {serverError INFINITE_LOOP}

EXCHANGE TABLE test_01191.t AND test_01191.dict;

SELECT dictGet(test_01191.t, 's', toUInt64(42));

EXCHANGE TABLE test_01191.dict AND test_01191.t;

RENAME DICTIONARY test_01191.t TO test_01191.dict1; -- {serverError INCORRECT_QUERY}

DROP DICTIONARY test_01191.t; -- {serverError INCORRECT_QUERY}

DROP TABLE test_01191.t;

DROP DATABASE IF EXISTS dummy_db;

CREATE DATABASE dummy_db
ENGINE = Atomic();

RENAME DICTIONARY test_01191.dict TO dummy_db.dict1;

RENAME DICTIONARY dummy_db.dict1 TO test_01191.dict;

DROP DATABASE dummy_db;

RENAME DICTIONARY test_01191.dict TO test_01191.dict1;

SELECT dictGet(test_01191.dict1, 's', toUInt64(42));

RENAME DICTIONARY test_01191.dict1 TO test_01191.dict2;

SELECT dictGet(test_01191.dict2, 's', toUInt64(42));

DROP DATABASE test_01191;