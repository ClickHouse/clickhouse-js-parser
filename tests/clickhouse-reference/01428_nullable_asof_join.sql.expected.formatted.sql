SET join_use_nulls = '1';

SELECT
    a.pk,
    b.pk,
    a.dt,
    b.dt,
    toTypeName(a.pk),
    toTypeName(b.pk),
    toTypeName(materialize(a.dt)),
    toTypeName(materialize(b.dt))
FROM
    (
        SELECT
            toUInt8(number) > 0 AS pk,
            toUInt8(number) AS dt
        FROM numbers(3)
    ) AS a
ASOF LEFT JOIN (
        SELECT
            1 AS pk,
            2 AS dt
    ) AS b
    USING (pk, dt)
ORDER BY a.dt ASC;

SELECT
    a.pk,
    b.pk,
    a.dt,
    b.dt,
    toTypeName(a.pk),
    toTypeName(b.pk),
    toTypeName(materialize(a.dt)),
    toTypeName(materialize(b.dt))
FROM
    (
        SELECT
            toUInt8(number) > 0 AS pk,
            toNullable(toUInt8(number)) AS dt
        FROM numbers(3)
    ) AS a
ASOF LEFT JOIN (
        SELECT
            1 AS pk,
            2 AS dt
    ) AS b
    USING (pk, dt)
ORDER BY a.dt ASC;

SELECT
    a.pk,
    b.pk,
    a.dt,
    b.dt,
    toTypeName(a.pk),
    toTypeName(b.pk),
    toTypeName(materialize(a.dt)),
    toTypeName(materialize(b.dt))
FROM
    (
        SELECT
            toUInt8(number) > 0 AS pk,
            toUInt8(number) AS dt
        FROM numbers(3)
    ) AS a
ASOF LEFT JOIN (
        SELECT
            1 AS pk,
            toNullable(0) AS dt
    ) AS b
    USING (pk, dt)
ORDER BY a.dt ASC
SETTINGS enable_analyzer = '0';

SELECT
    a.pk,
    b.pk,
    a.dt,
    b.dt,
    toTypeName(a.pk),
    toTypeName(b.pk),
    toTypeName(materialize(a.dt)),
    toTypeName(materialize(b.dt))
FROM
    (
        SELECT
            toUInt8(number) > 0 AS pk,
            toUInt8(number) AS dt
        FROM numbers(3)
    ) AS a
ASOF LEFT JOIN (
        SELECT
            1 AS pk,
            toNullable(0) AS dt
    ) AS b
    USING (pk, dt)
ORDER BY a.dt ASC
SETTINGS enable_analyzer = '1';

SELECT
    a.pk,
    b.pk,
    a.dt,
    b.dt,
    toTypeName(a.pk),
    toTypeName(b.pk),
    toTypeName(materialize(a.dt)),
    toTypeName(materialize(b.dt))
FROM
    (
        SELECT
            toUInt8(number) > 0 AS pk,
            toNullable(toUInt8(number)) AS dt
        FROM numbers(3)
    ) AS a
ASOF LEFT JOIN (
        SELECT
            1 AS pk,
            toNullable(0) AS dt
    ) AS b
    USING (pk, dt)
ORDER BY a.dt ASC;

SELECT
    a.pk,
    b.pk,
    a.dt,
    b.dt,
    toTypeName(a.pk),
    toTypeName(b.pk),
    toTypeName(materialize(a.dt)),
    toTypeName(materialize(b.dt))
FROM
    (
        SELECT
            toUInt8(number) > 0 AS pk,
            toUInt8(number) AS dt
        FROM numbers(3)
    ) AS a
ASOF LEFT JOIN (
        SELECT
            1 AS pk,
            2 AS dt
    ) AS b
    ON a.pk = b.pk
    AND a.dt >= b.dt
ORDER BY a.dt ASC;

SELECT
    a.pk,
    b.pk,
    a.dt,
    b.dt,
    toTypeName(a.pk),
    toTypeName(b.pk),
    toTypeName(materialize(a.dt)),
    toTypeName(materialize(b.dt))
FROM
    (
        SELECT
            toUInt8(number) > 0 AS pk,
            toNullable(toUInt8(number)) AS dt
        FROM numbers(3)
    ) AS a
ASOF LEFT JOIN (
        SELECT
            1 AS pk,
            2 AS dt
    ) AS b
    ON a.pk = b.pk
    AND a.dt >= b.dt
