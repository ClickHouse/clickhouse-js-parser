-- Tags: no-parallel, memory-engine, log-engine
SET send_logs_level = 'fatal';

DROP DATABASE IF EXISTS test_1603_rename_bug_ordinary;

SET allow_deprecated_database_ordinary = '1';

-- Creation of a database with Ordinary engine emits a warning.
CREATE DATABASE test_1603_rename_bug_ordinary
ENGINE = Ordinary();

CREATE TABLE test_1603_rename_bug_ordinary.foo
ENGINE = Memory() AS
SELECT *
FROM numbers(100);

CREATE TABLE test_1603_rename_bug_ordinary.bar
ENGINE = Log() AS
SELECT *
FROM numbers(200);

DETACH TABLE test_1603_rename_bug_ordinary.foo;

RENAME TABLE test_1603_rename_bug_ordinary.bar TO test_1603_rename_bug_ordinary.foo; -- { serverError TABLE_ALREADY_EXISTS }

ATTACH TABLE test_1603_rename_bug_ordinary.foo;

SELECT count()
FROM test_1603_rename_bug_ordinary.foo;

SELECT count()
FROM test_1603_rename_bug_ordinary.bar;

DROP DATABASE test_1603_rename_bug_ordinary;

-- was not broken, adding just in case.
DROP DATABASE IF EXISTS test_1603_rename_bug_atomic;

CREATE DATABASE test_1603_rename_bug_atomic
ENGINE = Atomic();

CREATE TABLE test_1603_rename_bug_atomic.foo
ENGINE = Memory() AS
SELECT *
FROM numbers(100);

CREATE TABLE test_1603_rename_bug_atomic.bar
ENGINE = Log() AS
SELECT *
FROM numbers(200);

DETACH TABLE test_1603_rename_bug_atomic.foo;

RENAME TABLE test_1603_rename_bug_atomic.bar TO test_1603_rename_bug_atomic.foo; -- { serverError TABLE_ALREADY_EXISTS }

ATTACH TABLE test_1603_rename_bug_atomic.foo;

SELECT count()
FROM test_1603_rename_bug_atomic.foo;

SELECT count()
FROM test_1603_rename_bug_atomic.bar;

DROP DATABASE test_1603_rename_bug_atomic;