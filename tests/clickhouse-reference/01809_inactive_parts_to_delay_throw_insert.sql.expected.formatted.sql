DROP TABLE IF EXISTS data_01809;

CREATE TABLE data_01809
(
    i int
)
ENGINE = MergeTree()
ORDER BY i
SETTINGS old_parts_lifetime = '10000000000', min_bytes_for_wide_part = '0', inactive_parts_to_throw_insert = '0', inactive_parts_to_delay_insert = '1';

INSERT INTO data_01809;

INSERT INTO data_01809;

OPTIMIZE TABLE data_01809 FINAL;

INSERT INTO data_01809;

DROP TABLE data_01809;