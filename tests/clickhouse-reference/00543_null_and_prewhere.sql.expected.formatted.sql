SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE test
(
    dt Date,
    id UInt32,
    val Nullable(UInt32)
)
ENGINE = MergeTree(dt, id, 8192);

INSERT INTO test (dt, id, val);

INSERT INTO test (dt, id, val);

INSERT INTO test (dt, id, val);

SELECT count()
FROM test
WHERE val = 0;

DROP TABLE IF EXISTS test;