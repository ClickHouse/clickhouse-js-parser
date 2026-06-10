DROP TABLE IF EXISTS t1 SYNC;

CREATE TABLE t1
(
    v UInt64
)
ENGINE = ReplicatedMergeTree('/test/tables/{database}/test/t1', 'r1')
ORDER BY v
PARTITION BY v;

INSERT INTO t1;

ALTER TABLE t1 ADD COLUMN s String;

INSERT INTO t1;

ALTER TABLE t1 MODIFY COLUMN s Nullable(String);

-- SELECT _part, * FROM t1;
ALTER TABLE t1 DETACH PARTITION 1;

SELECT
    _part,
    *
FROM t1;

--0 rows in set. Elapsed: 0.001 sec.
ALTER TABLE t1 ATTACH PARTITION 1;

SELECT count()
FROM t1;