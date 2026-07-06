-- Tags: distributed
SET prefer_localhost_replica = '1';

-- { echo }
EXPLAIN description = '0'
SELECT *
FROM remote('127.{1,2}', view(    SELECT *
    FROM numbers(1000000.)))
ORDER BY number ASC
LIMIT 10
SETTINGS distributed_push_down_limit = '0';

EXPLAIN description = '0'
SELECT *
FROM remote('127.{1,2}', view(    SELECT *
    FROM numbers(1000000.)))
ORDER BY number ASC
LIMIT 10
SETTINGS distributed_push_down_limit = '1';