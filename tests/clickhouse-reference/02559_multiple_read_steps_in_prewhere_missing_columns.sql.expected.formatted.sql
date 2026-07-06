DROP TABLE IF EXISTS test_02559;

CREATE TABLE test_02559
(
    x UInt8,
    s String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_02559;

ALTER TABLE test_02559 ADD COLUMN y UInt8 DEFAULT 0;

INSERT INTO test_02559;

SELECT *
FROM test_02559
ORDER BY x ASC;

SET enable_multiple_prewhere_read_steps = true, move_all_conditions_to_prewhere = true;

-- { echoOn }
SELECT s
FROM test_02559
PREWHERE x
    AND y
ORDER BY s ASC;

SELECT
    s,
    y
FROM test_02559
PREWHERE y
ORDER BY s ASC;

SELECT
    s,
    y
FROM test_02559
PREWHERE NOT y
ORDER BY s ASC;

SELECT
    s,
    y
FROM test_02559
PREWHERE x
    AND y
ORDER BY s ASC;

SELECT
    s,
    y
FROM test_02559
PREWHERE x
    AND NOT y
ORDER BY s ASC;

SELECT
    s,
    y
FROM test_02559
PREWHERE y
    AND x
ORDER BY s ASC;

SELECT
    s,
    y
FROM test_02559
PREWHERE NOT y
    AND x
ORDER BY s ASC;

ALTER TABLE test_02559 ADD COLUMN z UInt8 DEFAULT 10;

INSERT INTO test_02559;

SELECT s
FROM test_02559
PREWHERE z
ORDER BY s ASC;

SELECT s
FROM test_02559
PREWHERE y
    AND z
ORDER BY s ASC;

SELECT
    s,
    z
FROM test_02559
PREWHERE NOT y
    AND z
ORDER BY s ASC;

-- { echoOff }
DROP TABLE test_02559;