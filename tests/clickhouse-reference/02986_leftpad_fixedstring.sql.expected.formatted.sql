-- https://github.com/ClickHouse/ClickHouse/issues/59604
SELECT
    leftPad(toFixedString('abc', 3), 0),
    leftPad('abc', CAST('0' AS Int32));

SELECT
    leftPad(toFixedString('abc343243424324', 15), 1) AS a,
    toTypeName(a);

SELECT
    rightPad(toFixedString('abc', 3), 0),
    rightPad('abc', CAST('0' AS Int32));

SELECT
    rightPad(toFixedString('abc343243424324', 15), 1) AS a,
    toTypeName(a);

SELECT
    hex(leftPad(toFixedString('abc34324' AS s, 8), number)) AS result,
    hex(leftPad(s, number)) = result,
    hex(leftPadUTF8(toFixedString(s, 8), number)) = result,
    hex(leftPadUTF8(s, number)) = result
FROM numbers(20);

SELECT
    hex(rightPad(toFixedString('abc34324' AS s, 8), number)) AS result,
    hex(rightPad(s, number)) = result,
    hex(rightPadUTF8(toFixedString(s, 8), number)) = result,
    hex(rightPadUTF8(s, number)) = result
FROM numbers(20);

-- I'm not confident the behaviour should be like this. I'm only testing memory problems
SELECT
    hex(leftPadUTF8(toFixedString('abc34324' AS s, 8), number, '🇪🇸')) AS result,
    hex(leftPadUTF8(s, number, '🇪🇸')) = result
FROM numbers(20);

SELECT
    hex(rightPadUTF8(toFixedString('abc34324' AS s, 8), number, '🇪🇸')) AS result,
    hex(rightPadUTF8(s, number, '🇪🇸')) = result
FROM numbers(20);

SELECT
    hex(leftPadUTF8(toFixedString('🇪🇸' AS s, 8), number, 'Ñ')) AS result,
    hex(leftPadUTF8(s, number, 'Ñ')) = result
FROM numbers(20);

SELECT
    hex(rightPadUTF8(toFixedString('🇪🇸' AS s, 8), number, 'Ñ')) AS result,
    hex(rightPadUTF8(s, number, 'Ñ')) = result
FROM numbers(20);