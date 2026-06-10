SET enable_time_time64_type = '1';

CREATE TABLE dt
(
    time Time,
    event_id UInt8
)
ENGINE = TinyLog();

INSERT INTO dt;

SELECT max(time)
FROM dt;

SELECT min(time)
FROM dt;

SELECT avg(time)
FROM dt;