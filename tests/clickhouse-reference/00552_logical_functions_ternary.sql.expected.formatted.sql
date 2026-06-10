-- Tests codepath for ternary logic
SELECT
    -- x1, x2, x3, x4,
    xor(x1, x2, x3, x4) AS xor1,
    xor(xor(x1, x2), xor(x3, x4)) AS xor2,
    or(x1, x2, x3, x4) AS or1,
    or(x1
    OR x2, x3
    OR x4) AS or2,
    and(x1, x2, x3, x4) AS and1,
    and(x1
    AND x2, x3
    AND x4) AS and2
FROM (
        SELECT
            nullIf(toUInt8(number % 3), 2) AS x1,
            nullIf(toUInt8(number / 3 % 3), 2) AS x2,
            nullIf(toUInt8(number / 9 % 3), 2) AS x3,
            nullIf(toUInt8(number / 27 % 3), 2) AS x4
        FROM numbers(81)
    )
WHERE (xor1 != xor2
    OR (xor1 IS NULL) != (xor2 IS NULL))
    OR (or1 != or2
    OR (or1 IS NULL) != (or2 IS NULL)
    OR (and1 != and2
    OR (and1 IS NULL) != (and2 IS NULL)));

-- Test ternary logic over multiple batches of columns (currently batch spans over 10 columns)
SELECT
    -- x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11,
    xor(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11) AS xor1,
    xor(x1, xor(xor(xor(x2, x3), xor(x4, x5)), xor(xor(x6, x7), xor(x8, xor(x9, xor(x10, x11)))))) AS xor2,
    or(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11) AS or1,
    or(x1, or(or(or(x2, x3), or(x4, x5)), or(or(x6, x7), or(x8, or(x9, or(x10, x11)))))) AS or2,
    and(x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11) AS and1,
    and(x1, and((x2
    AND x3)
    AND (x4
    AND x5), (x6
    AND x7)
    AND (x8
    AND (x9
    AND (x10
    AND x11))))) AS and2
FROM (
        SELECT
            nullIf(toUInt8(number % 3), 2) AS x1,
            nullIf(toUInt8(number / 3 % 3), 2) AS x2,
            nullIf(toUInt8(number / 9 % 3), 2) AS x3,
            nullIf(toUInt8(number / 27 % 3), 2) AS x4,
            nullIf(toUInt8(number / 81 % 3), 2) AS x5,
            nullIf(toUInt8(number / 243 % 3), 2) AS x6,
            nullIf(toUInt8(number / 729 % 3), 2) AS x7,
            nullIf(toUInt8(number / 2187 % 3), 2) AS x8,
            nullIf(toUInt8(number / 6561 % 3), 2) AS x9,
            nullIf(toUInt8(number / 19683 % 3), 2) AS x10,
            nullIf(toUInt8(number / 59049 % 3), 2) AS x11
        FROM numbers(177147)
    )
WHERE (xor1 != xor2
    OR (xor1 IS NULL) != (xor2 IS NULL))
    OR (or1 != or2
    OR (or1 IS NULL) != (or2 IS NULL)
    OR (and1 != and2
    OR (and1 IS NULL) != (and2 IS NULL)));