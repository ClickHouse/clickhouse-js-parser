SELECT toUUID('417ddc5de5564d2795dda34d84e46a50');

SELECT toUUID('417ddc5d-e556-4d27-95dd-a34d84e46a50');

DROP TABLE IF EXISTS t_uuid;

CREATE TABLE t_uuid
(
    x UInt8,
    y UUID,
    z String
)
ENGINE = TinyLog();

INSERT INTO t_uuid;

INSERT INTO t_uuid;

SELECT *
FROM t_uuid
ORDER BY x ASC;