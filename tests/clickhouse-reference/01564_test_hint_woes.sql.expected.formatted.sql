-- { echo }
CREATE TABLE values_01564
(
    a int,
    CONSTRAINT c1 CHECK a < 10
)
ENGINE = Memory();

-- client error hint after broken insert values
INSERT INTO values_01564; -- { error CANNOT_PARSE_TEXT }

SELECT 1;

SELECT nonexistent AS column; -- { serverError UNKNOWN_IDENTIFIER }

-- server error hint after broken insert values (violated constraint)
INSERT INTO values_01564; -- { serverError VIOLATED_CONSTRAINT }

-- query after values on the same line
INSERT INTO values_01564;

-- a failing insert and then a normal insert (#https://github.com/ClickHouse/ClickHouse/issues/19353)
CREATE TABLE t0
(
    c0 String,
    c1 Int32
)
ENGINE = Memory();

INSERT INTO t0 (c0, c1); -- { error UNKNOWN_IDENTIFIER }

INSERT INTO t0 (c0, c1);

DROP TABLE t0;

DROP TABLE values_01564;