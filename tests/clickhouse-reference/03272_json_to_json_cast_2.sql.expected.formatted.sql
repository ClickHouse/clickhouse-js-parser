-- Tags: long
SET enable_json_type = '1';

SET enable_analyzer = '1';

SET output_format_native_write_json_as_string = '0';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON(max_dynamic_paths = 4)
)
ENGINE = Memory();

INSERT INTO test FORMAT JSONAsObject;

SELECT
    json::JSON(max_dynamic_paths = 3) AS json2,
    JSONAllPaths(json2),
    JSONSharedDataPaths(json2),
    json2.k1,
    json2.k2,
    json2.k3,
    json2.k4
FROM test;

SELECT
    json::JSON(max_dynamic_paths = 2) AS json2,
    JSONAllPaths(json2),
    JSONSharedDataPaths(json2),
    json2.k1,
    json2.k2,
    json2.k3,
    json2.k4
FROM test;

SELECT
    json::JSON(max_dynamic_paths = 1) AS json2,
    JSONAllPaths(json2),
    JSONSharedDataPaths(json2),
    json2.k1,
    json2.k2,
    json2.k3,
    json2.k4
FROM test;

SELECT
    json::JSON(max_dynamic_paths = 0) AS json2,
    JSONAllPaths(json2),
    JSONSharedDataPaths(json2),
    json2.k1,
    json2.k2,
    json2.k3,
    json2.k4
FROM test;

DROP TABLE test;

SET max_block_size = '1000';

SET max_threads = '1';

CREATE TABLE test
(
    id UInt64,
    json JSON(max_dynamic_paths = 4)
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS min_rows_for_wide_part = '1', min_bytes_for_wide_part = '1';

INSERT INTO test SELECT
    number,
    multiIf(number < 1000, '{"k2" : 42}', number < 3000, '{"k3" : 42}', number < 6000, '{"k4" : 42}', number < 10000, '{"k1" : 42}', '{"k1" : 42, "k2" : 42, "k3" : 42, "k4" : 42}')
FROM numbers(15000);

SELECT DISTINCT arrayJoin(JSONAllPaths(json2))
FROM (
        SELECT json::JSON(max_dynamic_paths = 3) AS json2
        FROM test
    )
ORDER BY `all` ASC;

SELECT DISTINCT arrayJoin(JSONAllPaths(json2))
FROM (
        SELECT json::JSON(max_dynamic_paths = 2) AS json2
        FROM test
    )
ORDER BY `all` ASC;

SELECT DISTINCT arrayJoin(JSONAllPaths(json2))
FROM (
        SELECT json::JSON(max_dynamic_paths = 1) AS json2
        FROM test
    )
ORDER BY `all` ASC;

SELECT DISTINCT arrayJoin(JSONAllPaths(json2))
FROM (
        SELECT json::JSON(max_dynamic_paths = 0) AS json2
        FROM test
    )
ORDER BY `all` ASC;