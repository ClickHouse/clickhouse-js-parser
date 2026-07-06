SET enable_analyzer = '1';

SET group_by_use_nulls = '1';

SET optimize_group_by_function_keys = '1';

SELECT ignore(toLowCardinality(number))
FROM numbers(10)
GROUP BY GROUPING SETS ((ignore(toLowCardinality(number)), toLowCardinality(number)));