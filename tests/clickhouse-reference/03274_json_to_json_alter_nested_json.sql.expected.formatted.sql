SET enable_json_type = '1';

SET output_format_native_write_json_as_string = '0';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    json JSON(max_dynamic_paths = 8, max_dynamic_types = 4)
)
ENGINE = Memory();

INSERT INTO test FORMAT JSONAsObject;

SELECT arrayJoin(distinctJSONPathsAndTypes(json))
FROM test;

SELECT arrayJoin(distinctJSONPathsAndTypes(arrayJoin(json.k1.:`Array(JSON)`)))
FROM test;

SELECT arrayJoin(distinctJSONPathsAndTypes(arrayJoin(json.k2.:`Array(JSON)`)))
FROM test;

SELECT arrayJoin(distinctJSONPathsAndTypes(arrayJoin(json.k9.:`Array(JSON)`)))
FROM test;

SELECT
    json.k1.:`Array(JSON)`,
    json.k1.:`Array(JSON)`.k1_1.:`Array(JSON)`,
    json.k1.:`Array(JSON)`.k1_1.:`Array(JSON)`.k1_1_1,
    json.k1.:`Array(JSON)`.k1_2.:`Array(JSON)`,
    json.k1.:`Array(JSON)`.k1_2.:`Array(JSON)`.k1_2_1,
    json.k2.:`Array(JSON)`,
    json.k2.:`Array(JSON)`.k2_1.:`Array(JSON)`,
    json.k2.:`Array(JSON)`.k2_1.:`Array(JSON)`.k2_1_1,
    json.k2.:`Array(JSON)`.k2_2.:`Array(JSON)`,
    json.k2.:`Array(JSON)`.k2_2.:`Array(JSON)`.k2_2_1,
    json.k9.:`Array(JSON)`,
    json.k9.:`Array(JSON)`.k9_1.:`Array(JSON)`,
    json.k9.:`Array(JSON)`.k9_1.:`Array(JSON)`.k9_1_1,
    json.k9.:`Array(JSON)`.k9_2.:`Array(JSON)`,
    json.k9.:`Array(JSON)`.k9_2.:`Array(JSON)`.k9_2_1
FROM test
FORMAT JSONColumns;

DROP TABLE IF EXISTS test2;

CREATE TABLE test2
(
    json JSON(max_dynamic_paths = 16, max_dynamic_types = 8)
)
ENGINE = Memory();

INSERT INTO test2 SELECT json
FROM test;

SELECT arrayJoin(distinctJSONPathsAndTypes(json))
FROM test2;

SELECT arrayJoin(distinctJSONPathsAndTypes(arrayJoin(json.k1.:`Array(JSON)`)))
FROM test2;

SELECT arrayJoin(distinctJSONPathsAndTypes(arrayJoin(json.k2.:`Array(JSON)`)))
FROM test2;

SELECT arrayJoin(distinctJSONPathsAndTypes(arrayJoin(json.k9.:`Array(JSON)`)))
FROM test2;

CREATE TABLE test3
(
    json JSON(max_dynamic_paths = 4, max_dynamic_types = 2)
)
ENGINE = Memory();

INSERT INTO test3 SELECT json
FROM test;

SELECT arrayJoin(distinctJSONPathsAndTypes(json))
FROM test3;

SELECT arrayJoin(distinctJSONPathsAndTypes(arrayJoin(json.k1.:`Array(JSON)`)))
FROM test3;

SELECT arrayJoin(distinctJSONPathsAndTypes(arrayJoin(json.k2.:`Array(JSON)`)))
FROM test3;

SELECT arrayJoin(distinctJSONPathsAndTypes(arrayJoin(json.k9.:`Array(JSON)`)))
FROM test3;

CREATE TABLE test4
(
    json JSON(max_dynamic_paths = 8, max_dynamic_types = 4)
)
ENGINE = Memory();

INSERT INTO test4 SELECT json
FROM test2;

SELECT arrayJoin(distinctJSONPathsAndTypes(json))
FROM test4;

SELECT arrayJoin(distinctJSONPathsAndTypes(arrayJoin(json.k1.:`Array(JSON)`)))
FROM test4;

SELECT arrayJoin(distinctJSONPathsAndTypes(arrayJoin(json.k2.:`Array(JSON)`)))
FROM test4;

SELECT arrayJoin(distinctJSONPathsAndTypes(arrayJoin(json.k9.:`Array(JSON)`)))
FROM test4;

DROP TABLE test;

DROP TABLE test2;

DROP TABLE test3;

DROP TABLE test4;