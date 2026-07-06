SET input_format_json_try_infer_named_tuples_from_objects = '1';

DESCRIBE TABLE format(JSONEachRow, '{"obj" : {"a" : 42, "b" : "Hello", "c" : [1,2,3]}}');

SELECT *
FROM format(JSONEachRow, '{"obj" : {"a" : 42, "b" : "Hello", "c" : [1,2,3]}}');

DESCRIBE TABLE format(JSONEachRow, '{"obj" : {"a" : 42, "b" : "Hello", "c" : [1,2,3]}}, {"obj" : {"a" : 43, "b" : "World", "d" : "2020-01-01"}}');

SELECT *
FROM format(JSONEachRow, '{"obj" : {"a" : 42, "b" : "Hello", "c" : [1,2,3]}}, {"obj" : {"a" : 43, "b" : "World", "d" : "2020-01-01"}}');

DESCRIBE TABLE format(JSONEachRow, '{"obj" : {"a" : 42, "b" : "Hello", "c" : [1,2,3]}}, {"obj" : {"a" : 43, "b" : "World", "d" : "2020-01-01"}}, {"obj" : {}}');

SELECT *
FROM format(JSONEachRow, '{"obj" : {"a" : 42, "b" : "Hello", "c" : [1,2,3]}}, {"obj" : {"a" : 43, "b" : "World", "d" : "2020-01-01"}}, {"obj" : {}}');

DESCRIBE TABLE format(JSONEachRow, '{"obj" : {"a" : 42, "b" : "Hello", "c" : [1,2,3]}}, {"obj" : {"a" : 43, "b" : "World", "d" : "2020-01-01"}}, {"obj" : {}}, {"obj" : {"d" : "Hello", "b" : "2020-01-01"}}');

SELECT *
FROM format(JSONEachRow, '{"obj" : {"a" : 42, "b" : "Hello", "c" : [1,2,3]}}, {"obj" : {"a" : 43, "b" : "World", "d" : "2020-01-01"}}, {"obj" : {}}, {"obj" : {"d" : "Hello", "b" : "2020-01-01"}}');

DESCRIBE TABLE format(JSONEachRow, '{"obj" : [{"a" : 42, "b" : "Hello", "c" : [1,2,3]}, {"a" : 43, "b" : "World", "d" : "2020-01-01"}]}, {"obj" : [{}]}');

SELECT *
FROM format(JSONEachRow, '{"obj" : [{"a" : 42, "b" : "Hello", "c" : [1,2,3]}, {"a" : 43, "b" : "World", "d" : "2020-01-01"}]}, {"obj" : [{}]}');

DESCRIBE TABLE format(JSONEachRow, '{"obj" : {"nested_obj" : {"a" : 42, "b" : "Hello", "c" : [1,2,3]}}}, {"obj" : {"nested_obj" : {"a" : 43, "b" : "World", "d" : "2020-01-01"}}}, {"obj" : {"nested_obj" : {}}}');

SELECT *
FROM format(JSONEachRow, '{"obj" : {"nested_obj" : {"a" : 42, "b" : "Hello", "c" : [1,2,3]}}}, {"obj" : {"nested_obj" : {"a" : 43, "b" : "World", "d" : "2020-01-01"}}}, {"obj" : {"nested_obj" : {}}}');

DESCRIBE TABLE format(JSONEachRow, '{"obj" : {"a" : {"b" : 1}}}, {"obj" : {"a.b" : 2, "a.b.c" : "Hello"}}');

SELECT *
FROM format(JSONEachRow, '{"obj" : {"a" : {"b" : 1}}}, {"obj" : {"a.b" : 2, "a.b.c" : "Hello"}}');

DESCRIBE TABLE format(JSONEachRow, '{"obj" : {"a" : {}}}, {"obj" : {"a" : {"b" : {"c" : 10}}}}');

SELECT *
FROM format(JSONEachRow, '{"obj" : {"a" : {}}}, {"obj" : {"a" : {"b" : {"c" : 10}}}}');

DESCRIBE TABLE format(JSONEachRow, '{"obj" : {"a" : {}}}');

SELECT *
FROM format(JSONEachRow, '{"obj" : {"a" : {}}}');

DESCRIBE TABLE format(JSONEachRow, '{"obj" : {}}');

SELECT *
FROM format(JSONEachRow, '{"obj" : {}}');

DESCRIBE TABLE format(JSONEachRow, '{"obj" : {"a" : [{}, {"b" : null}, {"c" : {"d" : 10}}]}}, {"obj" : {"a" : [{"e" : "Hello", "b" : [1,2,3]}]}}');

SELECT *
FROM format(JSONEachRow, '{"obj" : {"a" : [{}, {"b" : null}, {"c" : {"d" : 10}}]}}, {"obj" : {"a" : [{"e" : "Hello", "b" : [1,2,3]}]}}');