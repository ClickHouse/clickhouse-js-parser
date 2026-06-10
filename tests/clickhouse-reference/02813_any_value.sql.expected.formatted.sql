SET max_block_size = '10', max_threads = '1';

SELECT any_value(number)
FROM numbers(10);