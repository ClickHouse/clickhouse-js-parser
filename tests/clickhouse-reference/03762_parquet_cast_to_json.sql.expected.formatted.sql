-- Tags: no-fasttest
INSERT INTO FUNCTION file(currentDatabase() || '_03762_tuple.parquet') SELECT tuple(42, [tuple(44, 'hello')])::Tuple(a UInt32, b Array(Tuple(c UInt32, d String))) AS data
SETTINGS engine_file_truncate_on_insert = '1';

SELECT data
FROM file(currentDatabase() || '_03762_tuple.parquet', auto, 'data JSON');

INSERT INTO FUNCTION file(currentDatabase() || '_03762_map.parquet') SELECT map('a', [], 'b', [map('c', 44, 'd', 69)]) AS data
SETTINGS engine_file_truncate_on_insert = '1';

SELECT data
FROM file(currentDatabase() || '_03762_map.parquet', auto, 'data JSON');