SET enable_json_type = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON(a UInt32, max_dynamic_paths = 2)
)
ENGINE = Memory();

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

INSERT INTO test;

SELECT uniqExact(json)
FROM test;

SELECT
    count(),
    json
FROM test
GROUP BY json
ORDER BY toString(json) ASC;

DROP TABLE test;