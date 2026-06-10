-- { echo }
SELECT 1 + number + multiIf(number = 1, cityHash64(number), number)
FROM numbers(1)
SETTINGS
    compile_expressions = '1',
    min_count_to_compile_expression = '0';