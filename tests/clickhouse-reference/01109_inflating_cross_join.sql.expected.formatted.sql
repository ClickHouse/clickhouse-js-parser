SET max_memory_usage = '16000000';

SET max_joined_block_size_rows = '10000000';

SELECT count(*)
FROM
    numbers(10000) AS n1
CROSS JOIN numbers(1000) AS n2; -- { serverError MEMORY_LIMIT_EXCEEDED }

SET max_joined_block_size_rows = '1000';