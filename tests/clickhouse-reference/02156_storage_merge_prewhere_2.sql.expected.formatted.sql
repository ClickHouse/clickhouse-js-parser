DROP TABLE IF EXISTS t_02156_ololo_1;

DROP TABLE IF EXISTS t_02156_ololo_2;

DROP TABLE IF EXISTS t_02156_ololo_dist;

CREATE TABLE t_02156_ololo_1
(
    k UInt32,
    v Nullable(String)
)
ENGINE = MergeTree()
ORDER BY k;

CREATE TABLE t_02156_ololo_2
(
    k UInt32,
    v String
)
ENGINE = MergeTree()
ORDER BY k;

CREATE TABLE t_02156_ololo_dist
(
    k UInt32,
    v String
)
ENGINE = Distributed(test_shard_localhost, currentDatabase(), t_02156_ololo_2);

CREATE TABLE t_02156_ololo_dist2
(
    k UInt32,
    v Nullable(String)
)
ENGINE = Distributed(test_shard_localhost, currentDatabase(), t_02156_ololo_1);

INSERT INTO t_02156_ololo_1;

INSERT INTO t_02156_ololo_2;

SELECT *
FROM merge('t_02156_ololo')
WHERE k != 0
    AND notEmpty(v)
ORDER BY k ASC
SETTINGS optimize_move_to_prewhere = '0';

SELECT *
FROM merge('t_02156_ololo')
WHERE k != 0
    AND notEmpty(v)
ORDER BY k ASC
SETTINGS optimize_move_to_prewhere = '1';

SELECT *
FROM merge('t_02156_ololo_dist')
WHERE k != 0
    AND notEmpty(v)
ORDER BY k ASC
SETTINGS optimize_move_to_prewhere = '0';

SELECT *
FROM merge('t_02156_ololo_dist')
WHERE k != 0
    AND notEmpty(v)
ORDER BY k ASC
SETTINGS optimize_move_to_prewhere = '1';