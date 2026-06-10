DROP TABLE IF EXISTS t_temp;

CREATE TABLE t_temp
(
    a UInt32,
    timestamp DateTime
)
ENGINE = MergeTree()
ORDER BY a
TTL timestamp + toIntervalSecond(2) WHERE a IN (
    SELECT number
    FROM `system`.numbers
    LIMIT 10000
);

SELECT sleep(1);

INSERT INTO t_temp SELECT
    rand(),
    now()
FROM `system`.numbers
LIMIT 100000;

OPTIMIZE TABLE t_temp FINAL;

DROP TABLE t_temp;