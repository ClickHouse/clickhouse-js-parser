-- Tags: no-fasttest
-- no-fasttest: requires idna library
-- See also 02932_punycode.sql
SELECT '-- Negative tests';

SELECT idnaEncode(); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT tryIdnaEncode(); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT idnaDecode(); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT idnaEncode(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT tryIdnaEncode(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT idnaDecode(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT idnaEncode('two', 'strings'); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT tryIdnaEncode('two', 'strings'); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT idnaDecode('two', 'strings'); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT idnaEncode(toFixedString('two', 3)); -- { serverError NOT_IMPLEMENTED }

SELECT tryIdnaEncode(toFixedString('two', 3)); -- { serverError NOT_IMPLEMENTED }

SELECT idnaDecode(toFixedString('two', 3)); -- { serverError NOT_IMPLEMENTED }

-- The test cases originate from the ada idna unit tests:
-- - https://github.com/ada-url/idna/blob/8cd03ef867dbd06be87bd61df9cf69aa1182ea21/tests/fixtures/to_ascii_alternating.txt
-- - https://github.com/ada-url/idna/blob/8cd03ef867dbd06be87bd61df9cf69aa1182ea21/tests/fixtures/to_unicode_alternating.txt
--
SELECT
    'straße.de' AS idna,
    idnaEncode(idna) AS ascii,
    tryIdnaEncode(idna) AS ascii_try,
    idnaDecode(ascii) AS original,
    idnaDecode(ascii_try) AS original_try;

SELECT
    '2001:4860:4860::8888' AS idna,
    idnaEncode(idna) AS ascii,
    tryIdnaEncode(idna) AS ascii_try,
    idnaDecode(ascii) AS original,
    idnaDecode(ascii_try) AS original_try;

SELECT
    'AMAZON' AS idna,
    idnaEncode(idna) AS ascii,
    tryIdnaEncode(idna) AS ascii_try,
    idnaDecode(ascii) AS original,
    idnaDecode(ascii_try) AS original_try;

SELECT
    'aa--' AS idna,
    idnaEncode(idna) AS ascii,
    tryIdnaEncode(idna) AS ascii_try,
    idnaDecode(ascii) AS original,
    idnaDecode(ascii_try) AS original_try;

SELECT
    'a†--' AS idna,
    idnaEncode(idna) AS ascii,
    tryIdnaEncode(idna) AS ascii_try,
    idnaDecode(ascii) AS original,
    idnaDecode(ascii_try) AS original_try;

SELECT
    'ab--c' AS idna,
    idnaEncode(idna) AS ascii,
    tryIdnaEncode(idna) AS ascii_try,
    idnaDecode(ascii) AS original,
    idnaDecode(ascii_try) AS original_try;

SELECT
    '-†' AS idna,
    idnaEncode(idna) AS ascii,
    tryIdnaEncode(idna) AS ascii_try,
    idnaDecode(ascii) AS original,
    idnaDecode(ascii_try) AS original_try;

SELECT
    '-x.xn--zca' AS idna,
    idnaEncode(idna) AS ascii,
    tryIdnaEncode(idna) AS ascii_try,
    idnaDecode(ascii) AS original,
    idnaDecode(ascii_try) AS original_try;

SELECT
    'x-.xn--zca' AS idna,
    idnaEncode(idna) AS ascii,
    tryIdnaEncode(idna) AS ascii_try,
    idnaDecode(ascii) AS original,
    idnaDecode(ascii_try) AS original_try;

SELECT
    'x-.ß' AS idna,
    idnaEncode(idna) AS ascii,
    tryIdnaEncode(idna) AS ascii_try,
    idnaDecode(ascii) AS original,
    idnaDecode(ascii_try) AS original_try;

SELECT
    'x..ß' AS idna,
    idnaEncode(idna) AS ascii,
    tryIdnaEncode(idna) AS ascii_try,
    idnaDecode(ascii) AS original,
    idnaDecode(ascii_try) AS original_try;

SELECT
    '128.0,0.1' AS idna,
    idnaEncode(idna) AS ascii,
    tryIdnaEncode(idna) AS ascii_try,
    idnaDecode(ascii) AS original,
    idnaDecode(ascii_try) AS original_try;

SELECT
    'xn--zca.xn--zca' AS idna,
    idnaEncode(idna) AS ascii,
    tryIdnaEncode(idna) AS ascii_try,
    idnaDecode(ascii) AS original,
    idnaDecode(ascii_try) AS original_try;

SELECT
    'x01234567890123456789012345678901234567890123456789012345678901x' AS idna,
    idnaEncode(idna) AS ascii,
    tryIdnaEncode(idna) AS ascii_try,
    idnaDecode(ascii) AS original,
    idnaDecode(ascii_try) AS original_try;

SELECT
    'x01234567890123456789012345678901234567890123456789012345678901x.xn--zca' AS idna,
    idnaEncode(idna) AS ascii,
    tryIdnaEncode(idna) AS ascii_try,
    idnaDecode(ascii) AS original,
    idnaDecode(ascii_try) AS original_try;

SELECT
    'x01234567890123456789012345678901234567890123456789012345678901x.ß' AS idna,
    idnaEncode(idna) AS ascii,
    tryIdnaEncode(idna) AS ascii_try,
    idnaDecode(ascii) AS original,
    idnaDecode(ascii_try) AS original_try;

SELECT
    '01234567890123456789012345678901234567890123456789.01234567890123456789012345678901234567890123456789.01234567890123456789012345678901234567890123456789.01234567890123456789012345678901234567890123456789.0123456789012345678901234567890123456789012345678.x' AS idna,
    idnaEncode(idna) AS ascii,
    tryIdnaEncode(idna) AS ascii_try,
    idnaDecode(ascii) AS original,
    idnaDecode(ascii_try) AS original_try;

SELECT
    '≠' AS idna,
    idnaEncode(idna) AS ascii,
    tryIdnaEncode(idna) AS ascii_try,
    idnaDecode(ascii) AS original,
    idnaDecode(ascii_try) AS original_try;

SELECT
    '-x' AS ascii,
    idnaDecode(ascii) AS unicode,
    idnaEncode(unicode) AS original,
    tryIdnaEncode(unicode) AS original_try;

SELECT
    '' AS ascii,
    idnaDecode(ascii) AS unicode,
    idnaEncode(unicode) AS original,
    tryIdnaEncode(unicode) AS original_try;

SELECT
    'ejemplo.xn--q9jyb4c' AS ascii,
    idnaDecode(ascii) AS unicode,
    idnaEncode(unicode) AS original,
    tryIdnaEncode(unicode) AS original_try;

SELECT
    '1xn--' AS ascii,
    idnaDecode(ascii) AS unicode,
    idnaEncode(unicode) AS original,
    tryIdnaEncode(unicode) AS original_try;

SELECT
    '≠' AS ascii,
    idnaDecode(ascii) AS unicode,
    idnaEncode(unicode) AS original,
    tryIdnaEncode(unicode) AS original_try;

SELECT
    'ファッション.biz' AS ascii,
    idnaDecode(ascii) AS unicode,
    idnaEncode(unicode) AS original,
    tryIdnaEncode(unicode) AS original_try;

SELECT idnaEncode('');

SELECT tryIdnaEncode('');

SELECT idnaDecode('');

SELECT idnaEncode(NULL);

SELECT tryIdnaEncode(NULL);

SELECT idnaDecode(NULL);

-- - https://github.com/ada-url/idna/blob/8cd03ef867dbd06be87bd61df9cf69aa1182ea21/tests/fixtures/to_ascii_invalid.txt
SELECT idnaEncode('xn--'); -- { serverError BAD_ARGUMENTS }

SELECT tryIdnaEncode('xn--');

SELECT idnaEncode('ﻱa'); -- { serverError BAD_ARGUMENTS }

SELECT tryIdnaEncode('ﻱa');

SELECT
    'Wenn Sie ... vom Hauptbahnhof in München ... mit zehn Minuten, ohne, dass Sie am Flughafen noch einchecken müssen, dann starten Sie im Grunde genommen am Flughafen ... am ... am Hauptbahnhof in München starten Sie Ihren Flug. Zehn Minuten. Schauen Sie sich mal die großen Flughäfen an, wenn Sie in Heathrow in London oder sonst wo, meine se ... Charles de Gaulle äh in Frankreich oder in ...äh... in ... in...äh...in Rom. Wenn Sie sich mal die Entfernungen ansehen, wenn Sie Frankfurt sich ansehen, dann werden Sie feststellen, dass zehn Minuten... Sie jederzeit locker in Frankfurt brauchen, um ihr Gate zu finden. Wenn Sie vom Flug ... vom ... vom Hauptbahnhof starten - Sie steigen in den Hauptbahnhof ein, Sie fahren mit dem Transrapid in zehn Minuten an den Flughafen in ... an den Flughafen Franz Josef Strauß. Dann starten Sie praktisch hier am Hauptbahnhof in München. Das bedeutet natürlich, dass der Hauptbahnhof im Grunde genommen näher an Bayern ... an die bayerischen Städte heranwächst, weil das ja klar ist, weil auf dem Hauptbahnhof viele Linien aus Bayern zusammenlaufen.' AS idna,
    idnaEncode(idna) AS ascii,
    tryIdnaEncode(ascii) AS ascii_try,
    idnaDecode(ascii) AS original,
    idnaDecode(ascii_try) AS original_try
FORMAT Vertical;

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    idna String
)
ENGINE = MergeTree()
ORDER BY idna;

INSERT INTO tab;

SELECT
    idna,
    idnaEncode(idna) AS ascii,
    tryIdnaEncode(ascii) AS ascii_try,
    idnaDecode(ascii) AS original,
    idnaDecode(ascii_try) AS original_try
FROM tab;

DROP TABLE tab;

INSERT INTO tab;

SELECT
    idna,
    idnaEncode(idna) AS ascii
FROM tab; -- { serverError BAD_ARGUMENTS }

SELECT
    idna,
    tryIdnaEncode(idna) AS ascii,
    idnaDecode(ascii) AS original
FROM tab;