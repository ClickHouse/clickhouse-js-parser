-- Tags: long
SET enable_json_type = '1';

SET max_block_size = '1000';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test SELECT multiIf(number < 1000, '{}'::JSON, number < 3000, '{"a" : 42, "b" : "Hello"}'::JSON, '{"c" : [1, 2, 3], "d" : "2020-01-01"}'::JSON)
FROM numbers(20000);

SELECT DISTINCT arrayJoin(JSONAllPaths(json)) AS path
FROM test
ORDER BY path ASC;

SELECT DISTINCT arrayJoin(JSONDynamicPaths(json)) AS path
FROM test
ORDER BY path ASC;

SELECT DISTINCT arrayJoin(JSONSharedDataPaths(json)) AS path
FROM test
ORDER BY path ASC;

TRUNCATE TABLE test;

INSERT INTO test SELECT multiIf(number < 1000, '{"a" : 42, "b" : "Hello"}'::JSON, number < 3000, '{"c" : [1, 2, 3], "d" : "2020-01-01"}'::JSON, '{"e" : 43, "f" : ["s1", "s2", "s3"]}'::JSON)
FROM numbers(20000);

DROP TABLE test;

CREATE TABLE test
(
    json JSON(max_dynamic_paths = 2)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test SELECT multiIf(number < 1000, '{}'::JSON(max_dynamic_paths = 2), number < 3000, '{"a" : 42, "b" : "Hello"}'::JSON(max_dynamic_paths = 2), '{"c" : [1, 2, 3], "d" : "2020-01-01"}'::JSON(max_dynamic_paths = 2))
FROM numbers(20000);

INSERT INTO test SELECT multiIf(number < 1000, '{"a" : 42, "b" : "Hello"}'::JSON(max_dynamic_paths = 2), number < 3000, '{"c" : [1, 2, 3], "d" : "2020-01-01"}'::JSON(max_dynamic_paths = 2), '{"e" : 43, "f" : ["s1", "s2", "s3"]}'::JSON(max_dynamic_paths = 2))
FROM numbers(20000);

INSERT INTO test SELECT multiIf(number < 1000, '{"a" : 42}'::JSON(max_dynamic_paths = 2), number < 3000, '{"b" : "Hello", "c" : [1, 2, 3], "d" : "2020-01-01"}'::JSON(max_dynamic_paths = 2), '{"e" : 43}'::JSON(max_dynamic_paths = 2))
FROM numbers(20000);

CREATE TABLE test
(
    json JSON(max_dynamic_paths = 8)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test SELECT multiIf(number < 1000, '{}'::JSON(max_dynamic_paths = 8), number < 3000, materialize('{"a" : [{"b" : 42, "c" : [1, 2, 3]}]}')::JSON(max_dynamic_paths = 8), materialize('{"a" : [{"d" : "2020-01-01", "e" : "Hello"}]}')::JSON(max_dynamic_paths = 8))
FROM numbers(20000);

SELECT DISTINCT arrayJoin(JSONAllPaths(arrayJoin(json.a.:`Array(JSON)`))) AS path
FROM test
ORDER BY path ASC;

SELECT DISTINCT arrayJoin(JSONDynamicPaths(arrayJoin(json.a.:`Array(JSON)`))) AS path
FROM test
ORDER BY path ASC;

SELECT DISTINCT arrayJoin(JSONSharedDataPaths(arrayJoin(json.a.:`Array(JSON)`))) AS path
FROM test
ORDER BY path ASC;

INSERT INTO test SELECT multiIf(number < 1000, materialize('{"a" : [{"b" : 42, "c" : [1, 2, 3]}]}')::JSON(max_dynamic_paths = 8), number < 3000, materialize('{"a" : [{"d" : "2020-01-01", "e" : "Hello"}]}')::JSON(max_dynamic_paths = 8), materialize('{"a" : [{"f" : "2020-01-01 00:00:00", "g" : "Hello2"}]}')::JSON(max_dynamic_paths = 8))
FROM numbers(20000);

INSERT INTO test SELECT multiIf(number < 1000, materialize('{"a" : [{"b" : 42}]}')::JSON(max_dynamic_paths = 8), number < 3000, materialize('{"a" : [{"d" : "2020-01-01", "e" : "Hello"}]}')::JSON(max_dynamic_paths = 8), materialize('{"a" : [{"f" : "2020-01-01 00:00:00"}]}')::JSON(max_dynamic_paths = 8))
FROM numbers(20000);