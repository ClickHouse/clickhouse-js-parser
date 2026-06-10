SET enable_json_type = '1';

CREATE TABLE test
(
    json JSON
)
ENGINE = Memory();

INSERT INTO test;

SELECT
    json,
    notEmpty(json)
FROM test;

DROP TABLE test;

CREATE TABLE test
(
    json JSON(a UInt32)
)
ENGINE = Memory();

CREATE TABLE test
(
    json JSON(max_dynamic_paths = 1)
)
ENGINE = Memory();

CREATE TABLE test
(
    json JSON(max_dynamic_paths = 0)
)
ENGINE = Memory();