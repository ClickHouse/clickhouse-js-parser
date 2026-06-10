-- Tags: distributed
-- regression for endless loop with connections_with_failover_max_tries=0
SET connections_with_failover_max_tries = '0';

SELECT *
FROM remote('127.2', `system`.one);