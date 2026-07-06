DROP TABLE IF EXISTS t0;

CREATE TABLE t0
(
    c0 Tuple(),
    c1 int
)
ENGINE = Memory();

INSERT INTO t0;

ALTER TABLE t0 UPDATE c0 = (), c1 = 2 WHERE exists((
    SELECT 1
)) SETTINGS mutations_sync = '2';

SELECT *
FROM t0;

DROP TABLE t0;