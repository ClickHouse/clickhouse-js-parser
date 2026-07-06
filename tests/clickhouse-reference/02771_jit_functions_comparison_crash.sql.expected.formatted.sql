SET compile_expressions = '1';

SET min_count_to_compile_expression = '0';

DROP TABLE IF EXISTS test_table_1;

CREATE TABLE test_table_1
(
    pkey UInt32,
    c8 UInt32,
    c9 String,
    c10 Float32,
    c11 String
)
ENGINE = MergeTree()
ORDER BY pkey;

DROP TABLE IF EXISTS test_table_2;

CREATE TABLE test_table_2
(
    vkey UInt32,
    pkey UInt32,
    c15 UInt32
)
ENGINE = MergeTree()
ORDER BY vkey;

WITH test_cte AS (
    SELECT
        ref_10.c11 AS c_2_c2350_1,
        ref_9.c9 AS c_2_c2351_2
    FROM
        test_table_1 AS ref_9
    RIGHT JOIN test_table_1 AS ref_10
        ON ref_9.c11 = ref_10.c9
    INNER JOIN test_table_2 AS ref_11
        ON ref_10.c8 = ref_11.vkey
    WHERE ref_10.pkey + ref_11.pkey >= ref_11.vkey
        AND ref_10.pkey + ref_11.pkey <= multiIf(-30.87 >= ref_9.c10, ref_11.c15, ref_11.pkey)
)

SELECT ref_13.c_2_c2350_1 AS c_2_c2357_3
FROM test_cte AS ref_13
WHERE ref_13.c_2_c2351_2 IN (
        SELECT ref_14.c_2_c2351_2 AS c_5_c2352_0
        FROM test_cte AS ref_14
    );

DROP TABLE test_table_1;

DROP TABLE test_table_2;