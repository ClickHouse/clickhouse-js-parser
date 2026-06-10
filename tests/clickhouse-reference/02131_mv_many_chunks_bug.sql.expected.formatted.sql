DROP TABLE IF EXISTS t;

DROP TABLE IF EXISTS t_mv;

CREATE TABLE t
(
    x UInt64
)
ENGINE = MergeTree()
ORDER BY x;

CREATE MATERIALIZED VIEW t_mv
ENGINE = MergeTree()
ORDER BY tuple()
AS
SELECT
    uniq(x),
    bitAnd(x, 255) AS y
FROM t
GROUP BY y;

SET max_bytes_before_external_group_by = '1000000000';

SET max_bytes_ratio_before_external_group_by = '0';

SET group_by_two_level_threshold = '100';

SET min_insert_block_size_rows = '100';

INSERT INTO t SELECT number
FROM numbers(300);

SELECT count()
FROM (
        SELECT y
        FROM t_mv
        GROUP BY y
    );