SELECT
    leftPad('abc', 0),
    leftPad('abc', CAST('0' AS Int32));

SELECT
    leftPad('abc', 1),
    leftPad('abc', CAST('1' AS Int32));

SELECT
    leftPad('abc', 2),
    leftPad('abc', CAST('2' AS Int32));

SELECT
    leftPad('abc', 3),
    leftPad('abc', CAST('3' AS Int32));

SELECT
    leftPad('abc', 4),
    leftPad('abc', CAST('4' AS Int32));

SELECT
    leftPad('abc', 5),
    leftPad('abc', CAST('5' AS Int32));

SELECT
    leftPad('abc', 10),
    leftPad('abc', CAST('10' AS Int32));

SELECT
    leftPad('abc', 2, '*'),
    leftPad('abc', CAST('2' AS Int32), '*');

SELECT
    leftPad('abc', 4, '*'),
    leftPad('abc', CAST('4' AS Int32), '*');

SELECT
    leftPad('abc', 5, '*'),
    leftPad('abc', CAST('5' AS Int32), '*');

SELECT
    leftPad('abc', 10, '*'),
    leftPad('abc', CAST('10' AS Int32), '*');

SELECT
    leftPad('abc', 2, '*.'),
    leftPad('abc', CAST('2' AS Int32), '*.');

SELECT
    leftPad('abc', 4, '*.'),
    leftPad('abc', CAST('4' AS Int32), '*.');

SELECT
    leftPad('abc', 5, '*.'),
    leftPad('abc', CAST('5' AS Int32), '*.');

SELECT
    leftPad('abc', 10, '*.'),
    leftPad('abc', CAST('10' AS Int32), '*.');

SELECT
    leftPad('абвг', 2),
    leftPad('абвг', CAST('2' AS Int32));

SELECT
    leftPadUTF8('абвг', 2),
    leftPadUTF8('абвг', CAST('2' AS Int32));

SELECT
    leftPad('абвг', 4),
    leftPad('абвг', CAST('4' AS Int32));

SELECT
    leftPadUTF8('абвг', 4),
    leftPadUTF8('абвг', CAST('4' AS Int32));

SELECT
    leftPad('абвг', 12, 'ЧАС'),
    leftPad('абвг', CAST('12' AS Int32), 'ЧАС');

SELECT
    leftPadUTF8('абвг', 12, 'ЧАС'),
    leftPadUTF8('абвг', CAST('12' AS Int32), 'ЧАС');

SELECT
    rightPad('abc', 0),
    rightPad('abc', CAST('0' AS Int32));

SELECT
    rightPad('abc', 1),
    rightPad('abc', CAST('1' AS Int32));

SELECT
    rightPad('abc', 2),
    rightPad('abc', CAST('2' AS Int32));

SELECT
    rightPad('abc', 3),
    rightPad('abc', CAST('3' AS Int32));

SELECT
    rightPad('abc', 4),
    rightPad('abc', CAST('4' AS Int32));

SELECT
    rightPad('abc', 5),
    rightPad('abc', CAST('5' AS Int32));

SELECT
    rightPad('abc', 10),
    rightPad('abc', CAST('10' AS Int32));

SELECT
    rightPad('abc', 2, '*'),
    rightPad('abc', CAST('2' AS Int32), '*');

SELECT
    rightPad('abc', 4, '*'),
    rightPad('abc', CAST('4' AS Int32), '*');

SELECT
    rightPad('abc', 5, '*'),
    rightPad('abc', CAST('5' AS Int32), '*');

SELECT
    rightPad('abc', 10, '*'),
    rightPad('abc', CAST('10' AS Int32), '*');

SELECT
    rightPad('abc', 2, '*.'),
    rightPad('abc', CAST('2' AS Int32), '*.');

SELECT
    rightPad('abc', 4, '*.'),
    rightPad('abc', CAST('4' AS Int32), '*.');

SELECT
    rightPad('abc', 5, '*.'),
    rightPad('abc', CAST('5' AS Int32), '*.');

SELECT
    rightPad('abc', 10, '*.'),
    rightPad('abc', CAST('10' AS Int32), '*.');

SELECT
    rightPad('абвг', 2),
    rightPad('абвг', CAST('2' AS Int32));

SELECT
    rightPadUTF8('абвг', 2),
    rightPadUTF8('абвг', CAST('2' AS Int32));

SELECT
    rightPad('абвг', 4),
    rightPad('абвг', CAST('4' AS Int32));

SELECT
    rightPadUTF8('абвг', 4),
    rightPadUTF8('абвг', CAST('4' AS Int32));

SELECT
    rightPad('абвг', 12, 'ЧАС'),
    rightPad('абвг', CAST('12' AS Int32), 'ЧАС');

SELECT
    rightPadUTF8('абвг', 12, 'ЧАС'),
    rightPadUTF8('абвг', CAST('12' AS Int32), 'ЧАС');

SELECT rightPad(leftPad(toString(number), number, '_'), number * 2, '^')
FROM numbers(7);

SELECT rightPad(leftPad(toString(number), number::Int64, '_'), number::Int64 * 2, '^')
FROM numbers(7);