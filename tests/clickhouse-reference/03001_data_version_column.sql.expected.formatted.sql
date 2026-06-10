DROP TABLE IF EXISTS t_data_version;

CREATE TABLE t_data_version
(
    a UInt64,
    b UInt64
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO t_data_version;

INSERT INTO t_data_version;

SELECT
    _part,
    _part_data_version,
    *
FROM t_data_version
ORDER BY a ASC;

ALTER TABLE t_data_version UPDATE b = a * 100 WHERE 1 SETTINGS mutations_sync = '2';

INSERT INTO t_data_version;

-- Check parts pruning.
SELECT
    _part,
    _part_data_version,
    *
FROM t_data_version
WHERE _part_data_version = 4
ORDER BY a ASC
SETTINGS max_rows_to_read = '1';

DROP TABLE t_data_version;