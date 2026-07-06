CREATE TABLE attach_partition_t7
(
    a UInt32,
    b UInt32
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY a;

ALTER TABLE attach_partition_t7 ADD COLUMN mat_column UInt32 MATERIALIZED a + b;

INSERT INTO attach_partition_t7;

CREATE TABLE attach_partition_t8
(
    a UInt32,
    b UInt32
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY a;

ALTER TABLE attach_partition_t8 ATTACH PARTITION ID '1' FROM attach_partition_t7; -- {serverError INCOMPATIBLE_COLUMNS};