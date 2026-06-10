-- Tags: no-random-settings, no-random-merge-tree-settings
DROP TABLE IF EXISTS account_test;

CREATE TABLE account_test
(
    id UInt64,
    row_ver UInt64
)
ENGINE = ReplacingMergeTree(row_ver)
ORDER BY id
SETTINGS index_granularity = '16', index_granularity_bytes = '0', min_rows_for_wide_part = '0', min_bytes_for_wide_part = '0', min_rows_for_compact_part = '0', min_bytes_for_compact_part = '0';

SYSTEM STOP MERGES account_test;

INSERT INTO account_test;

INSERT INTO account_test;

SELECT
    'Disabled',
    *
FROM account_test FINAL
WHERE id = 11338881281426660955
SETTINGS split_parts_ranges_into_intersecting_and_non_intersecting_final = '0';

SELECT
    'Enabled',
    *
FROM account_test FINAL
WHERE id = 11338881281426660955
SETTINGS split_parts_ranges_into_intersecting_and_non_intersecting_final = '1';