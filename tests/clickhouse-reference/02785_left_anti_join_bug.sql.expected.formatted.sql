SET allow_suspicious_low_cardinality_types = '1';

DROP TABLE IF EXISTS test_table;

DROP TABLE IF EXISTS test_table__fuzz_3;

CREATE TABLE test_table
(
    id Float32,
    value Float32
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO test_table;

CREATE TABLE test_table__fuzz_3
(
    id LowCardinality(Nullable(Float32)),
    value Float32
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS allow_nullable_key = '1';

INSERT INTO test_table__fuzz_3 SELECT *
FROM generateRandom()
LIMIT 10;

SELECT *
FROM
    (
        SELECT
            CAST('104857.5' AS Float32),
            corr(NULL, id, id) AS corr_value
        FROM test_table__fuzz_3
        GROUP BY value
    ) AS subquery
ANTI LEFT JOIN test_table
    ON subquery.corr_value = test_table.id
FORMAT Null;