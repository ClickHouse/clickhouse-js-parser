-- In some versions vertical merges after DROP COLUMN was broken in some cases
DROP TABLE IF EXISTS data;

CREATE TABLE data
(
    key Int,
    `legacy_features_Map.id` Array(UInt8),
    `legacy_features_Map.count` Array(UInt32)
)
ENGINE = MergeTree()
ORDER BY key
SETTINGS min_bytes_for_wide_part = '0', min_rows_for_wide_part = '0', vertical_merge_algorithm_min_rows_to_activate = '0', vertical_merge_algorithm_min_columns_to_activate = '0';

INSERT INTO data (key);

INSERT INTO data (key);

ALTER TABLE data ADD COLUMN `features_legacy_Map.id` Array(UInt8), ADD COLUMN `features_legacy_Map.count` Array(UInt32);

ALTER TABLE data DROP COLUMN legacy_features_Map SETTINGS mutations_sync = '2';

OPTIMIZE TABLE data FINAL;

DROP TABLE data;