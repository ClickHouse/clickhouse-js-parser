-- Tags: no-tsan
SELECT number
FROM remote('127.0.0.{3|2}', numbers(2))
WHERE number GLOBAL IN (
        SELECT number
        FROM numbers(1)
    )
SETTINGS
    async_socket_for_remote = '1',
    use_hedged_requests = '1',
    sleep_in_send_data_ms = '10',
    receive_data_timeout_ms = '1';