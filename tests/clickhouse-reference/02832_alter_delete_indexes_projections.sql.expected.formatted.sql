SET mutations_sync = '2';

DROP TABLE IF EXISTS t_delete_skip_index;

CREATE TABLE t_delete_skip_index
(
    x UInt32,
    y String,
    INDEX i y TYPE minmax() GRANULARITY 3
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t_delete_skip_index SELECT
    number,
    toString(number)
FROM numbers(8192 * 10);

SELECT count()
FROM t_delete_skip_index
WHERE y IN (4, 5);

ALTER TABLE t_delete_skip_index DELETE WHERE x < 8192;

DROP TABLE IF EXISTS t_delete_projection;

CREATE TABLE t_delete_projection
(
    x UInt32,
    y UInt64,
    PROJECTION p (SELECT sum(y))
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

INSERT INTO t_delete_projection SELECT
    number,
    toString(number)
FROM numbers(8192 * 10);

SELECT sum(y)
FROM t_delete_projection
SETTINGS optimize_use_projections = '0';

SELECT sum(y)
FROM t_delete_projection
SETTINGS
    optimize_use_projections = '0',
    force_optimize_projection = '1';

ALTER TABLE t_delete_projection DELETE WHERE x < 8192;