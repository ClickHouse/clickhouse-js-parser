-- Tags: no-parallel, no-fasttest
INSERT INTO FUNCTION file(`02458_data`.jsonl) SELECT
    NULL AS x,
    42 AS y
SETTINGS engine_file_truncate_on_insert = '1';

INSERT INTO FUNCTION file(`02458_data`.jsoncompacteachrow) SELECT
    NULL AS x,
    42 AS y
SETTINGS engine_file_truncate_on_insert = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    x Nullable(UInt32),
    y UInt32
)
ENGINE = Memory();

SET use_structure_from_insertion_table_in_table_functions = '2';

SET input_format_json_infer_incomplete_types_as_strings = '0';

INSERT INTO test SELECT *
FROM file(`02458_data`.jsonl);

INSERT INTO test SELECT
    x,
    1
FROM file(`02458_data`.jsonl);

INSERT INTO test SELECT
    x,
    y
FROM file(`02458_data`.jsonl);

INSERT INTO test SELECT
    x + 1,
    y
FROM file(`02458_data`.jsonl); -- {serverError CANNOT_EXTRACT_TABLE_STRUCTURE}

INSERT INTO test SELECT
    x,
    z
FROM file(`02458_data`.jsonl);

INSERT INTO test SELECT *
FROM file(`02458_data`.jsoncompacteachrow);

INSERT INTO test SELECT
    x,
    1
FROM file(`02458_data`.jsoncompacteachrow); -- {serverError CANNOT_EXTRACT_TABLE_STRUCTURE}

INSERT INTO test SELECT
    x,
    y
FROM file(`02458_data`.jsoncompacteachrow); -- {serverError CANNOT_EXTRACT_TABLE_STRUCTURE}

INSERT INTO test SELECT
    x + 1,
    y
FROM file(`02458_data`.jsoncompacteachrow); -- {serverError CANNOT_EXTRACT_TABLE_STRUCTURE}

INSERT INTO test SELECT
    x,
    z
FROM file(`02458_data`.jsoncompacteachrow); -- {serverError CANNOT_EXTRACT_TABLE_STRUCTURE}

INSERT INTO test SELECT *
FROM input() FORMAT CSV;

SELECT *
FROM test
ORDER BY y ASC;

DROP TABLE test;

CREATE TABLE test
(
    x Nullable(UInt32)
)
ENGINE = Memory();

INSERT INTO test SELECT x
FROM file(`02458_data`.jsonl);

INSERT INTO test SELECT y
FROM file(`02458_data`.jsonl);

INSERT INTO test SELECT y AS x
FROM file(`02458_data`.jsonl);

INSERT INTO test SELECT c1
FROM input() FORMAT CSV; -- {serverError CANNOT_EXTRACT_TABLE_STRUCTURE}

INSERT INTO test SELECT x
FROM input() FORMAT JSONEachRow;

SELECT *
FROM test
ORDER BY x ASC;