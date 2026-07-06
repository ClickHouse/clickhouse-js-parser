SET enable_json_type = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON(max_dynamic_paths = 8)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_bytes_for_wide_part = '1', min_rows_for_wide_part = '1';

INSERT INTO test SELECT materialize('{"a" : [{"b" : 42}]}')::JSON(max_dynamic_paths = 8)
FROM numbers(5);

INSERT INTO test SELECT materialize('{"aa1" : 42, "aa2" : 42, "aa3" : 42, "aa4" : 42, "aa5" : 42, "aa6" : 42, "aa7" : 42, "aa8" : 42, "a" : [{"c" : 42}]}')
FROM numbers(5);

OPTIMIZE TABLE test FINAL;

SELECT JSONAllPaths(arrayJoin(json.a.:`Array(JSON)`))
FROM test;

SELECT JSONDynamicPaths(arrayJoin(json.a.:`Array(JSON)`))
FROM test;

SELECT JSONSharedDataPaths(arrayJoin(json.a.:`Array(JSON)`))
FROM test;

DROP TABLE test;