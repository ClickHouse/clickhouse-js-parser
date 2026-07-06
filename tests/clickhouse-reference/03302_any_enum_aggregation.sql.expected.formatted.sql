DROP TABLE IF EXISTS test_33602_t0a;

DROP TABLE IF EXISTS test_33602_t0b;

DROP TABLE IF EXISTS test_33602;

CREATE TABLE test_33602
(
    name String,
    score UInt8,
    user_level Enum8('LOW' = 1, 'MEDIUM' = 2, 'HIGH' = 3)
)
ENGINE = Memory();

SELECT any(user_level)
FROM test_33602;

SELECT
    any(user_level),
    any(name),
    any(score)
FROM test_33602;

SELECT
    anyLast(user_level),
    anyLast(name),
    anyLast(score)
FROM test_33602;

SELECT anyHeavy(user_level)
FROM test_33602;

SELECT
    min(user_level),
    max(user_level)
FROM test_33602;

SELECT
    argMin(user_level, user_level),
    argMax(user_level, user_level)
FROM test_33602;

DROP TABLE test_33602;

CREATE TABLE test_33602_t0a
(
    e Enum8('LOW' = 123, 'MEDIUM' = 12, 'HIGH' = 33)
)
ENGINE = Memory();

SELECT any(e)
FROM test_33602_t0a;

SELECT anyLast(e)
FROM test_33602_t0a;

SELECT anyHeavy(e)
FROM test_33602_t0a;

SELECT
    min(e),
    max(e)
FROM test_33602_t0a;

SELECT
    argMin(e, e),
    argMax(e, e)
FROM test_33602_t0a;

INSERT INTO test_33602_t0a;

DROP TABLE test_33602_t0a;

CREATE TABLE test_33602_t0b
(
    e Enum16('LOW' = 123, 'MEDIUM' = 12, 'HIGH' = 33)
)
ENGINE = Memory();

SELECT any(e)
FROM test_33602_t0b;

SELECT anyLast(e)
FROM test_33602_t0b;

SELECT anyHeavy(e)
FROM test_33602_t0b;

SELECT
    min(e),
    max(e)
FROM test_33602_t0b;

SELECT
    argMin(e, e),
    argMax(e, e)
FROM test_33602_t0b;

INSERT INTO test_33602_t0b;

DROP TABLE test_33602_t0b;