-- add_minmax_index_for_numeric_columns=0: Adds more output to system.data_skipping_indices
DROP TABLE IF EXISTS t_index;

CREATE TABLE t_index
(
    a int,
    b String
)
ENGINE = MergeTree()
ORDER BY a
SETTINGS add_minmax_index_for_numeric_columns = '0';

CREATE INDEX i_a ON t_index (a) TYPE minmax GRANULARITY 4;

CREATE INDEX IF NOT EXISTS i_a ON t_index (a) TYPE minmax GRANULARITY 2;

CREATE INDEX i_b ON t_index (b) TYPE bloom_filter GRANULARITY 2;

SHOW CREATE TABLE t_index;

SELECT
    table,
    name,
    type,
    expr,
    granularity
FROM `system`.data_skipping_indices
WHERE database = currentDatabase()
    AND table = 't_index';

DROP INDEX i_a ON t_index;

DROP INDEX IF EXISTS i_a ON t_index;

DROP TABLE t_index;

CREATE TABLE t_index
(
    a int,
    b String
)
ENGINE = ReplicatedMergeTree('/test/2319/{database}', '1')
ORDER BY a
SETTINGS add_minmax_index_for_numeric_columns = '0';

CREATE TABLE t_index_replica
(
    a int,
    b String
)
ENGINE = ReplicatedMergeTree('/test/2319/{database}', '2')
ORDER BY a
SETTINGS add_minmax_index_for_numeric_columns = '0';

SYSTEM SYNC REPLICA t_index_replica;

SHOW CREATE TABLE t_index_replica;

SELECT
    table,
    name,
    type,
    expr,
    granularity
FROM `system`.data_skipping_indices
WHERE database = currentDatabase()
    AND table = 't_index_replica';