SET allow_experimental_dynamic_type = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    d Dynamic
)
ENGINE = Memory();

INSERT INTO test SELECT *
FROM numbers(5);

ALTER TABLE test MODIFY COLUMN d Dynamic(max_types = 0);

SELECT d.UInt64
FROM test
SETTINGS enable_analyzer = '1';

SELECT d.UInt64
FROM test
SETTINGS enable_analyzer = '0';

DROP TABLE test;