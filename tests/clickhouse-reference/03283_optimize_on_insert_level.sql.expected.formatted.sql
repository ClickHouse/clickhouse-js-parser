SET insert_keeper_fault_injection_probability = '0';

SET max_threads = '4';

DROP TABLE IF EXISTS t_optimize_level;

CREATE TABLE t_optimize_level
(
    a UInt64,
    b UInt64
)
ENGINE = ReplacingMergeTree()
ORDER BY a
SETTINGS index_granularity = '1';

SYSTEM STOP MERGES t_optimize_level;

INSERT INTO t_optimize_level;

INSERT INTO t_optimize_level;

SELECT
    _part,
    a,
    b
FROM t_optimize_level
ORDER BY a ASC;

SELECT count()
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN PIPELINE', '', (
                SELECT
                    a,
                    b
                FROM t_optimize_level FINAL
            ))
    )
WHERE `explain` LIKE '%Replacing%';

ALTER TABLE t_optimize_level DETACH PARTITION tuple();

ALTER TABLE t_optimize_level ATTACH PARTITION tuple();

SELECT name
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 't_optimize_level'
    AND active;

DROP TABLE t_optimize_level;

CREATE TABLE t_optimize_level
(
    a UInt64,
    b UInt64
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/{database}/03283_optimize_on_insert_level', '1')
ORDER BY a
SETTINGS index_granularity = '1';