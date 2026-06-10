-- Tags: no-parallel
CREATE DATABASE IF NOT EXISTS test_max_num_to_warn_02931;

CREATE TABLE IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_1
(
    id Int32,
    str String
)
ENGINE = Memory();

CREATE TABLE IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_2
(
    id Int32,
    str String
)
ENGINE = Memory();

CREATE TABLE IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_3
(
    id Int32,
    str String
)
ENGINE = Memory();

CREATE TABLE IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_4
(
    id Int32,
    str String
)
ENGINE = Memory();

CREATE TABLE IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_5
(
    id Int32,
    str String
)
ENGINE = Memory();

CREATE TABLE IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_6
(
    id Int32,
    str String
)
ENGINE = Memory();

CREATE TABLE IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_7
(
    id Int32,
    str String
)
ENGINE = Memory();

CREATE TABLE IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_8
(
    id Int32,
    str String
)
ENGINE = Memory();

CREATE TABLE IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_9
(
    id Int32,
    str String
)
ENGINE = Memory();

CREATE TABLE IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_10
(
    id Int32,
    str String
)
ENGINE = Memory();

CREATE TABLE IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_11
(
    id Int32,
    str String
)
ENGINE = Memory();

CREATE VIEW IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_view_1
AS
SELECT *
FROM test_max_num_to_warn_02931.test_max_num_to_warn_1;

CREATE VIEW IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_view_2
AS
SELECT *
FROM test_max_num_to_warn_02931.test_max_num_to_warn_2;

CREATE VIEW IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_view_3
AS
SELECT *
FROM test_max_num_to_warn_02931.test_max_num_to_warn_3;

CREATE VIEW IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_view_4
AS
SELECT *
FROM test_max_num_to_warn_02931.test_max_num_to_warn_4;

CREATE VIEW IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_view_5
AS
SELECT *
FROM test_max_num_to_warn_02931.test_max_num_to_warn_5;

CREATE VIEW IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_view_6
AS
SELECT *
FROM test_max_num_to_warn_02931.test_max_num_to_warn_6;

CREATE VIEW IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_view_7
AS
SELECT *
FROM test_max_num_to_warn_02931.test_max_num_to_warn_7;

CREATE VIEW IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_view_8
AS
SELECT *
FROM test_max_num_to_warn_02931.test_max_num_to_warn_8;

CREATE VIEW IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_view_9
AS
SELECT *
FROM test_max_num_to_warn_02931.test_max_num_to_warn_9;

CREATE VIEW IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_view_10
AS
SELECT *
FROM test_max_num_to_warn_02931.test_max_num_to_warn_10;

CREATE VIEW IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_view_11
AS
SELECT *
FROM test_max_num_to_warn_02931.test_max_num_to_warn_11;

CREATE DICTIONARY IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_dict_1
(
    id Int32,
    str String
)
PRIMARY KEY id
SOURCE(clickhouse(DB 'test_max_num_to_warn_02931' TABLE 'test_max_num_to_warn_1'))
LIFETIME(MIN 0 MAX 1000)
LAYOUT(FLAT());

CREATE DICTIONARY IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_dict_2
(
    id Int32,
    str String
)
PRIMARY KEY id
SOURCE(clickhouse(DB 'test_max_num_to_warn_02931' TABLE 'test_max_num_to_warn_2'))
LIFETIME(MIN 0 MAX 1000)
LAYOUT(FLAT());

CREATE DICTIONARY IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_dict_3
(
    id Int32,
    str String
)
PRIMARY KEY id
SOURCE(clickhouse(DB 'test_max_num_to_warn_02931' TABLE 'test_max_num_to_warn_3'))
LIFETIME(MIN 0 MAX 1000)
LAYOUT(FLAT());

CREATE DICTIONARY IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_dict_4
(
    id Int32,
    str String
)
PRIMARY KEY id
SOURCE(clickhouse(DB 'test_max_num_to_warn_02931' TABLE 'test_max_num_to_warn_4'))
LIFETIME(MIN 0 MAX 1000)
LAYOUT(FLAT());

CREATE DICTIONARY IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_dict_5
(
    id Int32,
    str String
)
PRIMARY KEY id
SOURCE(clickhouse(DB 'test_max_num_to_warn_02931' TABLE 'test_max_num_to_warn_5'))
LIFETIME(MIN 0 MAX 1000)
LAYOUT(FLAT());

