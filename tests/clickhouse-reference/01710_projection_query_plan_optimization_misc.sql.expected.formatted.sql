DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    x Int32,
    codectest Int32
)
ENGINE = MergeTree()
ORDER BY x;

ALTER TABLE t ADD PROJECTION x (SELECT * ORDER BY codectest);

INSERT INTO t;

SELECT *
FROM merge('', 't');

DROP TABLE t;