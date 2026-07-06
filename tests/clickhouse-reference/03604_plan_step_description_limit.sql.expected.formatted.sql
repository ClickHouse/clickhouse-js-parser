SET enable_analyzer = '1';

EXPLAIN description = '1', optimize = '0'
SELECT sum(number + 1)
FROM numbers(10)
SETTINGS query_plan_max_step_description_length = '3';

EXPLAIN description = '1', optimize = '1'
SELECT sum(number + 1)
FROM numbers(10)
SETTINGS query_plan_max_step_description_length = '3';