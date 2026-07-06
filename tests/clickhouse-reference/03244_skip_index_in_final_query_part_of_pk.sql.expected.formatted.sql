-- Testcase for bug #85897
-- If skip index is part of primary key, then optimization 'use_skip_indexes_if_final_exact_mode' should
-- not perform additional primary key intersection expand step.
SET use_skip_indexes_if_final = '1';

SET use_skip_indexes_if_final_exact_mode = '1';

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id1 UInt32,
    id2 UInt32,
    v UInt32,
    INDEX id2_idx id2 TYPE minmax() GRANULARITY 1,
    INDEX v_idx v TYPE minmax() GRANULARITY 1
)
ENGINE = ReplacingMergeTree()
ORDER BY (id1, id2)
SETTINGS index_granularity = '4';

SYSTEM STOP MERGES tab;

INSERT INTO tab SELECT
    number / 100,
    number,
    number
FROM numbers(1000);

INSERT INTO tab SELECT
    number / 50,
    number,
    number * 5
FROM numbers(1000);

SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT count(*)
                FROM tab FINAL
                WHERE v = 222
            ))
    )
WHERE `explain` ILIKE '%PrimaryKeyExpand%';

SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT count(*)
                FROM tab FINAL
                WHERE id2 = 222
            ))
    )
WHERE `explain` ILIKE '%PrimaryKeyExpand%';

DROP TABLE tab;

-- Test from fuzzer : https://github.com/ClickHouse/ClickHouse/issues/89387
DROP TABLE IF EXISTS t0;

CREATE TABLE t0
(
    c0 Int64,
    INDEX i1 c0 TYPE set(0) GRANULARITY 1
)
ENGINE = SummingMergeTree()
ORDER BY c0
PARTITION BY c0;

INSERT INTO t0 (c0) SELECT number
FROM numbers(10);

SELECT rank() OVER ()
FROM t0 FINAL
WHERE t0.c0 > 0.1
FORMAT null;

DROP TABLE t0;