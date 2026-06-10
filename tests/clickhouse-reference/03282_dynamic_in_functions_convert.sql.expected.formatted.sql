SET enable_dynamic_type = '1';

CREATE TABLE test
(
    d Dynamic(max_types = 3)
)
ENGINE = Memory();

INSERT INTO test;

SELECT toFloat64(d)
FROM test;

SELECT toUInt32(d)
FROM test;

DROP TABLE test;