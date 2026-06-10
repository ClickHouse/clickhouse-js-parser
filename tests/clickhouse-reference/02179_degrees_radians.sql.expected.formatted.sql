-- test conversion from degrees to radians
DROP TABLE IF EXISTS test_degs_to_rads;

CREATE TABLE test_degs_to_rads
(
    degrees Float64
)
ENGINE = Memory();

INSERT INTO test_degs_to_rads;

INSERT INTO test_degs_to_rads;

INSERT INTO test_degs_to_rads;

INSERT INTO test_degs_to_rads;

INSERT INTO test_degs_to_rads;

INSERT INTO test_degs_to_rads;

INSERT INTO test_degs_to_rads;

INSERT INTO test_degs_to_rads;

INSERT INTO test_degs_to_rads;

-- test that converting degrees to radians and back preserves the original value
SELECT DEGREES(RADIANS(degrees))
FROM test_degs_to_rads
ORDER BY degrees ASC;

-- test that radians func returns correct value for both int and floats
SELECT RADIANS(degrees)
FROM test_degs_to_rads
ORDER BY degrees ASC;

DROP TABLE test_degs_to_rads;

-- test conversion from radians to degrees
DROP TABLE IF EXISTS test_rads_to_degs;

CREATE TABLE test_rads_to_degs
(
    radians Float64
)
ENGINE = Memory();

INSERT INTO test_rads_to_degs;

INSERT INTO test_rads_to_degs;

INSERT INTO test_rads_to_degs;

INSERT INTO test_rads_to_degs;

INSERT INTO test_rads_to_degs;

INSERT INTO test_rads_to_degs;

INSERT INTO test_rads_to_degs;

INSERT INTO test_rads_to_degs;

INSERT INTO test_rads_to_degs;

INSERT INTO test_rads_to_degs;

INSERT INTO test_rads_to_degs;

INSERT INTO test_rads_to_degs;

-- test that converting radians to degrees and back preserves the original value
SELECT RADIANS(DEGREES(radians))
FROM test_rads_to_degs
ORDER BY radians ASC;

-- test that degrees func returns correct value for both int and floats
SELECT DEGREES(radians)
FROM test_rads_to_degs
ORDER BY radians ASC;

DROP TABLE test_rads_to_degs;