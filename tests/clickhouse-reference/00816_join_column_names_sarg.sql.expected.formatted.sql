DROP TABLE IF EXISTS t1_00816;

DROP TABLE IF EXISTS t2_00816;

CREATE TABLE t1_00816
(
    a Int8,
    val Float32
)
ENGINE = Memory();

CREATE TABLE t2_00816
(
    a Int8,
    val Float32
)
ENGINE = Memory();

INSERT INTO t1_00816;

INSERT INTO t2_00816;

SELECT
    t1_00816.a,
    t2_00816.a
FROM
    t1_00816
ALL INNER JOIN t2_00816
    ON t1_00816.a = t2_00816.a;

-- Received exception from server (version 18.14.1):
-- Code: 47. DB::Exception: Received from localhost:9000, 127.0.0.1. DB::Exception: Unknown identifier: t2_00816.a.
-- this query works fine
SELECT
    t1_00816.a,
    t2_00816.*
FROM
    t1_00816
ALL INNER JOIN t2_00816
    ON t1_00816.a = t2_00816.a;

-- and this
SELECT
    t1_00816.a,
    t2_00816.val
FROM
    t1_00816
ALL INNER JOIN t2_00816
    ON t1_00816.a = t2_00816.a;

DROP TABLE t1_00816;

DROP TABLE t2_00816;