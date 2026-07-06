-- https://github.com/ClickHouse/ClickHouse/issues/65548
DROP TABLE IF EXISTS test_projection_deduplicate;

CREATE TABLE test_projection_deduplicate
(
    id Int32,
    string String,
    PROJECTION test_projection (SELECT id GROUP BY id)
)
ENGINE = MergeTree()
PRIMARY KEY id;

INSERT INTO test_projection_deduplicate;

OPTIMIZE TABLE test_projection_deduplicate DEDUPLICATE; -- { serverError SUPPORT_IS_DISABLED }

SELECT *
FROM test_projection_deduplicate;

ALTER TABLE test_projection_deduplicate DROP PROJECTION test_projection;

DROP TABLE test_projection_deduplicate;