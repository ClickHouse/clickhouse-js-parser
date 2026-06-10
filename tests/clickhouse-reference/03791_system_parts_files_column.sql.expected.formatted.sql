DROP TABLE IF EXISTS test_parts_files;

CREATE TABLE test_parts_files
(
    x UInt64
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO test_parts_files;

SELECT files > 0
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'test_parts_files'
    AND active;

SELECT toTypeName(files)
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'test_parts_files'
    AND active
LIMIT 1;

DROP TABLE test_parts_files;