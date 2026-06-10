-- Test for issue #70017: if function type mismatch between UInt64 and Int32
-- The issue was: Unexpected return type from if. Expected Int64. Got Int128.
-- This happened when the canUnsignedBeSigned flag on UInt64 type was lost during
-- query plan transformations in distributed queries.
DROP TABLE IF EXISTS test_if_type_mismatch;

CREATE TABLE test_if_type_mismatch
(
    c_f7nvvq Int32,
    c_ooi4e9x212 Float64,
    c_h16pd String,
    c_j3 String,
    c_u37 Float64,
    c_d9n_3 Int32
)
ENGINE = MergeTree()
ORDER BY c_d9n_3;

INSERT INTO test_if_type_mismatch;

-- Test case 1: Simple if with UInt64 literal (fits in Int64) and Int32 column
SELECT toTypeName(if(rand() % 2, floor(4373163444658715090), c_f7nvvq))
FROM test_if_type_mismatch
LIMIT 1;

-- Test case 2: Case expression (which uses if internally)
SELECT toTypeName(multiIf(c_ooi4e9x212 > 5, floor(4373163444658715090), c_f7nvvq))
FROM test_if_type_mismatch
LIMIT 1;

-- Test case 3: Query pattern from original issue #70017 using remote() to simulate distributed query
-- This triggers prewhere optimization which materializes the constant and loses the type flag
SELECT subq_0.c_q9e4c4y15 AS c_n_2010
FROM (
        SELECT
            ref_0.c_ooi4e9x212 AS c_or3kcz,
            floor(ref_0.c_f7nvvq) AS c_pfnd1iaw,
            floor(4373163444658715090) AS c_j59,
            ref_0.c_u37 AS c_f_2008,
            ref_0.c_h16pd AS c_y2_2009,
            ref_0.c_j3 AS c_q9e4c4y15
        FROM remote('127.0.0.1', currentDatabase(), test_if_type_mismatch) AS ref_0
        WHERE CAST(ref_0.c_u37 > ref_0.c_d9n_3 AS Nullable(Bool))
    ) AS subq_0
WHERE CAST(negate(multiIf(CAST(subq_0.c_j59 = subq_0.c_pfnd1iaw AS Nullable(Bool)), 0, subq_0.c_pfnd1iaw)) = multiIf(CAST(round(subq_0.c_or3kcz) < subq_0.c_j59 AS Nullable(Bool)), subq_0.c_j59, subq_0.c_pfnd1iaw) AS Nullable(Bool));

-- Test case 4: Verify the actual value computation works correctly
SELECT
    if(1, floor(4373163444658715090), toInt32(0)) AS when_true,
    if(0, floor(4373163444658715090), toInt32(42)) AS when_false;

DROP TABLE test_if_type_mismatch;