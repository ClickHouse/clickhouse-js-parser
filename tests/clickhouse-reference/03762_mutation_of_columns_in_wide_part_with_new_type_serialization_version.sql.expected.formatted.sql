DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    s String
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_bytes_for_wide_part = '1', string_serialization_version = 'single_stream';

INSERT INTO test SELECT 'abc' || toString(number)
FROM numbers(100);

ALTER TABLE test MODIFY SETTING string_serialization_version = 'with_size_stream';

ALTER TABLE test ADD COLUMN s1 String DEFAULT 'def' SETTINGS alter_sync = '2';

ALTER TABLE test MATERIALIZE COLUMN s1 SETTINGS mutations_sync = '1';

DETACH TABLE test;

ATTACH TABLE test;

SELECT
    max(s),
    max(s1)
FROM test;

DROP TABLE test;