CREATE DICTIONARY IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_dict_6
(
    id Int32,
    str String
)
PRIMARY KEY id
SOURCE(clickhouse(DB 'test_max_num_to_warn_02931' TABLE 'test_max_num_to_warn_6'))
LIFETIME(MIN 0 MAX 1000)
LAYOUT(FLAT());

CREATE DICTIONARY IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_dict_7
(
    id Int32,
    str String
)
PRIMARY KEY id
SOURCE(clickhouse(DB 'test_max_num_to_warn_02931' TABLE 'test_max_num_to_warn_7'))
LIFETIME(MIN 0 MAX 1000)
LAYOUT(FLAT());

CREATE DICTIONARY IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_dict_8
(
    id Int32,
    str String
)
PRIMARY KEY id
SOURCE(clickhouse(DB 'test_max_num_to_warn_02931' TABLE 'test_max_num_to_warn_8'))
LIFETIME(MIN 0 MAX 1000)
LAYOUT(FLAT());

CREATE DICTIONARY IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_dict_9
(
    id Int32,
    str String
)
PRIMARY KEY id
SOURCE(clickhouse(DB 'test_max_num_to_warn_02931' TABLE 'test_max_num_to_warn_9'))
LIFETIME(MIN 0 MAX 1000)
LAYOUT(FLAT());

CREATE DICTIONARY IF NOT EXISTS test_max_num_to_warn_02931.test_max_num_to_warn_dict_10
(
    id Int32,
    str String
)
PRIMARY KEY id
SOURCE(clickhouse(DB 'test_max_num_to_warn_02931' TABLE 'test_max_num_to_warn_10'))
LIFETIME(MIN 0 MAX 1000)
LAYOUT(FLAT());

CREATE DATABASE IF NOT EXISTS test_max_num_to_warn_1;

CREATE DATABASE IF NOT EXISTS test_max_num_to_warn_2;

CREATE DATABASE IF NOT EXISTS test_max_num_to_warn_3;

CREATE DATABASE IF NOT EXISTS test_max_num_to_warn_4;

CREATE DATABASE IF NOT EXISTS test_max_num_to_warn_5;

CREATE DATABASE IF NOT EXISTS test_max_num_to_warn_6;

CREATE DATABASE IF NOT EXISTS test_max_num_to_warn_7;

CREATE DATABASE IF NOT EXISTS test_max_num_to_warn_8;

CREATE DATABASE IF NOT EXISTS test_max_num_to_warn_9;

CREATE DATABASE IF NOT EXISTS test_max_num_to_warn_10;

CREATE DATABASE IF NOT EXISTS test_max_num_to_warn_11;

INSERT INTO test_max_num_to_warn_02931.test_max_num_to_warn_1;

INSERT INTO test_max_num_to_warn_02931.test_max_num_to_warn_2;

INSERT INTO test_max_num_to_warn_02931.test_max_num_to_warn_3;

INSERT INTO test_max_num_to_warn_02931.test_max_num_to_warn_4;

INSERT INTO test_max_num_to_warn_02931.test_max_num_to_warn_5;

INSERT INTO test_max_num_to_warn_02931.test_max_num_to_warn_6;

INSERT INTO test_max_num_to_warn_02931.test_max_num_to_warn_7;

INSERT INTO test_max_num_to_warn_02931.test_max_num_to_warn_8;

INSERT INTO test_max_num_to_warn_02931.test_max_num_to_warn_9;

INSERT INTO test_max_num_to_warn_02931.test_max_num_to_warn_10;

INSERT INTO test_max_num_to_warn_02931.test_max_num_to_warn_11;

SELECT
    replaceRegexpAll(message, '\\(\\d+\\)', '_'),
    message_format_string
FROM `system`.warnings
WHERE message LIKE 'The number of%'
ORDER BY message ASC;

DROP DATABASE IF EXISTS test_max_num_to_warn_02931;

DROP DATABASE IF EXISTS test_max_num_to_warn_1;

DROP DATABASE IF EXISTS test_max_num_to_warn_2;

DROP DATABASE IF EXISTS test_max_num_to_warn_3;

DROP DATABASE IF EXISTS test_max_num_to_warn_4;

DROP DATABASE IF EXISTS test_max_num_to_warn_5;

DROP DATABASE IF EXISTS test_max_num_to_warn_6;

DROP DATABASE IF EXISTS test_max_num_to_warn_7;

DROP DATABASE IF EXISTS test_max_num_to_warn_8;

DROP DATABASE IF EXISTS test_max_num_to_warn_9;

DROP DATABASE IF EXISTS test_max_num_to_warn_10;

DROP DATABASE IF EXISTS test_max_num_to_warn_11;