DROP TABLE IF EXISTS test_00615;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE test_00615
(
    dt Date,
    id Int32,
    key String,
    data Nullable(Int8)
)
ENGINE = MergeTree(dt, (id, key, dt), 8192);

INSERT INTO test_00615 (dt, id, key, data);

ALTER TABLE test_00615 DROP COLUMN data;

ALTER TABLE test_00615 ADD COLUMN data Nullable(Float64);

SELECT *
FROM test_00615
ORDER BY data ASC NULLS FIRST;

OPTIMIZE TABLE test_00615;

DROP TABLE test_00615;