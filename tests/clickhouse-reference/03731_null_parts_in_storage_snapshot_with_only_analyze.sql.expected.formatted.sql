-- Possible crash in case of mutations contains subquery, that will use
-- InterpreterSelectQuery() with only_analyze=true, which uses
-- getStorageSnapshotWithoutData(), and may crash in
-- getConditionSelectivityEstimator() since parts was nullptr
DROP TABLE IF EXISTS t0;

DROP TABLE IF EXISTS t1;

CREATE TABLE t0
(
    key Int
)
ENGINE = MergeTree()
ORDER BY ()
SETTINGS auto_statistics_types = '';

CREATE TABLE t1
(
    key Int
)
ENGINE = MergeTree()
ORDER BY ()
SETTINGS auto_statistics_types = '';

INSERT INTO t0;

INSERT INTO t1;

ALTER TABLE t1 UPDATE key = 0 WHERE 1
OR NOT NOT exists((
    SELECT key
    FROM t0
    WHERE key > 0
)) SETTINGS mutations_sync = '2', allow_experimental_analyzer = '0', query_plan_optimize_prewhere = '0', query_plan_enable_optimizations = '0', use_statistics = '1';