SET optimize_normalize_count_variants = '1';

EXPLAIN SYNTAX
SELECT
    count(),
    count(1),
    count(-1),
    sum(1),
    count(NULL);

SET aggregate_functions_null_for_empty = '1';

EXPLAIN SYNTAX
SELECT sum(1)
FROM numbers(10)
WHERE 0;