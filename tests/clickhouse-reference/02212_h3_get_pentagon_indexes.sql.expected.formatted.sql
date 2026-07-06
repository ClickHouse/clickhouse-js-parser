-- Tags: no-fasttest
DROP TABLE IF EXISTS table1;

CREATE TABLE table1
(
    resolution UInt8
)
ENGINE = Memory();

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

INSERT INTO table1;

SELECT h3GetPentagonIndexes(resolution) AS indexes
FROM table1
ORDER BY indexes ASC;

SELECT h3GetPentagonIndexes(20) AS indexes; -- { serverError ARGUMENT_OUT_OF_BOUND }

DROP TABLE table1;

-- tests for const cols
SELECT '-- test for const cols';

SELECT h3GetPentagonIndexes(arrayJoin([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]));