ORDER BY a.dt ASC;

SELECT
    a.pk,
    b.pk,
    a.dt,
    b.dt,
    toTypeName(a.pk),
    toTypeName(b.pk),
    toTypeName(materialize(a.dt)),
    toTypeName(materialize(b.dt))
FROM
    (
        SELECT
            toUInt8(number) > 0 AS pk,
            toUInt8(number) AS dt
        FROM numbers(3)
    ) AS a
ASOF LEFT JOIN (
        SELECT
            1 AS pk,
            toNullable(0) AS dt
    ) AS b
    ON a.pk = b.pk
    AND a.dt >= b.dt
ORDER BY a.dt ASC;

SELECT
    a.pk,
    b.pk,
    a.dt,
    b.dt,
    toTypeName(a.pk),
    toTypeName(b.pk),
    toTypeName(materialize(a.dt)),
    toTypeName(materialize(b.dt))
FROM
    (
        SELECT
            toUInt8(number) > 0 AS pk,
            toNullable(toUInt8(number)) AS dt
        FROM numbers(3)
    ) AS a
ASOF LEFT JOIN (
        SELECT
            1 AS pk,
            toNullable(0) AS dt
    ) AS b
    ON a.dt >= b.dt
    AND a.pk = b.pk
ORDER BY a.dt ASC;

SELECT
    a.pk,
    b.pk,
    a.dt,
    b.dt,
    toTypeName(a.pk),
    toTypeName(b.pk),
    toTypeName(materialize(a.dt)),
    toTypeName(materialize(b.dt))
FROM
    (
        SELECT
            toUInt8(number) > 0 AS pk,
            toUInt8(number) AS dt
        FROM numbers(3)
    ) AS a
ASOF INNER JOIN (
        SELECT
            1 AS pk,
            2 AS dt
    ) AS b
    USING (pk, dt)
ORDER BY a.dt ASC;

SELECT
    a.pk,
    b.pk,
    a.dt,
    b.dt,
    toTypeName(a.pk),
    toTypeName(b.pk),
    toTypeName(materialize(a.dt)),
    toTypeName(materialize(b.dt))
FROM
    (
        SELECT
            toUInt8(number) > 0 AS pk,
            toNullable(toUInt8(number)) AS dt
        FROM numbers(3)
    ) AS a
ASOF INNER JOIN (
        SELECT
            1 AS pk,
            2 AS dt
    ) AS b
    USING (pk, dt)
ORDER BY a.dt ASC
SETTINGS enable_analyzer = '0';

SELECT
    a.pk,
    b.pk,
    a.dt,
    b.dt,
    toTypeName(a.pk),
    toTypeName(b.pk),
    toTypeName(materialize(a.dt)),
    toTypeName(materialize(b.dt))
FROM
    (
        SELECT
            toUInt8(number) > 0 AS pk,
            toNullable(toUInt8(number)) AS dt
        FROM numbers(3)
    ) AS a
ASOF INNER JOIN (
        SELECT
            1 AS pk,
            2 AS dt
    ) AS b
    USING (pk, dt)
ORDER BY a.dt ASC
SETTINGS enable_analyzer = '1';

SELECT
    a.pk,
    b.pk,
    a.dt,
    b.dt,
    toTypeName(a.pk),
    toTypeName(b.pk),
    toTypeName(materialize(a.dt)),
    toTypeName(materialize(b.dt))
FROM
    (
        SELECT
            toUInt8(number) > 0 AS pk,
            toUInt8(number) AS dt
        FROM numbers(3)
    ) AS a
ASOF INNER JOIN (
        SELECT
            1 AS pk,
            toNullable(0) AS dt
    ) AS b
    USING (pk, dt)
ORDER BY a.dt ASC
SETTINGS enable_analyzer = '0';

SELECT
    a.pk,
    b.pk,
    a.dt,
    b.dt,
    toTypeName(a.pk),
    toTypeName(b.pk),
    toTypeName(materialize(a.dt)),
    toTypeName(materialize(b.dt))
FROM
    (
        SELECT
            toUInt8(number) > 0 AS pk,
            toUInt8(number) AS dt
        FROM numbers(3)
    ) AS a
ASOF INNER JOIN (
        SELECT
            1 AS pk,
            toNullable(0) AS dt
    ) AS b
    USING (pk, dt)
