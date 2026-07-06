SET enable_json_type = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON
)
ENGINE = Memory();

INSERT INTO test FORMAT JSONAsObject;

SELECT
    dynamicType(json.a),
    json.a
FROM test;

DROP TABLE test;