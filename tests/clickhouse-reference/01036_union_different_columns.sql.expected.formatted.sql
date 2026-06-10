SELECT
    1 AS c1,
    2 AS c2,
    3 AS c3
UNION ALL
SELECT
    1 AS c1,
    2 AS c2,
    3 AS c3
UNION ALL
SELECT
    1 AS c1,
    2 AS c2; -- { serverError UNION_ALL_RESULT_STRUCTURES_MISMATCH }