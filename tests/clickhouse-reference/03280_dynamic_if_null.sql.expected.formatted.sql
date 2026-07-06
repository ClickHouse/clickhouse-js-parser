SET enable_dynamic_type = '1';

SELECT ifNull(number % 2 ? NULL : number::Dynamic, 42)
FROM numbers(5);