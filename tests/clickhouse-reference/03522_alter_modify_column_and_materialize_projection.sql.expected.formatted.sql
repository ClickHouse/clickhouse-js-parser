DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    s String
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS min_bytes_for_wide_part = '0';

INSERT INTO test SELECT 'str'
FROM numbers(1);

ALTER TABLE test MODIFY COLUMN s Nullable(String);

ALTER TABLE test ADD PROJECTION p1 (SELECT s ORDER BY s);

ALTER TABLE test MATERIALIZE PROJECTION p1 SETTINGS mutations_sync = '1';

SELECT *
FROM test;

DROP TABLE test;