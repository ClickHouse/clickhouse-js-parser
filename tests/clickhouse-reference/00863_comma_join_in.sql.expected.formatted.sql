DROP TABLE IF EXISTS test1_00863;

DROP TABLE IF EXISTS test2_00863;

DROP TABLE IF EXISTS test3_00863;

CREATE TABLE test1_00863
(
    id UInt64,
    code String
)
ENGINE = Memory();

CREATE TABLE test3_00863
(
    id UInt64,
    code String
)
ENGINE = Memory();

CREATE TABLE test2_00863
(
    id UInt64,
    code String,
    test1_id UInt64,
    test3_id UInt64
)
ENGINE = Memory();

INSERT INTO test1_00863 (id, code) SELECT
    number,
    toString(number)
FROM numbers(100000);

INSERT INTO test3_00863 (id, code) SELECT
    number,
    toString(number)
FROM numbers(100000);

INSERT INTO test2_00863 (id, code, test1_id, test3_id) SELECT
    number,
    toString(number),
    number,
    number
FROM numbers(100000);

-- `parallel_hash` uses two-level hash tables (that have 256 tables internally), each preallocates 256 elements by default,
-- so we're getting max_threads * 256 * 256 * number_of_joins 
SET max_memory_usage = '300000000';

SELECT test2_00863.id
FROM
    test1_00863,
    test2_00863,
    test3_00863
WHERE test1_00863.code IN ('1', '2', '3')
    AND test2_00863.test1_id = test1_00863.id
    AND test2_00863.test3_id = test3_00863.id
ORDER BY `all` ASC;

DROP TABLE test1_00863;

DROP TABLE test2_00863;

DROP TABLE test3_00863;