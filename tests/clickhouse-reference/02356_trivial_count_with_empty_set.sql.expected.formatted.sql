DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    a Int64
)
ENGINE = MergeTree()
ORDER BY tuple();

SET optimize_trivial_count_query = '1', empty_result_for_aggregation_by_empty_set = '1';

SELECT count()
FROM test;

DROP TABLE test;