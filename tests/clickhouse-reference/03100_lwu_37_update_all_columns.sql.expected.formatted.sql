DROP TABLE IF EXISTS t0;

CREATE TABLE t0
(
    c0 Int
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS enable_block_number_column = '1', enable_block_offset_column = '1';

INSERT INTO t0 (c0);

SET enable_lightweight_update = '1';

UPDATE t0 SET c0 = 1 WHERE 1;

SELECT c0
FROM t0
ORDER BY c0 ASC;