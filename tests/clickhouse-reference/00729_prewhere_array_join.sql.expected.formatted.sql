SET send_logs_level = 'fatal';

DROP TABLE IF EXISTS t1_00729;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE t1_00729
(
    id UInt64,
    val Array(String),
    nid UInt64,
    eDate Date
)
ENGINE = MergeTree(eDate, (id, eDate), 8192);

INSERT INTO t1_00729 (id, val, nid, eDate);

INSERT INTO t1_00729 (id, val, nid, eDate);

INSERT INTO t1_00729 (id, val, nid, eDate);

INSERT INTO t1_00729 (id, val, nid, eDate);

INSERT INTO t1_00729 (id, val, nid, eDate);

INSERT INTO t1_00729 (id, val, nid, eDate);

INSERT INTO t1_00729 (id, val, nid, eDate);

INSERT INTO t1_00729 (id, val, nid, eDate);

SELECT arrayJoin(val) AS nameGroup6
FROM t1_00729
PREWHERE notEmpty(toString(nameGroup6))
GROUP BY nameGroup6
ORDER BY nameGroup6 ASC; -- { serverError ILLEGAL_PREWHERE }

SELECT
    arrayJoin(val) AS nameGroup6,
    countDistinct(nid) AS rowids
FROM t1_00729
WHERE notEmpty(toString(nameGroup6))
GROUP BY nameGroup6
ORDER BY nameGroup6 ASC;

SELECT
    arrayJoin(val) AS nameGroup6,
    countDistinct(nid) AS rowids
FROM t1_00729
PREWHERE notEmpty(toString(nameGroup6))
GROUP BY nameGroup6
ORDER BY nameGroup6 ASC; -- { serverError ILLEGAL_PREWHERE }

DROP TABLE t1_00729;

CREATE TABLE t1_00729
(
    id UInt64,
    val Array(String),
    nid UInt64,
    eDate Date
)
ENGINE = MergeTree(eDate, (id, eDate), 8192);