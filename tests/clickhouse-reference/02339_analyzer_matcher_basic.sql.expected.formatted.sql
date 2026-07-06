-- Tags: no-parallel
SET enable_analyzer = '1';

DESCRIBE TABLE (SELECT *);

SELECT *;

SELECT '--';

DESCRIBE TABLE (SELECT COLUMNS(dummy));

SELECT COLUMNS(dummy);

DESCRIBE TABLE (SELECT COLUMNS('d'));

SELECT COLUMNS('d');

DROP TABLE IF EXISTS test_table;

CREATE TABLE test_table
(
    id UInt64,
    value String
)
ENGINE = TinyLog();

INSERT INTO test_table;

DESCRIBE TABLE (SELECT *
FROM test_table);

SELECT *
FROM test_table;

DESCRIBE TABLE (SELECT COLUMNS(id)
FROM test_table);

SELECT COLUMNS(id)
FROM test_table;

DESCRIBE TABLE (SELECT
    COLUMNS(id),
    COLUMNS(value)
FROM test_table);

SELECT
    COLUMNS(id),
    COLUMNS(value)
FROM test_table;

DESCRIBE TABLE (SELECT
    COLUMNS('i'),
    COLUMNS('v')
FROM test_table);

SELECT
    COLUMNS('i'),
    COLUMNS('v')
FROM test_table;

DESCRIBE TABLE (SELECT test_table.*
FROM test_table);

SELECT test_table.*
FROM test_table;

DESCRIBE TABLE (SELECT test_table.COLUMNS(id)
FROM test_table);

SELECT test_table.COLUMNS(id)
FROM test_table;

DESCRIBE TABLE (SELECT
    test_table.COLUMNS(id),
    test_table.COLUMNS(value)
FROM test_table);

SELECT
    test_table.COLUMNS(id),
    test_table.COLUMNS(value)
FROM test_table;

DESCRIBE TABLE (SELECT
    test_table.COLUMNS('i'),
    test_table.COLUMNS('v')
FROM test_table);

SELECT
    test_table.COLUMNS('i'),
    test_table.COLUMNS('v')
FROM test_table;

DROP DATABASE IF EXISTS `02339_db`;

CREATE DATABASE `02339_db`;

DROP TABLE IF EXISTS `02339_db`.test_table;

CREATE TABLE `02339_db`.test_table
(
    id UInt64,
    value String
)
ENGINE = TinyLog();

INSERT INTO `02339_db`.test_table;

DESCRIBE TABLE (SELECT `02339_db`.test_table.*
FROM `02339_db`.test_table);

SELECT `02339_db`.test_table.*
FROM `02339_db`.test_table;

DESCRIBE TABLE (SELECT `02339_db`.test_table.COLUMNS(id)
FROM `02339_db`.test_table);

SELECT `02339_db`.test_table.COLUMNS(id)
FROM `02339_db`.test_table;

DESCRIBE TABLE (SELECT
    `02339_db`.test_table.COLUMNS(id),
    `02339_db`.test_table.COLUMNS(value)
FROM `02339_db`.test_table);

SELECT
    `02339_db`.test_table.COLUMNS(id),
    `02339_db`.test_table.COLUMNS(value)
FROM `02339_db`.test_table;

DESCRIBE TABLE (SELECT
    `02339_db`.test_table.COLUMNS('i'),
    `02339_db`.test_table.COLUMNS('v')
FROM `02339_db`.test_table);

SELECT
    `02339_db`.test_table.COLUMNS('i'),
    `02339_db`.test_table.COLUMNS('v')
FROM `02339_db`.test_table;

DROP TABLE `02339_db`.test_table;

DROP DATABASE `02339_db`;

DESCRIBE TABLE (SELECT * APPLY(toString)
FROM test_table);

SELECT * APPLY(toString)
FROM test_table;

DESCRIBE TABLE (SELECT * APPLY(x -> toString(x))
FROM test_table);

SELECT * APPLY(x -> toString(x))
FROM test_table;

DESCRIBE TABLE (SELECT * APPLY(x -> toString(x)) APPLY(x -> length(x))
FROM test_table);

SELECT * APPLY(x -> toString(x)) APPLY(x -> length(x))
FROM test_table;

DESCRIBE TABLE (SELECT * APPLY(x -> toString(x)) APPLY(length)
FROM test_table);

SELECT * APPLY(x -> toString(x)) APPLY(length)
FROM test_table;

DESCRIBE TABLE (SELECT * EXCEPT (id)
FROM test_table);

SELECT * EXCEPT (id)
FROM test_table;

DESCRIBE TABLE (SELECT COLUMNS(id, value) EXCEPT (id)
FROM test_table);

SELECT COLUMNS(id, value) EXCEPT (id)
FROM test_table;

DESCRIBE TABLE (SELECT * EXCEPT (id) APPLY(toString)
FROM test_table);

SELECT * EXCEPT (id) APPLY(toString)
FROM test_table;

DESCRIBE TABLE (SELECT COLUMNS(id, value) EXCEPT (id) APPLY(toString)
FROM test_table);

SELECT COLUMNS(id, value) EXCEPT (id) APPLY(toString)
FROM test_table;

DESCRIBE TABLE (SELECT * REPLACE (5 AS id)
FROM test_table);

SELECT * REPLACE (5 AS id)
FROM test_table;

DESCRIBE TABLE (SELECT COLUMNS(id, value) REPLACE (5 AS id)
FROM test_table);

SELECT COLUMNS(id, value) REPLACE (5 AS id)
FROM test_table;

DESCRIBE TABLE (SELECT * REPLACE (5 AS id, 6 AS value)
FROM test_table);

SELECT * REPLACE (5 AS id, 6 AS value)
FROM test_table;

DESCRIBE TABLE (SELECT COLUMNS(id, value) REPLACE (5 AS id, 6 AS value)
FROM test_table);

SELECT COLUMNS(id, value) REPLACE (5 AS id, 6 AS value)
FROM test_table;

DESCRIBE TABLE (SELECT * EXCEPT (id) REPLACE (5 AS id, 6 AS value) APPLY(toString)
FROM test_table);

SELECT * EXCEPT (id) REPLACE (5 AS id, 6 AS value) APPLY(toString)
FROM test_table;

DESCRIBE TABLE (SELECT COLUMNS(id, value) EXCEPT (id) REPLACE (5 AS id, 6 AS value) APPLY(toString)
FROM test_table);

SELECT COLUMNS(id, value) EXCEPT (id) REPLACE (5 AS id, 6 AS value) APPLY(toString)
FROM test_table;