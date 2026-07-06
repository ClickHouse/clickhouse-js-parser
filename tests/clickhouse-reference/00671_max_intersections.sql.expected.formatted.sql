DROP TABLE IF EXISTS test1_00671;

DROP TABLE IF EXISTS test2_00671;

CREATE TABLE test1_00671
(
    start Integer,
    `end` Integer
)
ENGINE = Memory();

CREATE TABLE test2_00671
(
    start Integer,
    `end` Integer
)
ENGINE = Memory();

INSERT INTO test1_00671 (start, `end`);

INSERT INTO test2_00671 (start, `end`);

SELECT maxIntersections(start, `end`)
FROM test1_00671;

SELECT maxIntersections(start, `end`)
FROM test2_00671;

DROP TABLE test1_00671;

DROP TABLE test2_00671;