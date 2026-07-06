SELECT
    number,
    intDiv(1, number - 2)
FROM
    numbers(4)
ARRAY JOIN range(number) AS x
WHERE number != 2
SETTINGS
    enable_lazy_columns_replication = '1',
    query_plan_filter_push_down = '0';