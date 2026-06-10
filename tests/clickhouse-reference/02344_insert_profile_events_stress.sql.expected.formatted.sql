-- Tags: no-parallel, long, no-debug, no-tsan, no-msan, no-asan
SET max_rows_to_read = '0';

CREATE TABLE data_02344
(
    key Int
)
ENGINE = Null();

-- 3e9 rows is enough to fill the socket buffer and cause INSERT hung.
INSERT INTO FUNCTION remote('127.1', currentDatabase(), data_02344) SELECT number
FROM numbers(3000000000.)
SETTINGS prefer_localhost_replica = '0';