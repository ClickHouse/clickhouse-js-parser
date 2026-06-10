DROP TABLE IF EXISTS t7;

CREATE TABLE t7
(
    c57 UInt32
)
ENGINE = MergeTree()
ORDER BY c57;

INSERT INTO t7;

SELECT (
        SELECT count(*)
        FROM t7 AS ref_0
        WHERE ref_0.c57 != multiIf(1 = 1, nan, ref_0.c57)
    ) = (
        SELECT count(*)
        FROM t7 AS ref_0
        WHERE ref_0.c57 != nan
    );

DROP TABLE t7;