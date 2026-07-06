-- Test for issue #75677
DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    a UInt64,
    s String
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS add_minmax_index_for_numeric_columns = '1';

SHOW CREATE TABLE t;

ALTER TABLE t DROP COLUMN s;

DROP TABLE t;