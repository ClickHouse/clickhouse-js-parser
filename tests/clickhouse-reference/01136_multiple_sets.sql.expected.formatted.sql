DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    project LowCardinality(String)
)
ENGINE = MergeTree()
ORDER BY project;

INSERT INTO test;

SELECT sum(project IN ('val1', 'val2'))
FROM test;

SET force_primary_key = '1';

SELECT sum(project IN ('val1', 'val2'))
FROM test
WHERE project IN ('val1', 'val2');

SELECT count()
FROM test
WHERE project IN ('val1', 'val2');

SELECT project IN ('val1', 'val2')
FROM test
WHERE project IN ('val1', 'val2');

DROP TABLE test;