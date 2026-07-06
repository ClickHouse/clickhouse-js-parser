DROP TABLE IF EXISTS test_startsWith;

CREATE TABLE test_startsWith
(
    a String
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY tuple();

INSERT INTO test_startsWith (a);

SELECT count()
FROM test_startsWith
WHERE startsWith(a, 'a')
SETTINGS force_primary_key = '1';

SELECT count()
FROM test_startsWith
WHERE startsWith(a, 'abc')
SETTINGS force_primary_key = '1';

DROP TABLE test_startsWith;