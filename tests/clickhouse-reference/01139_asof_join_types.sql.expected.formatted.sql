SELECT *
FROM
    (
        SELECT
            0 AS k,
            toInt8(1) AS v
    ) AS t1
ASOF INNER JOIN (
        SELECT
            0 AS k,
            toInt8(0) AS v
    ) AS t2
    USING (k, v);

SELECT *
FROM
    (
        SELECT
            0 AS k,
            toInt16(1) AS v
    ) AS t1
ASOF INNER JOIN (
        SELECT
            0 AS k,
            toInt16(0) AS v
    ) AS t2
    USING (k, v);

SELECT *
FROM
    (
        SELECT
            0 AS k,
            toInt32(1) AS v
    ) AS t1
ASOF INNER JOIN (
        SELECT
            0 AS k,
            toInt32(0) AS v
    ) AS t2
    USING (k, v);

SELECT *
FROM
    (
        SELECT
            0 AS k,
            toInt64(1) AS v
    ) AS t1
ASOF INNER JOIN (
        SELECT
            0 AS k,
            toInt64(0) AS v
    ) AS t2
    USING (k, v);

SELECT *
FROM
    (
        SELECT
            0 AS k,
            toUInt8(1) AS v
    ) AS t1
ASOF INNER JOIN (
        SELECT
            0 AS k,
            toUInt8(0) AS v
    ) AS t2
    USING (k, v);

SELECT *
FROM
    (
        SELECT
            0 AS k,
            toUInt16(1) AS v
    ) AS t1
ASOF INNER JOIN (
        SELECT
            0 AS k,
            toUInt16(0) AS v
    ) AS t2
    USING (k, v);

SELECT *
FROM
    (
        SELECT
            0 AS k,
            toUInt32(1) AS v
    ) AS t1
ASOF INNER JOIN (
        SELECT
            0 AS k,
            toUInt32(0) AS v
    ) AS t2
    USING (k, v);

SELECT *
FROM
    (
        SELECT
            0 AS k,
            toUInt64(1) AS v
    ) AS t1
ASOF INNER JOIN (
        SELECT
            0 AS k,
            toUInt64(0) AS v
    ) AS t2
    USING (k, v);

SELECT *
FROM
    (
        SELECT
            0 AS k,
            toDecimal32(1, 0) AS v
    ) AS t1
ASOF INNER JOIN (
        SELECT
            0 AS k,
            toDecimal32(0, 0) AS v
    ) AS t2
    USING (k, v);

SELECT *
FROM
    (
        SELECT
            0 AS k,
            toDecimal64(1, 0) AS v
    ) AS t1
ASOF INNER JOIN (
        SELECT
            0 AS k,
            toDecimal64(0, 0) AS v
    ) AS t2
    USING (k, v);

SELECT *
FROM
    (
        SELECT
            0 AS k,
            toDecimal128(1, 0) AS v
    ) AS t1
ASOF INNER JOIN (
        SELECT
            0 AS k,
            toDecimal128(0, 0) AS v
    ) AS t2
    USING (k, v);

SELECT *
FROM
    (
        SELECT
            0 AS k,
            toDate(0) AS v
    ) AS t1
ASOF INNER JOIN (
        SELECT
            0 AS k,
            toDate(0) AS v
    ) AS t2
    USING (k, v);

SELECT *
FROM
    (
        SELECT
            0 AS k,
            toDateTime(0, 'UTC') AS v
    ) AS t1
ASOF INNER JOIN (
        SELECT
            0 AS k,
            toDateTime(0, 'UTC') AS v
    ) AS t2
    USING (k, v);

SELECT *
FROM
    (
        SELECT
            0 AS k,
            'x' AS v
    ) AS t1
ASOF INNER JOIN (
        SELECT
            0 AS k,
            'x' AS v
    ) AS t2
    USING (k, v); -- { serverError BAD_TYPE_OF_FIELD }