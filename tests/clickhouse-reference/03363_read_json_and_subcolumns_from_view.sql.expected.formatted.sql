SET enable_json_type = '1';

SET enable_analyzer = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    data JSON
)
ENGINE = Memory();

INSERT INTO test SELECT '{"a" : 42}';

CREATE VIEW test_view
AS
SELECT data
FROM test;

SELECT *
FROM test_view;

SELECT data
FROM test_view;

SELECT data.a
FROM test_view;

SELECT data.b
FROM test_view;

SELECT data.a.:Int64
FROM test_view;

DROP TABLE test;