SET enable_time_time64_type = '1';

CREATE TABLE IF NOT EXISTS t0
(
    c0 Time64
)
ENGINE = Memory();

INSERT INTO t0 (c0) FORMAT VALUES; -- { error CANNOT_PARSE_DATETIME }

DROP TABLE t0;