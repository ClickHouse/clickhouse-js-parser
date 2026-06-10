-- Tags: no-fasttest
SET enable_json_type = '1';

SET enable_analyzer = '1';

SET allow_suspicious_types_in_order_by = '1';

SET allow_suspicious_types_in_group_by = '1';

SET output_format_native_write_json_as_string = '0';

DROP TABLE IF EXISTS t_json_array;

CREATE TABLE t_json_array
(
    id UInt32,
    arr Array(JSON)
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO t_json_array FORMAT JSONEachRow;

SELECT
    id,
    arr.k1,
    arr.k2.k3,
    arr.k2.k4,
    arr.k2.k5
FROM t_json_array
ORDER BY id ASC;

SELECT arr
FROM
    t_json_array
ARRAY JOIN arr
ORDER BY arr.k1 ASC
FORMAT JSONEachRow;

SELECT DISTINCT arrayJoin(JSONAllPathsWithTypes(arrayJoin(arr))) AS path
FROM t_json_array
ORDER BY path ASC;

TRUNCATE TABLE t_json_array;

INSERT INTO t_json_array FORMAT JSONEachRow;

SELECT
    id,
    arr.k1.:`Array(JSON)`.k2,
    arr.k1.:`Array(JSON)`.k3,
    arr.k1.:`Array(JSON)`.k4,
    arr.k5.k6
FROM t_json_array
ORDER BY id ASC;

SELECT arrayJoin(arrayJoin(arr.k1.:`Array(JSON)`)) AS k1
FROM t_json_array
ORDER BY toString(k1) ASC
FORMAT JSONEachRow;

SELECT DISTINCT arrayJoin(JSONAllPathsWithTypes(arrayJoin(arrayJoin(arr.k1.:`Array(JSON)`)))) AS path
FROM t_json_array
ORDER BY path ASC;

SELECT arr.k1
FROM t_json_array
GROUP BY arr.k1
ORDER BY toString(arr.k1) ASC;

DROP TABLE t_json_array;

SELECT *
FROM values('arr Array(JSON)', '[''{"x" : 1}'']')
FORMAT JSONEachRow;

SELECT *
FROM values('arr Map(String, JSON)', '{''x'' : ''{"y" : 1}'', ''t'' : ''{"y" : 2}''}')
FORMAT JSONEachRow;

SELECT *
FROM values('arr Tuple(Int32, JSON)', '(1, ''{"y" : 1}'')', '(2, ''{"y" : 2}'')')
FORMAT JSONEachRow;

SELECT *
FROM format(JSONEachRow, '{"arr" : [{"x" : "aaa", "y" : [1,2,3]}]}')
FORMAT JSONEachRow;