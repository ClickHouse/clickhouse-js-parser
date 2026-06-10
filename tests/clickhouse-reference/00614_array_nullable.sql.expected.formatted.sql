DROP TABLE IF EXISTS test;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE test
(
    date Date,
    keys Array(Nullable(UInt8))
)
ENGINE = MergeTree(date, date, 1);

INSERT INTO test;

SELECT *
FROM test
LIMIT 1;

SELECT avgArray(keys)
FROM test;

DROP TABLE test;