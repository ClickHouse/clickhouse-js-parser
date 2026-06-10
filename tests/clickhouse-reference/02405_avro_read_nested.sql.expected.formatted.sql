-- Tags: no-fasttest, no-parallel
SET flatten_nested = '1';

INSERT INTO FUNCTION file(`02405_data`.avro) SELECT CAST('[(1, ''aa''), (2, ''bb'')]' AS Nested(x UInt32, y String)) AS nested
SETTINGS engine_file_truncate_on_insert = '1';

SELECT *
FROM file(`02405_data`.avro, auto, 'nested Nested(x UInt32, y String)');

INSERT INTO FUNCTION file(`02405_data`.avro) SELECT CAST('[(1, (2, [''aa'', ''bb'']), [(3, ''cc''), (4, ''dd'')]), (5, (6, [''ee'', ''ff'']), [(7, ''gg''), (8, ''hh'')])]' AS Nested(x UInt32, y Tuple(y1 UInt32, y2 Array(String)), z Nested(z1 UInt32, z2 String))) AS nested
SETTINGS engine_file_truncate_on_insert = '1';

SELECT *
FROM file(`02405_data`.avro, auto, 'nested Nested(x UInt32, y Tuple(y1 UInt32, y2 Array(String)), z Nested(z1 UInt32, z2 String))');