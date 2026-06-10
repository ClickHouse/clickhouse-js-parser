-- Tags: no-fasttest
INSERT INTO FUNCTION file(currentDatabase() || '_data_02313.avro') SELECT tuple(number, 'String')::Tuple(a UInt32, b String) AS t
FROM numbers(3)
SETTINGS engine_file_truncate_on_insert = '1';

DESCRIBE TABLE file(currentDatabase() || '_data_02313.avro');

SELECT *
FROM file(currentDatabase() || '_data_02313.avro');

INSERT INTO FUNCTION file(currentDatabase() || '_data_02313.avro') SELECT tuple(number, tuple(number + 1, number + 2), range(number))::Tuple(a UInt32, b Tuple(c UInt32, d UInt32), e Array(UInt32)) AS t
FROM numbers(3)
SETTINGS engine_file_truncate_on_insert = '1';

INSERT INTO FUNCTION file(currentDatabase() || '_data_02313.avro', auto, 'a Nested(b UInt32, c UInt32)') SELECT
    [number, number + 1],
    [number + 2, number + 3]
FROM numbers(3)
SETTINGS engine_file_truncate_on_insert = '1';

INSERT INTO FUNCTION file(currentDatabase() || '_data_02313.avro', auto, 'a Nested(b Nested(c UInt32, d UInt32))') SELECT [[(number, number + 1), (number + 2, number + 3)]]
FROM numbers(3)
SETTINGS engine_file_truncate_on_insert = '1';

INSERT INTO FUNCTION file(currentDatabase() || '_data_02313.avro') SELECT map(concat('key_', toString(number)), number) AS m
FROM numbers(3)
SETTINGS engine_file_truncate_on_insert = '1';

INSERT INTO FUNCTION file(currentDatabase() || '_data_02313.avro') SELECT map(concat('key_', toString(number)), tuple(number, range(number))) AS m
FROM numbers(3)
SETTINGS engine_file_truncate_on_insert = '1';