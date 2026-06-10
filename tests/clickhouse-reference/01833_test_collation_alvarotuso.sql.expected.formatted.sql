-- Tags: no-fasttest
DROP TABLE IF EXISTS test_collation;

CREATE TABLE test_collation
(
    v String,
    v2 String
)
ENGINE = MergeTree()
ORDER BY v
SETTINGS index_granularity = '8192';

INSERT INTO test_collation;

INSERT INTO test_collation;

INSERT INTO test_collation;

SELECT *
FROM test_collation
ORDER BY v ASC COLLATE 'en';

DROP TABLE test_collation;