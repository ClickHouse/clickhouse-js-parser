-- Tags: no-fasttest
SELECT *
FROM format(JSONEachRow, '\n{"a": "Hello", "b": 111}\n{"a": "World", "b": 123}\n{"a": "Hello", "b": 111}\n{"a": "World", "b": 123}\n{"a": "Hello", "b": 111}\n{"a": "World", "b": 123}\n{"a": "Hello", "b": 111}\n{"a": "World", "b": 123}\n{"a": "Hello", "b": 111}\n{"a": "World", "b": 123}\n{"a": "Hello", "b": 111}\n{"a": "World", "b": 123}\n{"a": "Hello", "b": 111}\n{"a": "World", "b": 123}\n{"a": "Hello", "b": 111}\n{"a": "World", "b": 123}\n{"a": "Hello", "b": 111}\n{"a": "World", "b": 123}\n{"a": "Hello", "b": 111}\n{"a": "World", "b": 123}\n');

SET max_block_size = '5';

SELECT *
FROM format(CSV, '1,2,"[1,2,3]","[[''abc''], [], [''d'', ''e'']]"');

DESCRIBE TABLE format(CSV, '1,2,"[1,2,3]","[[''abc''], [], [''d'', ''e'']]"');

DROP TABLE IF EXISTS test;

CREATE TABLE test AS format(JSONEachRow, '\n{"a": "Hello", "b": 111}\n{"a": "World", "b": 123}\n{"a": "Hello", "b": 111}\n{"a": "Hello", "b": 131}\n{"a": "World", "b": 123}\n');

SELECT *
FROM test;

DESCRIBE TABLE test;

DROP TABLE test;