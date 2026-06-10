DROP TABLE IF EXISTS data_01709;

CREATE TABLE data_01709
(
    i int
)
ENGINE = MergeTree()
ORDER BY i
SETTINGS old_parts_lifetime = '10000000000', min_bytes_for_wide_part = '0', inactive_parts_to_throw_insert = '1';

INSERT INTO data_01709;

INSERT INTO data_01709;

OPTIMIZE TABLE data_01709 FINAL;

INSERT INTO data_01709; -- { serverError TOO_MANY_PARTS }

DROP TABLE data_01709;