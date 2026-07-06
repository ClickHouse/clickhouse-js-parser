SELECT groupArray(s)
FROM (
        SELECT sum(n) AS s
        FROM (
                SELECT toDecimal32(1, 2) AS n
            )
    );

SELECT groupArray(s)
FROM (
        SELECT sum(n) AS s
        FROM (
                SELECT toDecimal64(1, 5) AS n
            )
    );

SELECT groupArray(s)
FROM (
        SELECT sum(n) AS s
        FROM (
                SELECT toDecimal128(1, 10) AS n
            )
    );

SELECT groupArray(s)
FROM (
        SELECT sum(n) AS s
        FROM (
                SELECT toDecimal32(number, 2) AS n
                FROM numbers(1000)
            )
    );

SELECT groupArray(s)
FROM (
        SELECT sum(n) AS s
        FROM (
                SELECT toDecimal64(number, 5) AS n
                FROM numbers(1000)
            )
    );

SELECT groupArray(s)
FROM (
        SELECT sum(n) AS s
        FROM (
                SELECT toDecimal128(number, 10) AS n
                FROM numbers(1000)
            )
    );

DROP TABLE IF EXISTS sensor_value;

CREATE TABLE sensor_value
(
    received_at DateTime('Asia/Istanbul'),
    device_id UUID,
    sensor_id UUID,
    value Nullable(Decimal(18, 4)),
    low_warning Nullable(Decimal(18, 4)),
    low_critical Nullable(Decimal(18, 4)),
    high_warning Nullable(Decimal(18, 4)),
    high_critical Nullable(Decimal(18, 4))
)
ENGINE = MergeTree()
ORDER BY (device_id, sensor_id)
PARTITION BY toDate(received_at);

INSERT INTO sensor_value (received_at, device_id, sensor_id, value, low_warning, low_critical, high_warning, high_critical);

SELECT
    time,
    groupArray((sensor_id, volume)) AS groupArr
FROM (
        SELECT
            intDiv(toUInt32(received_at), 900) * 900 AS time,
            sensor_id,
            avg(value) AS volume
        FROM sensor_value
        WHERE received_at >= '2018-12-12 00:00:00'
            AND received_at <= '2018-12-30 00:00:00'
        GROUP BY
            time,
            sensor_id
        ORDER BY time ASC
    )
GROUP BY time
ORDER BY time ASC;

DROP TABLE sensor_value;

SELECT
    s.a,
    s.b,
    max(s.dt1) AS dt1,
    s.c,
    s.d,
    s.f,
    s.i,
    max(s.dt2) AS dt2
FROM (
        SELECT
            toUInt64(4360430) AS a,
            toUInt64(5681495) AS b,
            toDateTime('2018-11-01 10:44:58', 'Asia/Istanbul') AS dt1,
            'txt' AS c,
            toDecimal128('274.350000000000', 12) AS d,
            toDecimal128(268.97, 12) AS f,
            toDecimal128(0., 12) AS i,
            toDateTime('2018-11-02 00:00:00', 'Asia/Istanbul') AS dt2
        UNION ALL
        SELECT
            toUInt64(4341757) AS a,
            toUInt64(5657967) AS b,
            toDateTime('2018-11-01 16:47:46', 'Asia/Istanbul') AS dt1,
            'txt' AS c,
            toDecimal128('321.380000000000', 12) AS d,
            toDecimal128(315.08, 12) AS f,
            toDecimal128(0., 12) AS i,
            toDateTime('2018-11-02 00:00:00', 'Asia/Istanbul') AS dt2
        UNION ALL
        SELECT
            toUInt64(4360430) AS a,
            toUInt64(5681495) AS b,
            toDateTime('2018-11-02 09:00:07', 'Asia/Istanbul') AS dt1,
            'txt' AS c,
            toDecimal128('274.350000000000', 12) AS d,
            toDecimal128(268.97, 12) AS f,
            toDecimal128(0., 12) AS i,
            toDateTime('2018-11-02 00:00:00', 'Asia/Istanbul') AS dt2
    ) AS s
GROUP BY
    s.a,
    s.b,
    s.c,
    s.d,
    s.f,
    s.i
ORDER BY
    s.a ASC,
    s.b ASC,
    s.c ASC,
    s.d ASC,
    s.f ASC,
    s.i ASC;