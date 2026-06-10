-- This is a regression test for EINTR handling in MultiplexedConnections::getReplicaForReading()
SELECT *
FROM remote('127.{2,4}', view(    SELECT sleep(0.1)
    FROM numbers(20)
    SETTINGS max_block_size = '1'))
LIMIT 10
SETTINGS
    drain_timeout = '-1',
    query_profiler_real_time_period_ns = '1',
    use_hedged_requests = '0';