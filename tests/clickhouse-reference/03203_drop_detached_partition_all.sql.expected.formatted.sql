DROP TABLE IF EXISTS t_03203;

CREATE TABLE t_03203
(
    p UInt64,
    v UInt64
)
ENGINE = MergeTree()
ORDER BY v
PARTITION BY p;

INSERT INTO t_03203;

SELECT *
FROM t_03203
ORDER BY
    p ASC,
    v ASC;

ALTER TABLE t_03203 DETACH PARTITION ALL;

SELECT count()
FROM `system`.detached_parts
WHERE database = currentDatabase()
    AND table = 't_03203';

ALTER TABLE t_03203 DROP DETACHED PARTITION ALL SETTINGS allow_drop_detached = '1';