DROP TABLE IF EXISTS fh;

CREATE TABLE fh
(
    a_value UInt32,
    b_value Float64,
    c_value Float64,
    d_value Float64
)
ENGINE = Memory();

INSERT INTO fh (a_value, b_value, c_value, d_value);

SELECT corrMatrix(a_value)
FROM (
        SELECT a_value
        FROM fh
        LIMIT 0
    );

SELECT corrMatrix(a_value)
FROM (
        SELECT a_value
        FROM fh
        LIMIT 1
    );

SELECT corrMatrix(a_value, b_value, c_value, d_value)
FROM (
        SELECT
            a_value,
            b_value,
            c_value,
            d_value
        FROM fh
        LIMIT 0
    );

SELECT corrMatrix(a_value, b_value, c_value, d_value)
FROM (
        SELECT
            a_value,
            b_value,
            c_value,
            d_value
        FROM fh
        LIMIT 1
    );

SELECT arrayMap((x -> arrayMap((y -> round(y, 5)), x)), corrMatrix(a_value, b_value, c_value, d_value))
FROM fh;

SELECT
    round(abs(corr(x1, x2) - corrMatrix(x1, x2)[1][2]), 5),
    round(abs(corr(x1, x1) - corrMatrix(x1, x2)[1][1]), 5),
    round(abs(corr(x2, x2) - corrMatrix(x1, x2)[2][2]), 5)
FROM (
        SELECT
            randNormal(100, 1) AS x1,
            randNormal(100, 5) AS x2
        FROM numbers(100000)
    );

SELECT covarSampMatrix(a_value)
FROM (
        SELECT a_value
        FROM fh
        LIMIT 0
    );

SELECT covarSampMatrix(a_value)
FROM (
        SELECT a_value
        FROM fh
        LIMIT 1
    );

SELECT covarSampMatrix(a_value, b_value, c_value, d_value)
FROM (
        SELECT
            a_value,
            b_value,
            c_value,
            d_value
        FROM fh
        LIMIT 0
    );

SELECT covarSampMatrix(a_value, b_value, c_value, d_value)
FROM (
        SELECT
            a_value,
            b_value,
            c_value,
            d_value
        FROM fh
        LIMIT 1
    );

SELECT arrayMap((x -> arrayMap((y -> round(y, 5)), x)), covarSampMatrix(a_value, b_value, c_value, d_value))
FROM fh;

SELECT
    round(abs(covarSamp(x1, x2) - covarSampMatrix(x1, x2)[1][2]), 5),
    round(abs(covarSamp(x1, x1) - covarSampMatrix(x1, x2)[1][1]), 5),
    round(abs(covarSamp(x2, x2) - covarSampMatrix(x1, x2)[2][2]), 5)
FROM (
        SELECT
            randNormal(100, 1) AS x1,
            randNormal(100, 5) AS x2
        FROM numbers(100000)
    );

SELECT covarPopMatrix(a_value)
FROM (
        SELECT a_value
        FROM fh
        LIMIT 0
    );

SELECT covarPopMatrix(a_value)
FROM (
        SELECT a_value
        FROM fh
        LIMIT 1
    );

SELECT covarPopMatrix(a_value, b_value, c_value, d_value)
FROM (
        SELECT
            a_value,
            b_value,
            c_value,
            d_value
        FROM fh
        LIMIT 0
    );

SELECT covarPopMatrix(a_value, b_value, c_value, d_value)
FROM (
        SELECT
            a_value,
            b_value,
            c_value,
            d_value
        FROM fh
        LIMIT 1
    );

SELECT arrayMap((x -> arrayMap((y -> round(y, 5)), x)), covarPopMatrix(a_value, b_value, c_value, d_value))
FROM fh;

SELECT
    round(abs(covarPop(x1, x2) - covarPopMatrix(x1, x2)[1][2]), 5),
    round(abs(covarPop(x1, x1) - covarPopMatrix(x1, x2)[1][1]), 5),
    round(abs(covarPop(x2, x2) - covarPopMatrix(x1, x2)[2][2]), 5)
FROM (
        SELECT
            randNormal(100, 1) AS x1,
            randNormal(100, 5) AS x2
        FROM numbers(100000)
    );