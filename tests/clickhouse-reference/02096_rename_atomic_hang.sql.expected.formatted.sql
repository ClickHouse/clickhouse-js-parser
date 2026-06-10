-- Tags: no-parallel
SET send_logs_level = 'fatal';

DROP DATABASE IF EXISTS db_hang;

DROP DATABASE IF EXISTS db_hang_temp;

SET allow_deprecated_database_ordinary = '1';

-- Creation of a database with Ordinary engine emits a warning.
CREATE DATABASE db_hang
ENGINE = Ordinary();

USE db_hang;

CREATE TABLE db_hang.test
(
    A Int64
)
ENGINE = MergeTree()
ORDER BY A;

CREATE MATERIALIZED VIEW db_hang.test_mv
(
    A Int64
)
ENGINE = MergeTree()
ORDER BY A
AS
SELECT *
FROM db_hang.test;

INSERT INTO db_hang.test SELECT *
FROM numbers(1000);

CREATE DATABASE db_hang_temp
ENGINE = Atomic();

RENAME TABLE db_hang.test TO db_hang_temp.test;

RENAME TABLE db_hang.test_mv TO db_hang_temp.test_mv;

DROP DATABASE db_hang;

RENAME DATABASE db_hang_temp TO db_hang;

SELECT count()
FROM db_hang.test;

SELECT count()
FROM db_hang.test_mv;