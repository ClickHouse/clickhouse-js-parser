DROP TABLE IF EXISTS test_00974;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE test_00974
(
    date Date,
    x Int32,
    ver UInt64
)
ENGINE = ReplacingMergeTree(date, x, 1);

INSERT INTO test_00974;

INSERT INTO test_00974;

SELECT COUNT()
FROM (
        SELECT *
        FROM test_00974 FINAL
    )
WHERE x = 1
SETTINGS enable_optimize_predicate_expression_to_final_subquery = '0';

SELECT COUNT()
FROM (
        SELECT *
        FROM test_00974 FINAL
    )
WHERE x = 1
SETTINGS
    enable_optimize_predicate_expression_to_final_subquery = '1',
    max_rows_to_read = '2';

DROP TABLE test_00974;