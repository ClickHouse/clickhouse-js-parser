DROP TABLE IF EXISTS test_table;

CREATE TABLE test_table
(
    string_value String
)
ENGINE = MergeTree()
ORDER BY string_value
SETTINGS index_granularity = '8192', index_granularity_bytes = '10Mi';

SYSTEM STOP MERGES test_table;

INSERT INTO test_table SELECT *
FROM (
        SELECT 'test_value_1'
        FROM numbers_mt(250000)
        UNION ALL
        SELECT 'test_value_2'
        FROM numbers_mt(2000000)
    )
ORDER BY rand() ASC;

SELECT DISTINCT
    'constant_1' AS constant_value,
    count(*) OVER (PARTITION BY constant_value, string_value) AS value_cnt
FROM (
        SELECT string_value
        FROM test_table
    )
ORDER BY `all` ASC;

SELECT DISTINCT
    'constant_1' AS constant_value,
    *
FROM (
        SELECT string_value
        FROM test_table
    )
ORDER BY
    constant_value ASC,
    string_value ASC
SETTINGS max_threads = '1';

SYSTEM START MERGES test_table;

DROP TABLE test_table;