SET enable_analyzer = '1', prefer_localhost_replica = '1';

SET serialize_query_plan = '0';

EXPLAIN distributed = '1'
SELECT *
FROM remote('127.0.0.{1,2}', numbers_mt(1000000.))
GROUP BY number
ORDER BY number DESC
LIMIT 10;

SET serialize_query_plan = '1';