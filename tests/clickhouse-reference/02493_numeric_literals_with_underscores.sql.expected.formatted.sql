SELECT 1234; -- Positive integer (+ implied)

SELECT 1234;

SELECT 1234;

SELECT 1234; -- Positive integer (+ explicit)

SELECT 1234;

SELECT 1234;

SELECT -1234; -- Negative integer

SELECT -1234;

SELECT -1234;

SELECT 12.34; -- Positive floating point with . notation

SELECT 12.34;

SELECT 12.34;

SELECT 12.34;

SELECT -12.34; -- Negative floating point with . notation

SELECT -12.34;

SELECT -12.34;

SELECT -12.34;

SELECT 3.4e22; -- Positive floating point with positive scientific notation (+ implied)

SELECT 3.4e22;

SELECT 3.4e22;

SELECT 3.4e22;

SELECT 3.4e22; -- Positive floating point with positive scientific notation (+ explicit)

SELECT 3.4e22;

SELECT 3.4e22;

SELECT 3.4e22;

SELECT 3.4e-20; -- Positive floating point with negative scientific notation

SELECT 3.4e-20;

SELECT 3.4e-20;

SELECT 3.4e-20;

SELECT -3.4e22; -- Negative floating point with positive scientific notation (+ implied)

SELECT -3.4e22;

SELECT -3.4e22;

SELECT -3.4e22;

SELECT -3.4e22; -- Negative floating point with positive scientific notation (+ explicit)

SELECT -3.4e22;

SELECT -3.4e22;

SELECT -3.4e22;

SELECT -3.4e-20; -- Negative floating point with negative scientific notation

SELECT -3.4e-20;

SELECT -3.4e-20;

SELECT -3.4e-20;

SELECT 1.34e21; -- Positive floating point (with .) with positive scientific notation (+ implied)

SELECT 1.34e21;

SELECT 1.34e21;

SELECT 1.34e21;

SELECT 1.34e21; -- Positive floating point (with .) with positive scientific notation (+ explicit)

SELECT 1.34e21;

SELECT 1.34e21;

SELECT 1.34e21;

SELECT 1.34e-21; -- Positive floating point (with .) with negative scientific notation

SELECT 1.34e-21;

SELECT 1.34e-21;

SELECT 1.34e-21;

SELECT -1.34e21; -- Negative floating point (with .) with positive scientific notation (+ implied)

SELECT -1.34e21;

SELECT -1.34e21;

SELECT -1.34e21;

SELECT -1.34e21; -- Negative floating point (with .) with positive scientific notation (+ explicit)

SELECT -1.34e21;

SELECT -1.34e21;

SELECT -1.34e21;

SELECT -1.34e-21; -- Negative floating point (with .) with negative scientific notation

SELECT -1.34e-21;

SELECT -1.34e-21;

SELECT -1.34e-21;

SELECT -340000000000000000000.; -- Negative floating point (with .) with positive scientific notation (+ implied)

SELECT -340000000000000000000.;

SELECT -340000000000000000000.;

SELECT -340000000000000000000.;

SELECT -340000000000000000000.; -- Negative floating point (with .) with positive scientific notation (+ explicit)

SELECT -340000000000000000000.;

SELECT -340000000000000000000.;

SELECT -340000000000000000000.;

SELECT -3.4e-22; -- Negative floating point (with .) with negative scientific notation

SELECT -3.4e-22;

SELECT -3.4e-22;

SELECT -3.4e-22;

SELECT nan; -- Specials

SELECT inf;

SELECT inf;

SELECT -inf;

SELECT 15; -- Binary

SELECT 15;

SELECT 15;

SELECT -15;

SELECT -15;

SELECT -15;

SELECT 4660; -- Hex

SELECT 4660;

SELECT 4660;

SELECT -4660;

SELECT -4660;

SELECT -4660;

SELECT 238;

SELECT 238;

SELECT 1.1376953125; -- Hex fractions

SELECT 1.1376953125;

SELECT -1.1376953125;

SELECT -1.1376953125;

SELECT 0.9296875;

SELECT 0.9296875;

SELECT 2.275390625; -- Hex scientific notation

SELECT 2.275390625;

SELECT 2.275390625;

SELECT 2.275390625;

SELECT 2.275390625;

SELECT 2.275390625;

SELECT 0.56884765625;

SELECT 0.56884765625;

SELECT 0.56884765625;

SELECT -2.275390625;

SELECT -2.275390625;

SELECT -2.275390625;

SELECT -2.275390625;

SELECT -2.275390625;

SELECT -2.275390625;

SELECT -0.56884765625;

SELECT -0.56884765625;

SELECT -0.56884765625;

-- Things that are not a number
SELECT _1000; -- { serverError UNKNOWN_IDENTIFIER }

SELECT _1000
FROM (
        SELECT 1 AS _1000
    )
FORMAT Null;

SELECT -_1; -- { serverError UNKNOWN_IDENTIFIER }

SELECT -_1
FROM (
        SELECT -1 AS _1
    )
FORMAT Null;

SELECT _1; -- { serverError UNKNOWN_IDENTIFIER }

SELECT `1__0`; -- { serverError UNKNOWN_IDENTIFIER }

SELECT `1_`; -- { serverError UNKNOWN_IDENTIFIER }

SELECT `10_`; -- { serverError UNKNOWN_IDENTIFIER }

SELECT `1_e5`; -- { serverError UNKNOWN_IDENTIFIER }

SELECT `1e_5`; -- { serverError UNKNOWN_IDENTIFIER }

SELECT `1e5_`; -- { serverError UNKNOWN_IDENTIFIER }

SELECT `1e_`; -- { serverError UNKNOWN_IDENTIFIER }

SELECT `1e_1`; -- { serverError UNKNOWN_IDENTIFIER }

SELECT `0_x2`; -- { serverError UNKNOWN_IDENTIFIER }

SELECT `0x2_p2`; -- { serverError UNKNOWN_IDENTIFIER }

SELECT `0x2p_2`; -- { serverError UNKNOWN_IDENTIFIER }

SELECT `0x2p2_`; -- { serverError UNKNOWN_IDENTIFIER }

SELECT `0b`; -- { serverError UNKNOWN_IDENTIFIER }

SELECT `0x`; -- { serverError UNKNOWN_IDENTIFIER }

SELECT `0x_`; -- { serverError UNKNOWN_IDENTIFIER }

SELECT `0x_1`; -- { serverError UNKNOWN_IDENTIFIER }