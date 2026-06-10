DROP TABLE IF EXISTS test_lazy;

CREATE TABLE test_lazy
(
    id UInt64
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_bytes_for_wide_part = '1', min_rows_for_wide_part = '1';

INSERT INTO test_lazy SELECT *
FROM numbers(100);

ALTER TABLE test_lazy ADD COLUMN `array` Array(UInt64) SETTINGS mutations_sync = '1';

SELECT
    id,
    `array`
FROM test_lazy
WHERE id = 42
ORDER BY id ASC
LIMIT 10
SETTINGS query_plan_optimize_lazy_materialization = '1';

DROP TABLE test_lazy;