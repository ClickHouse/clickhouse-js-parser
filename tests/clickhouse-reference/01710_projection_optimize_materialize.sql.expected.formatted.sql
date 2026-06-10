-- Tags: no-random-merge-tree-settings
DROP TABLE IF EXISTS z;

CREATE TABLE z
(
    pk Int64,
    d Date,
    id UInt64,
    c UInt64
)
ENGINE = MergeTree()
ORDER BY pk
PARTITION BY d
SETTINGS ratio_of_defaults_for_sparse_serialization = 1.;

INSERT INTO z SELECT
    number,
    '2021-10-24',
    intDiv(number, 10000),
    1
FROM numbers(1000000);

OPTIMIZE TABLE z FINAL;

ALTER TABLE z ADD PROJECTION pp (SELECT id, sum(c) GROUP BY id);

ALTER TABLE z MATERIALIZE PROJECTION pp SETTINGS mutations_sync = '1';

SELECT
    name,
    `partition`,
    formatReadableSize(sum(data_compressed_bytes) AS size) AS compressed,
    formatReadableSize(sum(data_uncompressed_bytes) AS usize) AS uncompressed,
    round(usize / size, 2) AS compr_rate,
    sum(`rows`) AS `rows`,
    count() AS part_count
FROM `system`.projection_parts
WHERE database = currentDatabase()
    AND table = 'z'
    AND active
GROUP BY
    name,
    `partition`
ORDER BY size DESC;

DROP TABLE z;