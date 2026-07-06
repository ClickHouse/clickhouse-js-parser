DROP TABLE IF EXISTS kv;

CREATE TABLE kv
(
    k UInt32,
    v UInt32
)
ENGINE = Join(`Any`, `Left`, k);

INSERT INTO kv;

INSERT INTO kv;

SELECT joinGet('kv', 'v', toUInt32(1));

CREATE TABLE kv_overwrite
(
    k UInt32,
    v UInt32
)
ENGINE = Join(`Any`, `Left`, k)
SETTINGS join_any_take_last_row = '1';

INSERT INTO kv_overwrite;

INSERT INTO kv_overwrite;

SELECT joinGet('kv_overwrite', 'v', toUInt32(1));

CREATE TABLE t2
(
    k UInt32,
    v UInt32
)
ENGINE = Memory();

INSERT INTO t2;

SET enable_analyzer = '1';

SET join_algorithm = 'hash';

SELECT v
FROM
    (
        SELECT 1 AS k
    ) AS t1
ANY INNER JOIN t2
    USING (k)
SETTINGS join_any_take_last_row = '0';

SELECT v
FROM
    (
        SELECT 1 AS k
    ) AS t1
ANY INNER JOIN t2
    USING (k)
SETTINGS join_any_take_last_row = '1';

DROP TABLE kv;

DROP TABLE kv_overwrite;