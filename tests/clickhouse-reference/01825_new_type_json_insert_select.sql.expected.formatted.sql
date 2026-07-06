-- Tags: no-fasttest
SET enable_json_type = '1';

SET allow_suspicious_types_in_order_by = '1';

SET parallel_replicas_local_plan = '1';

DROP TABLE IF EXISTS type_json_src;

DROP TABLE IF EXISTS type_json_dst;

CREATE TABLE type_json_src
(
    id UInt32,
    data JSON
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE type_json_dst AS type_json_src;

INSERT INTO type_json_src;

INSERT INTO type_json_dst SELECT *
FROM type_json_src;

SELECT DISTINCT arrayJoin(JSONAllPathsWithTypes(data)) AS path
FROM type_json_dst
ORDER BY path ASC;

SELECT
    id,
    data
FROM type_json_dst
ORDER BY id ASC;

INSERT INTO type_json_src;

INSERT INTO type_json_dst SELECT *
FROM type_json_src
WHERE id > 1;

INSERT INTO type_json_dst;

INSERT INTO type_json_src;

INSERT INTO type_json_dst SELECT *
FROM type_json_src
WHERE id = 5;

TRUNCATE TABLE type_json_src;

INSERT INTO type_json_src;

DROP TABLE type_json_src;

DROP TABLE type_json_dst;

CREATE TABLE type_json_dst
(
    data JSON
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE type_json_src
(
    data String
)
ENGINE = MergeTree()
ORDER BY tuple();

SYSTEM STOP MERGES type_json_src;

SET max_threads = '1';

SET max_insert_threads = '1';

SET output_format_json_named_tuples_as_objects = '1';

INSERT INTO type_json_src FORMAT JSONAsString;

INSERT INTO type_json_src FORMAT JSONAsString;

INSERT INTO type_json_dst SELECT data
FROM type_json_src;

SELECT *
FROM type_json_dst
ORDER BY data.k1 ASC
FORMAT JSONEachRow;

TRUNCATE TABLE type_json_dst;