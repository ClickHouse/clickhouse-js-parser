-- Tags: no-fasttest
DROP TABLE IF EXISTS t_json_partitions;

SET enable_json_type = '1';

CREATE TABLE t_json_partitions
(
    id UInt32,
    obj JSON
)
ENGINE = MergeTree()
ORDER BY id
PARTITION BY id;

INSERT INTO t_json_partitions FORMAT JSONEachRow;

SELECT *
FROM t_json_partitions
ORDER BY id ASC
FORMAT JSONEachRow;

DROP TABLE t_json_partitions;