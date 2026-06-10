-- Test from https://github.com/ClickHouse/ClickHouse/issues/29729
CREATE TABLE data_02053
(
    id Int64,
    A Nullable(Int64),
    X Int64 MATERIALIZED coalesce(A, -1)
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO data_02053;

-- Due to insert_null_as_default A became Null and X became -1
INSERT INTO data_02053 SELECT
    1,
    42;

SELECT
    *,
    X
FROM data_02053
ORDER BY id ASC;