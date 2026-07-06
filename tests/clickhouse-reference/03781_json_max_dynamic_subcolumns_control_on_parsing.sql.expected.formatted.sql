DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test SELECT toJSONString(arrayMap((x -> tuple('a' || x, x)), range(20))::Map(String, UInt32))
FROM numbers(1000000)
SETTINGS max_dynamic_subcolumns_in_json_type_parsing = '10';

SELECT DISTINCT arrayJoin(JSONDynamicPaths(json)) AS path
FROM test
ORDER BY path ASC;

DROP TABLE test;