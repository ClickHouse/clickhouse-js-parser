-- Tags: no-fasttest
-- no-fasttest: Timeouts are slow
CREATE TABLE dist AS `system`.one
ENGINE = Distributed(test_shard_localhost, `system`, one);

SELECT sleep(8)
FROM dist
SETTINGS
    function_sleep_max_microseconds_per_block = 8000000000.,
    prefer_localhost_replica = '0',
    receive_timeout = '7',
    async_socket_for_remote = '0',
    use_hedged_requests = '1'
FORMAT Null;

SELECT sleep(8)
FROM dist
SETTINGS
    function_sleep_max_microseconds_per_block = 8000000000.,
    prefer_localhost_replica = '0',
    receive_timeout = '7',
    async_socket_for_remote = '1',
    use_hedged_requests = '0'
FORMAT Null;

SELECT sleep(8)
FROM dist
SETTINGS
    function_sleep_max_microseconds_per_block = 8000000000.,
    prefer_localhost_replica = '0',
    receive_timeout = '7',
    async_socket_for_remote = '0',
    use_hedged_requests = '0'
FORMAT Null;