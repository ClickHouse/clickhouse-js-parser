DROP TABLE IF EXISTS t0;

CREATE TABLE t0
(
    c0 Bool
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY c0;

INSERT INTO t0 (c0);

SELECT part_name
FROM `system`.parts
WHERE table = 't0'
    AND database = currentDatabase();

DELETE FROM t0 WHERE c0;

SELECT c0
FROM t0;

DROP TABLE t0;