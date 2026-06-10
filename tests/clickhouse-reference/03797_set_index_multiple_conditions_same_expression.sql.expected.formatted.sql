-- Test for a bug where multiple conditions using the same indexed expression caused
-- "Not found column in block" error. The issue was that MergeTreeIndexConditionSet
-- created duplicate INPUT nodes with the same name, and ExpressionActions only
-- mapped the first one, leaving subsequent ones unmapped.
DROP TABLE IF EXISTS test_set_index_multiple_conditions;

CREATE TABLE test_set_index_multiple_conditions
(
    id Int64,
    labels Map(String, String),
    INDEX idx_labels mapKeys(labels) TYPE SET(0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO test_set_index_multiple_conditions;

INSERT INTO test_set_index_multiple_conditions;

INSERT INTO test_set_index_multiple_conditions;

-- This query previously failed with:
-- "Not found column mapKeys(labels) in block"
SELECT id
FROM test_set_index_multiple_conditions
WHERE has(mapKeys(labels), 'a')
    AND has(mapKeys(labels), 'b')
ORDER BY id ASC;

-- Test with OR
SELECT id
FROM test_set_index_multiple_conditions
WHERE has(mapKeys(labels), 'a')
    OR has(mapKeys(labels), 'c')
ORDER BY id ASC;

-- Test with three conditions
SELECT id
FROM test_set_index_multiple_conditions
WHERE has(mapKeys(labels), 'a')
    AND has(mapKeys(labels), 'b')
    AND has(mapKeys(labels), 'c')
ORDER BY id ASC;

-- Test with mixed AND/OR
SELECT id
FROM test_set_index_multiple_conditions
WHERE has(mapKeys(labels), 'a')
    AND has(mapKeys(labels), 'b')
    OR has(mapKeys(labels), 'c')
ORDER BY id ASC;

DROP TABLE test_set_index_multiple_conditions;