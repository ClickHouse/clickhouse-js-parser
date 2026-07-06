SELECT zero
FROM `system`.zeros
LIMIT 10
SETTINGS max_block_size = '3';

SELECT zero
FROM `system`.zeros_mt
LIMIT 10
SETTINGS
    max_block_size = '3',
    max_threads = '2';

SELECT zero
FROM zeros(10)
SETTINGS max_block_size = '3';

SELECT zero
FROM zeros_mt(10)
SETTINGS
    max_block_size = '3',
    max_threads = '3';

SELECT
    sum(zero),
    count()
FROM (
        SELECT *
        FROM `system`.zeros
        LIMIT 10000000
    );

SELECT
    sum(zero),
    count()
FROM (
        SELECT *
        FROM `system`.zeros_mt
        LIMIT 10000000
    );

SELECT
    sum(zero),
    count()
FROM zeros(10000000);

SELECT
    sum(zero),
    count()
FROM zeros_mt(10000000);