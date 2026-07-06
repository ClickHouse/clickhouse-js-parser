SELECT sum(if(number % NULL = 2, 0, 1))
FROM numbers(1024)
SETTINGS optimize_rewrite_sum_if_to_count_if = '0';

SELECT sum(if(number % NULL = 2, 0, 1))
FROM numbers(1024)
SETTINGS
    optimize_rewrite_sum_if_to_count_if = '1',
    enable_analyzer = '0';

SELECT sum(if(number % NULL = 2, 0, 1))
FROM numbers(1024)
SETTINGS
    optimize_rewrite_sum_if_to_count_if = '1',
    enable_analyzer = '1';