ORDER BY a.dt ASC
SETTINGS enable_analyzer = '1';

SELECT
    a.pk,
    b.pk,
    a.dt,
    b.dt,
    toTypeName(a.pk),
    toTypeName(b.pk),
    toTypeName(materialize(a.dt)),
    toTypeName(materialize(b.dt))
FROM
    (
        SELECT
            toUInt8(number) > 0 AS pk,
            toNullable(toUInt8(number)) AS dt
        FROM numbers(3)
    ) AS a
ASOF INNER JOIN (
        SELECT
            1 AS pk,
            toNullable(0) AS dt
    ) AS b
    USING (pk, dt)
ORDER BY a.dt ASC;

SELECT
    a.pk,
    b.pk,
    a.dt,
    b.dt,
    toTypeName(a.pk),
    toTypeName(b.pk),
    toTypeName(materialize(a.dt)),
    toTypeName(materialize(b.dt))
FROM
    (
        SELECT
            toUInt8(number) > 0 AS pk,
            toUInt8(number) AS dt
        FROM numbers(3)
    ) AS a
ASOF INNER JOIN (
        SELECT
            1 AS pk,
            2 AS dt
    ) AS b
    ON a.pk = b.pk
    AND a.dt >= b.dt
ORDER BY a.dt ASC;

SELECT
    a.pk,
    b.pk,
    a.dt,
    b.dt,
    toTypeName(a.pk),
    toTypeName(b.pk),
    toTypeName(materialize(a.dt)),
    toTypeName(materialize(b.dt))
FROM
    (
        SELECT
            toUInt8(number) > 0 AS pk,
            toNullable(toUInt8(number)) AS dt
        FROM numbers(3)
    ) AS a
ASOF INNER JOIN (
        SELECT
            1 AS pk,
            2 AS dt
    ) AS b
    ON a.pk = b.pk
    AND a.dt >= b.dt
ORDER BY a.dt ASC;

SELECT
    a.pk,
    b.pk,
    a.dt,
    b.dt,
    toTypeName(a.pk),
    toTypeName(b.pk),
    toTypeName(materialize(a.dt)),
    toTypeName(materialize(b.dt))
FROM
    (
        SELECT
            toUInt8(number) > 0 AS pk,
            toUInt8(number) AS dt
        FROM numbers(3)
    ) AS a
ASOF INNER JOIN (
        SELECT
            1 AS pk,
            toNullable(0) AS dt
    ) AS b
    ON a.pk = b.pk
    AND a.dt >= b.dt
ORDER BY a.dt ASC;

SELECT
    a.pk,
    b.pk,
    a.dt,
    b.dt,
    toTypeName(a.pk),
    toTypeName(b.pk),
    toTypeName(materialize(a.dt)),
    toTypeName(materialize(b.dt))
FROM
    (
        SELECT
            toUInt8(number) > 0 AS pk,
            toNullable(toUInt8(number)) AS dt
        FROM numbers(3)
    ) AS a
ASOF INNER JOIN (
        SELECT
            1 AS pk,
            toNullable(0) AS dt
    ) AS b
    ON a.pk = b.pk
    AND a.dt >= b.dt
ORDER BY a.dt ASC;

SELECT
    a.pk,
    b.pk,
    a.dt,
    b.dt,
    toTypeName(a.pk),
    toTypeName(b.pk),
    toTypeName(materialize(a.dt)),
    toTypeName(materialize(b.dt))
FROM
    (
        SELECT
            toUInt8(number) > 0 AS pk,
            toNullable(toUInt8(number)) AS dt
        FROM numbers(3)
    ) AS a
ASOF INNER JOIN (
        SELECT
            1 AS pk,
            toNullable(0) AS dt
    ) AS b
    ON a.dt >= b.dt
    AND a.pk = b.pk
ORDER BY a.dt ASC;

SELECT *
FROM
    (
        SELECT
            NULL AS y,
            1 AS x,
            '2020-01-01 10:10:10'::DateTime64 AS t
    ) AS t1
ASOF LEFT JOIN (
        SELECT
            NULL AS y,
            1 AS x,
            '2020-01-01 10:10:10'::DateTime64 AS t
    ) AS t2
    ON t1.t <= t2.t
    AND t1.x = t2.x
FORMAT Null;