SELECT round(1000 * ngramDistanceUTF8(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceUTF8(materialize('абв'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceUTF8(materialize(''), 'абв'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceUTF8(materialize('абвгдеёжз'), 'абвгдеёжз'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceUTF8(materialize('абвгдеёжз'), 'абвгдеёж'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceUTF8(materialize('абвгдеёжз'), 'гдеёзд'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceUTF8(materialize('абвгдеёжз'), 'ёёёёёёёё'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceUTF8(materialize(''), materialize(''))) = round(1000 * ngramDistanceUTF8(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceUTF8(materialize('абв'), materialize(''))) = round(1000 * ngramDistanceUTF8(materialize('абв'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceUTF8(materialize(''), materialize('абв'))) = round(1000 * ngramDistanceUTF8(materialize(''), 'абв'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceUTF8(materialize('абвгдеёжз'), materialize('абвгдеёжз'))) = round(1000 * ngramDistanceUTF8(materialize('абвгдеёжз'), 'абвгдеёжз'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceUTF8(materialize('абвгдеёжз'), materialize('абвгдеёж'))) = round(1000 * ngramDistanceUTF8(materialize('абвгдеёжз'), 'абвгдеёж'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceUTF8(materialize('абвгдеёжз'), materialize('гдеёзд'))) = round(1000 * ngramDistanceUTF8(materialize('абвгдеёжз'), 'гдеёзд'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceUTF8(materialize('абвгдеёжз'), materialize('ёёёёёёёё'))) = round(1000 * ngramDistanceUTF8(materialize('абвгдеёжз'), 'ёёёёёёёё'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceUTF8('', materialize(''))) = round(1000 * ngramDistanceUTF8(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceUTF8('абв', materialize(''))) = round(1000 * ngramDistanceUTF8(materialize('абв'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceUTF8('', materialize('абв'))) = round(1000 * ngramDistanceUTF8(materialize(''), 'абв'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceUTF8('абвгдеёжз', materialize('абвгдеёжз'))) = round(1000 * ngramDistanceUTF8(materialize('абвгдеёжз'), 'абвгдеёжз'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceUTF8('абвгдеёжз', materialize('абвгдеёж'))) = round(1000 * ngramDistanceUTF8(materialize('абвгдеёжз'), 'абвгдеёж'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceUTF8('абвгдеёжз', materialize('гдеёзд'))) = round(1000 * ngramDistanceUTF8(materialize('абвгдеёжз'), 'гдеёзд'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceUTF8('абвгдеёжз', materialize('ёёёёёёёё'))) = round(1000 * ngramDistanceUTF8(materialize('абвгдеёжз'), 'ёёёёёёёё'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceUTF8('', ''));

SELECT round(1000 * ngramDistanceUTF8('абв', ''));

SELECT round(1000 * ngramDistanceUTF8('', 'абв'));

SELECT round(1000 * ngramDistanceUTF8('абвгдеёжз', 'абвгдеёжз'));

SELECT round(1000 * ngramDistanceUTF8('абвгдеёжз', 'абвгдеёж'));

SELECT round(1000 * ngramDistanceUTF8('абвгдеёжз', 'гдеёзд'));

SELECT round(1000 * ngramDistanceUTF8('абвгдеёжз', 'ёёёёёёёё'));

DROP TABLE IF EXISTS test_distance;

CREATE TABLE test_distance
(
    Title String
)
ENGINE = Memory();

INSERT INTO test_distance;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceUTF8(Title, Title) AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceUTF8(Title, extract(Title, 'как дела')) AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceUTF8(Title, extract(Title, 'metr')) AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceUTF8(Title, 'привет как дела') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceUTF8(Title, 'как привет дела') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceUTF8(Title, 'metrika') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceUTF8(Title, 'metrica') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceUTF8(Title, 'metriks') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceUTF8(Title, 'metrics') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceUTF8(Title, 'bigmir') AS distance ASC,
    Title ASC;

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize('абв'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize(''), 'абв'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize('абвГДЕёжз'), 'АбвгдЕёжз'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize('аБВГдеёЖз'), 'АбвГдеёж'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize('абвгдеёжз'), 'гдеёЗД'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize('абвгдеёжз'), 'ЁЁЁЁЁЁЁЁ'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize(''), materialize(''))) = round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize('абв'), materialize(''))) = round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize('абв'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize(''), materialize('абв'))) = round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize(''), 'абв'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize('абвГДЕёжз'), materialize('АбвгдЕёжз'))) = round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize('абвГДЕёжз'), 'АбвгдЕёжз'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize('аБВГдеёЖз'), materialize('АбвГдеёж'))) = round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize('аБВГдеёЖз'), 'АбвГдеёж'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize('абвгдеёжз'), materialize('гдеёЗД'))) = round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize('абвгдеёжз'), 'гдеёЗД'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize('абвгдеёжз'), materialize('ЁЁЁЁЁЁЁЁ'))) = round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize('абвгдеёжз'), 'ЁЁЁЁЁЁЁЁ'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8('', materialize(''))) = round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8('абв', materialize(''))) = round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize('абв'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8('', materialize('абв'))) = round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize(''), 'абв'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8('абвГДЕёжз', materialize('АбвгдЕёжз'))) = round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize('абвГДЕёжз'), 'АбвгдЕёжз'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8('аБВГдеёЖз', materialize('АбвГдеёж'))) = round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize('аБВГдеёЖз'), 'АбвГдеёж'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8('абвгдеёжз', materialize('гдеёЗД'))) = round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize('абвгдеёжз'), 'гдеёЗД'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8('абвгдеёжз', materialize('ЁЁЁЁЁЁЁЁ'))) = round(1000 * ngramDistanceCaseInsensitiveUTF8(materialize('абвгдеёжз'), 'ЁЁЁЁЁЁЁЁ'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8('', ''));

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8('абв', ''));

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8('', 'абв'));

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8('абвГДЕёжз', 'АбвгдЕЁжз'));

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8('аБВГдеёЖз', 'АбвГдеёж'));

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8('абвгдеёжз', 'гдеёЗД'));

SELECT round(1000 * ngramDistanceCaseInsensitiveUTF8('АБВГДеёжз', 'ЁЁЁЁЁЁЁЁ'));

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceCaseInsensitiveUTF8(Title, Title) AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceCaseInsensitiveUTF8(Title, extract(Title, 'как дела')) AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceCaseInsensitiveUTF8(Title, extract(Title, 'metr')) AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceCaseInsensitiveUTF8(Title, 'ПрИвЕт кАК ДЕЛа') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceCaseInsensitiveUTF8(Title, 'как ПРИВЕТ дела') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceCaseInsensitiveUTF8(Title, 'metrika') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceCaseInsensitiveUTF8(Title, 'mEtrica') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceCaseInsensitiveUTF8(Title, 'metriKS') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceCaseInsensitiveUTF8(Title, 'metrics') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceCaseInsensitiveUTF8(Title, 'BigMIR') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceCaseInsensitiveUTF8(Title, 'приВЕТ КАк ДеЛа КлИп - TuT.by') AS distance ASC,
    Title ASC;

SELECT round(1000 * ngramDistance(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistance(materialize('abc'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistance(materialize(''), 'abc'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistance(materialize('abcdefgh'), 'abcdefgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistance(materialize('abcdefgh'), 'abcdefg'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistance(materialize('abcdefgh'), 'defgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistance(materialize('abcdefgh'), 'aaaaaaaa'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistance(materialize(''), materialize(''))) = round(1000 * ngramDistance(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistance(materialize('abc'), materialize(''))) = round(1000 * ngramDistance(materialize('abc'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistance(materialize(''), materialize('abc'))) = round(1000 * ngramDistance(materialize(''), 'abc'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistance(materialize('abcdefgh'), materialize('abcdefgh'))) = round(1000 * ngramDistance(materialize('abcdefgh'), 'abcdefgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistance(materialize('abcdefgh'), materialize('abcdefg'))) = round(1000 * ngramDistance(materialize('abcdefgh'), 'abcdefg'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistance(materialize('abcdefgh'), materialize('defgh'))) = round(1000 * ngramDistance(materialize('abcdefgh'), 'defgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistance(materialize('abcdefgh'), materialize('aaaaaaaa'))) = round(1000 * ngramDistance(materialize('abcdefgh'), 'aaaaaaaa'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistance('', materialize(''))) = round(1000 * ngramDistance(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistance('abc', materialize(''))) = round(1000 * ngramDistance(materialize('abc'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistance('', materialize('abc'))) = round(1000 * ngramDistance(materialize(''), 'abc'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistance('abcdefgh', materialize('abcdefgh'))) = round(1000 * ngramDistance(materialize('abcdefgh'), 'abcdefgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistance('abcdefgh', materialize('abcdefg'))) = round(1000 * ngramDistance(materialize('abcdefgh'), 'abcdefg'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistance('abcdefgh', materialize('defgh'))) = round(1000 * ngramDistance(materialize('abcdefgh'), 'defgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistance('abcdefgh', materialize('aaaaaaaa'))) = round(1000 * ngramDistance(materialize('abcdefgh'), 'aaaaaaaa'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistance('', ''));

SELECT round(1000 * ngramDistance('abc', ''));

SELECT round(1000 * ngramDistance('', 'abc'));

SELECT round(1000 * ngramDistance('abcdefgh', 'abcdefgh'));

SELECT round(1000 * ngramDistance('abcdefgh', 'abcdefg'));

SELECT round(1000 * ngramDistance('abcdefgh', 'defgh'));

SELECT round(1000 * ngramDistance('abcdefgh', 'aaaaaaaa'));

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistance(Title, 'привет как дела') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistance(Title, 'как привет дела') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistance(Title, 'metrika') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistance(Title, 'metrica') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistance(Title, 'metriks') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistance(Title, 'metrics') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistance(Title, 'bigmir') AS distance ASC,
    Title ASC;

SELECT round(1000 * ngramDistanceCaseInsensitive(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitive(materialize('abc'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitive(materialize(''), 'abc'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitive(materialize('abCdefgH'), 'Abcdefgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitive(materialize('abcdefgh'), 'abcdeFG'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitive(materialize('AAAAbcdefgh'), 'defgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitive(materialize('ABCdefgH'), 'aaaaaaaa'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitive(materialize(''), materialize(''))) = round(1000 * ngramDistanceCaseInsensitive(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitive(materialize('abc'), materialize(''))) = round(1000 * ngramDistanceCaseInsensitive(materialize('abc'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitive(materialize(''), materialize('abc'))) = round(1000 * ngramDistanceCaseInsensitive(materialize(''), 'abc'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitive(materialize('abCdefgH'), materialize('Abcdefgh'))) = round(1000 * ngramDistanceCaseInsensitive(materialize('abCdefgH'), 'Abcdefgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitive(materialize('abcdefgh'), materialize('abcdeFG'))) = round(1000 * ngramDistanceCaseInsensitive(materialize('abcdefgh'), 'abcdeFG'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitive(materialize('AAAAbcdefgh'), materialize('defgh'))) = round(1000 * ngramDistanceCaseInsensitive(materialize('AAAAbcdefgh'), 'defgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitive(materialize('ABCdefgH'), materialize('aaaaaaaa'))) = round(1000 * ngramDistanceCaseInsensitive(materialize('ABCdefgH'), 'aaaaaaaa'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitive('', materialize(''))) = round(1000 * ngramDistanceCaseInsensitive(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitive('abc', materialize(''))) = round(1000 * ngramDistanceCaseInsensitive(materialize('abc'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitive('', materialize('abc'))) = round(1000 * ngramDistanceCaseInsensitive(materialize(''), 'abc'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitive('abCdefgH', materialize('Abcdefgh'))) = round(1000 * ngramDistanceCaseInsensitive(materialize('abCdefgH'), 'Abcdefgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitive('abcdefgh', materialize('abcdeFG'))) = round(1000 * ngramDistanceCaseInsensitive(materialize('abcdefgh'), 'abcdeFG'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitive('AAAAbcdefgh', materialize('defgh'))) = round(1000 * ngramDistanceCaseInsensitive(materialize('AAAAbcdefgh'), 'defgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitive('ABCdefgH', materialize('aaaaaaaa'))) = round(1000 * ngramDistanceCaseInsensitive(materialize('ABCdefgH'), 'aaaaaaaa'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramDistanceCaseInsensitive('', ''));

SELECT round(1000 * ngramDistanceCaseInsensitive('abc', ''));

SELECT round(1000 * ngramDistanceCaseInsensitive('', 'abc'));

SELECT round(1000 * ngramDistanceCaseInsensitive('abCdefgH', 'Abcdefgh'));

SELECT round(1000 * ngramDistanceCaseInsensitive('abcdefgh', 'abcdeFG'));

SELECT round(1000 * ngramDistanceCaseInsensitive('AAAAbcdefgh', 'defgh'));

SELECT round(1000 * ngramDistanceCaseInsensitive('ABCdefgH', 'aaaaaaaa'));

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceCaseInsensitive(Title, 'ПрИвЕт кАК ДЕЛа') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceCaseInsensitive(Title, 'как ПРИВЕТ дела') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceCaseInsensitive(Title, 'metrika') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceCaseInsensitive(Title, 'mEtrica') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceCaseInsensitive(Title, 'metriKS') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceCaseInsensitive(Title, 'metrics') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_distance
ORDER BY
    ngramDistanceCaseInsensitive(Title, 'BigMIR') AS distance ASC,
    Title ASC;