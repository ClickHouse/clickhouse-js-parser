DROP TABLE IF EXISTS buffer_00126;

DROP TABLE IF EXISTS null_sink_00126;

CREATE TABLE null_sink_00126
(
    a UInt8,
    b String,
    c Array(UInt32)
)
ENGINE = Null();

CREATE TABLE buffer_00126
(
    a UInt8,
    b String,
    c Array(UInt32)
)
ENGINE = Buffer(currentDatabase(), null_sink_00126, 1, 1000, 1000, 1000, 1000, 1000000, 1000000);

INSERT INTO buffer_00126;

SELECT
    a,
    b,
    c
FROM buffer_00126
ORDER BY
    a ASC,
    b ASC,
    c ASC;

SELECT
    b,
    c,
    a
FROM buffer_00126
ORDER BY
    a ASC,
    b ASC,
    c ASC;

SELECT
    c,
    a,
    b
FROM buffer_00126
ORDER BY
    a ASC,
    b ASC,
    c ASC;

SELECT
    a,
    c,
    b
FROM buffer_00126
ORDER BY
    a ASC,
    b ASC,
    c ASC;

SELECT
    b,
    a,
    c
FROM buffer_00126
ORDER BY
    a ASC,
    b ASC,
    c ASC;

SELECT
    c,
    b,
    a
FROM buffer_00126
ORDER BY
    a ASC,
    b ASC,
    c ASC;

SELECT
    a,
    b
FROM buffer_00126
ORDER BY
    a ASC,
    b ASC,
    c ASC;

SELECT
    b,
    c
FROM buffer_00126
ORDER BY
    a ASC,
    b ASC,
    c ASC;

SELECT
    c,
    a
FROM buffer_00126
ORDER BY
    a ASC,
    b ASC,
    c ASC;

SELECT
    a,
    c
FROM buffer_00126
ORDER BY
    a ASC,
    b ASC,
    c ASC;

SELECT
    b,
    a
FROM buffer_00126
ORDER BY
    a ASC,
    b ASC,
    c ASC;

SELECT
    c,
    b
FROM buffer_00126
ORDER BY
    a ASC,
    b ASC,
    c ASC;

SELECT a
FROM buffer_00126
ORDER BY
    a ASC,
    b ASC,
    c ASC;

SELECT b
FROM buffer_00126
ORDER BY
    a ASC,
    b ASC,
    c ASC;

SELECT c
FROM buffer_00126
ORDER BY
    a ASC,
    b ASC,
    c ASC;

INSERT INTO buffer_00126 (c, b, a);

INSERT INTO buffer_00126 (a, c);

DROP TABLE buffer_00126;

DROP TABLE null_sink_00126;