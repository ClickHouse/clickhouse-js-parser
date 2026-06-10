-- Tags: no-fasttest
SET enable_json_type = '1';

SET allow_suspicious_types_in_order_by = '1';

DROP TABLE IF EXISTS t_json_10;

CREATE TABLE t_json_10
(
    o JSON
)
ENGINE = Memory();

INSERT INTO t_json_10 FORMAT JSONAsObject;

SELECT DISTINCT arrayJoin(JSONAllPathsWithTypes(arrayJoin(o.a.c.:`Array(JSON)`))) AS path
FROM t_json_10
ORDER BY path ASC;

SELECT o
FROM t_json_10
ORDER BY o.a.b ASC
FORMAT JSONEachRow;

SELECT
    o.a.b,
    o.a.c.:`Array(JSON)`.d,
    o.a.c.:`Array(JSON)`.e,
    o.a.c.:`Array(JSON)`.f
FROM t_json_10
ORDER BY o.a.b ASC;

DROP TABLE t_json_10;