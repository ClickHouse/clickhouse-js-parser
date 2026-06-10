SET enable_json_type = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON
)
ENGINE = Memory();

INSERT INTO test SELECT toJSONString(map('a', 'str_' || number))
FROM numbers(5);

SELECT json.a.String
FROM test;

SELECT json.a.:String
FROM test;

SELECT json.a.UInt64
FROM test;

DROP TABLE test;