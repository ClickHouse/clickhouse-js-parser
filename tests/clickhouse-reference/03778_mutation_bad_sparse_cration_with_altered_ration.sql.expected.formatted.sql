DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    a UInt32,
    b UInt32
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_bytes_for_wide_part = '0', ratio_of_defaults_for_sparse_serialization = 0., max_suspicious_broken_parts = '0', max_suspicious_broken_parts_bytes = '0';

INSERT INTO test SELECT
    number,
    number
FROM numbers(10);

ALTER TABLE test MODIFY SETTING ratio_of_defaults_for_sparse_serialization = 1.;

ALTER TABLE test UPDATE b = 0 WHERE 1 SETTINGS mutations_sync = '2';

DETACH TABLE test;

ATTACH TABLE test;

SELECT *
FROM test;