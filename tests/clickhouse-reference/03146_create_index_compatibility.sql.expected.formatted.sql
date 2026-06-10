DROP TABLE IF EXISTS t_index_3146;

CREATE TABLE t_index_3146
(
    a UInt64,
    b UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

SET allow_create_index_without_type = '1';

CREATE INDEX i1 ON t_index_3146 (a) TYPE minmax GRANULARITY 1;

CREATE INDEX i2 ON t_index_3146 (a, b) TYPE minmax GRANULARITY 1;

CREATE INDEX i3 ON t_index_3146 (a, b) TYPE minmax GRANULARITY 1;

CREATE INDEX i4 ON t_index_3146 (a) TYPE minmax GRANULARITY 1;

CREATE INDEX i5 ON t_index_3146 (a) GRANULARITY 1; -- ignored

CREATE INDEX i6 ON t_index_3146 (a, b) GRANULARITY 1; -- ignored

SHOW CREATE TABLE t_index_3146;

DROP TABLE t_index_3146;