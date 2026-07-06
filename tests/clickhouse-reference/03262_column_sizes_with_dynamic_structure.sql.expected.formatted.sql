-- Tags: no-random-settings, no-fasttest
SET allow_experimental_dynamic_type = '1';

SET enable_json_type = '1';

DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    d Dynamic,
    json JSON
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_rows_for_wide_part = '0', min_bytes_for_wide_part = '1', object_serialization_version = 'v2', dynamic_serialization_version = 'v2';

INSERT INTO test SELECT
    number,
    '{"a" : 42, "b" : "Hello, World"}'
FROM numbers(10000000);

SELECT
    table,
    sum(`rows`) AS `rows`,
    floor(sum(data_uncompressed_bytes) / (1024 * 1024)) AS data_size_uncompressed,
    floor(sum(data_compressed_bytes) / (1024 * 1024)) AS data_size_compressed,
    floor(sum(bytes_on_disk) / (1024 * 1024)) AS total_size_on_disk
FROM `system`.parts
WHERE active
    AND database = currentDatabase()
    AND table = 'test'
GROUP BY table
ORDER BY table ASC;

DROP TABLE test;