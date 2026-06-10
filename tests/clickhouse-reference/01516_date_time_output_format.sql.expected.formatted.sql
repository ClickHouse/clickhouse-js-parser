DROP TABLE IF EXISTS test_datetime;

CREATE TABLE test_datetime
(
    timestamp DateTime('Asia/Istanbul')
)
ENGINE = Log();

INSERT INTO test_datetime;

SET date_time_output_format = 'simple';

SELECT timestamp
FROM test_datetime;

SELECT formatDateTime(toDateTime('2020-10-15 00:00:00', 'Asia/Istanbul'), '%Y-%m-%d %R:%S') AS formatted_simple
FROM test_datetime;

SET date_time_output_format = 'iso';

SELECT formatDateTime(toDateTime('2020-10-15 00:00:00', 'Asia/Istanbul'), '%Y-%m-%dT%R:%SZ', 'UTC') AS formatted_iso
FROM test_datetime;

;

SET date_time_output_format = 'unix_timestamp';

SELECT toUnixTimestamp(timestamp)
FROM test_datetime;

DROP TABLE test_datetime;

CREATE TABLE test_datetime
(
    timestamp DateTime64(3, 'Asia/Istanbul')
)
ENGINE = Log();

INSERT INTO test_datetime;