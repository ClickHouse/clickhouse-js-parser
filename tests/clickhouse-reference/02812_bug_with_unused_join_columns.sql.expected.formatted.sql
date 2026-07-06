SELECT concat(func.name, comb.name) AS x
FROM
    `system`.functions AS func
INNER JOIN `system`.aggregate_function_combinators AS comb
    USING (name)
WHERE is_aggregate
SETTINGS enable_analyzer = '1';