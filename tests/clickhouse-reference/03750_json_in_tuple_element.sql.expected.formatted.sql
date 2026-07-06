SET enable_analyzer = '1';

SELECT tupleElement('{"a" : 42}'::JSON, 'a');

SELECT tupleElement('{"a" : 42}'::JSON(a UInt32), 'a');

SELECT tupleElement(materialize('{"a" : 42}')::JSON, 'a');

SELECT tupleElement(materialize('{"a" : 42}')::JSON(a UInt32), 'a');

SELECT '{"a" : 42}'::JSON.a;

SELECT '{"a" : 42}'::JSON(a UInt32).a;

SELECT materialize('{"a" : 42}')::JSON.a;

SELECT materialize('{"a" : 42}')::JSON(a UInt32).a;

SELECT CAST('[''{"a" : 42}'']' AS Array(JSON))[1].a;

SELECT CAST('[''{"a" : 42}'']' AS Array(JSON(a UInt32)))[1].a;

SELECT materialize(['{"a" : 42}'])::Array(JSON)[1].a;

SELECT materialize(['{"a" : 42}'])::Array(JSON(a UInt32))[1].a;

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON(a UInt32)
)
ENGINE = Memory();

INSERT INTO test;

SELECT tupleElement(json, 'a')
FROM test;

SELECT tupleElement(json, 'b')
FROM test;

SELECT tupleElement(json, 'c')
FROM test;

SELECT tupleElement(json, 'c.:`Array(JSON)`')
FROM test;

SELECT json.c[1].d
FROM test;

EXPLAIN SYNTAX run_query_tree_passes = '1'
SELECT tupleElement(json, 'a')
FROM test
SETTINGS optimize_functions_to_subcolumns = '1';

DROP TABLE test;