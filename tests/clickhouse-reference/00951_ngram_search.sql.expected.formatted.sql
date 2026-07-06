SELECT round(1000 * ngramSearchUTF8(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchUTF8(materialize('абв'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchUTF8(materialize(''), 'абв'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchUTF8(materialize('абвгдеёжз'), 'абвгдеёжз'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchUTF8(materialize('абвгдеёжз'), 'абвгдеёж'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchUTF8(materialize('абвгдеёжз'), 'гдеёзд'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchUTF8(materialize('абвгдеёжз'), 'ёёёёёёёё'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchUTF8(materialize(''), materialize(''))) = round(1000 * ngramSearchUTF8(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchUTF8(materialize('абв'), materialize(''))) = round(1000 * ngramSearchUTF8(materialize('абв'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchUTF8(materialize(''), materialize('абв'))) = round(1000 * ngramSearchUTF8(materialize(''), 'абв'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchUTF8(materialize('абвгдеёжз'), materialize('абвгдеёжз'))) = round(1000 * ngramSearchUTF8(materialize('абвгдеёжз'), 'абвгдеёжз'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchUTF8(materialize('абвгдеёжз'), materialize('абвгдеёж'))) = round(1000 * ngramSearchUTF8(materialize('абвгдеёжз'), 'абвгдеёж'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchUTF8(materialize('абвгдеёжз'), materialize('гдеёзд'))) = round(1000 * ngramSearchUTF8(materialize('абвгдеёжз'), 'гдеёзд'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchUTF8(materialize('абвгдеёжз'), materialize('ёёёёёёёё'))) = round(1000 * ngramSearchUTF8(materialize('абвгдеёжз'), 'ёёёёёёёё'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchUTF8('', materialize(''))) = round(1000 * ngramSearchUTF8(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchUTF8('абв', materialize(''))) = round(1000 * ngramSearchUTF8(materialize('абв'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchUTF8('', materialize('абв'))) = round(1000 * ngramSearchUTF8(materialize(''), 'абв'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchUTF8('абвгдеёжз', materialize('абвгдеёжз'))) = round(1000 * ngramSearchUTF8(materialize('абвгдеёжз'), 'абвгдеёжз'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchUTF8('абвгдеёжз', materialize('абвгдеёж'))) = round(1000 * ngramSearchUTF8(materialize('абвгдеёжз'), 'абвгдеёж'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchUTF8('абвгдеёжз', materialize('гдеёзд'))) = round(1000 * ngramSearchUTF8(materialize('абвгдеёжз'), 'гдеёзд'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchUTF8('абвгдеёжз', materialize('ёёёёёёёё'))) = round(1000 * ngramSearchUTF8(materialize('абвгдеёжз'), 'ёёёёёёёё'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchUTF8('', ''));

SELECT round(1000 * ngramSearchUTF8('абв', ''));

SELECT round(1000 * ngramSearchUTF8('', 'абв'));

SELECT round(1000 * ngramSearchUTF8('абвгдеёжз', 'абвгдеёжз'));

SELECT round(1000 * ngramSearchUTF8('абвгдеёжз', 'абвгдеёж'));

SELECT round(1000 * ngramSearchUTF8('абвгдеёжз', 'гдеёзд'));

SELECT round(1000 * ngramSearchUTF8('абвгдеёжз', 'ёёёёёёёё'));

DROP TABLE IF EXISTS test_entry_distance;

CREATE TABLE test_entry_distance
(
    Title String
)
ENGINE = Memory();

INSERT INTO test_entry_distance;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchUTF8(Title, Title) AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchUTF8(Title, extract(Title, 'как дела')) AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchUTF8(Title, extract(Title, 'metr')) AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchUTF8(Title, 'привет как дела') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchUTF8(Title, 'как привет дела') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchUTF8(Title, 'metrika') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchUTF8(Title, 'metrica') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchUTF8(Title, 'metriks') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchUTF8(Title, 'metrics') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchUTF8(Title, 'bigmir') AS distance ASC,
    Title ASC;

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8(materialize('абв'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8(materialize(''), 'абв'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8(materialize('абвГДЕёжз'), 'АбвгдЕёжз'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8(materialize('аБВГдеёЖз'), 'АбвГдеёж'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8(materialize('абвгдеёжз'), 'гдеёЗД'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8(materialize('абвгдеёжз'), 'ЁЁЁЁЁЁЁЁ'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8(materialize(''), materialize(''))) = round(1000 * ngramSearchCaseInsensitiveUTF8(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8(materialize('абв'), materialize(''))) = round(1000 * ngramSearchCaseInsensitiveUTF8(materialize('абв'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8(materialize(''), materialize('абв'))) = round(1000 * ngramSearchCaseInsensitiveUTF8(materialize(''), 'абв'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8(materialize('абвГДЕёжз'), materialize('АбвгдЕёжз'))) = round(1000 * ngramSearchCaseInsensitiveUTF8(materialize('абвГДЕёжз'), 'АбвгдЕёжз'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8(materialize('аБВГдеёЖз'), materialize('АбвГдеёж'))) = round(1000 * ngramSearchCaseInsensitiveUTF8(materialize('аБВГдеёЖз'), 'АбвГдеёж'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8(materialize('абвгдеёжз'), materialize('гдеёЗД'))) = round(1000 * ngramSearchCaseInsensitiveUTF8(materialize('абвгдеёжз'), 'гдеёЗД'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8(materialize('абвгдеёжз'), materialize('ЁЁЁЁЁЁЁЁ'))) = round(1000 * ngramSearchCaseInsensitiveUTF8(materialize('абвгдеёжз'), 'ЁЁЁЁЁЁЁЁ'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8('', materialize(''))) = round(1000 * ngramSearchCaseInsensitiveUTF8(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8('абв', materialize(''))) = round(1000 * ngramSearchCaseInsensitiveUTF8(materialize('абв'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8('', materialize('абв'))) = round(1000 * ngramSearchCaseInsensitiveUTF8(materialize(''), 'абв'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8('абвГДЕёжз', materialize('АбвгдЕёжз'))) = round(1000 * ngramSearchCaseInsensitiveUTF8(materialize('абвГДЕёжз'), 'АбвгдЕёжз'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8('аБВГдеёЖз', materialize('АбвГдеёж'))) = round(1000 * ngramSearchCaseInsensitiveUTF8(materialize('аБВГдеёЖз'), 'АбвГдеёж'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8('абвгдеёжз', materialize('гдеёЗД'))) = round(1000 * ngramSearchCaseInsensitiveUTF8(materialize('абвгдеёжз'), 'гдеёЗД'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8('абвгдеёжз', materialize('ЁЁЁЁЁЁЁЁ'))) = round(1000 * ngramSearchCaseInsensitiveUTF8(materialize('абвгдеёжз'), 'ЁЁЁЁЁЁЁЁ'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8('', ''));

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8('абв', ''));

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8('', 'абв'));

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8('абвГДЕёжз', 'АбвгдЕЁжз'));

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8('аБВГдеёЖз', 'АбвГдеёж'));

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8('абвгдеёжз', 'гдеёЗД'));

SELECT round(1000 * ngramSearchCaseInsensitiveUTF8('АБВГДеёжз', 'ЁЁЁЁЁЁЁЁ'));

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchCaseInsensitiveUTF8(Title, Title) AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchCaseInsensitiveUTF8(Title, extract(Title, 'как дела')) AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchCaseInsensitiveUTF8(Title, extract(Title, 'metr')) AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchCaseInsensitiveUTF8(Title, 'ПрИвЕт кАК ДЕЛа') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchCaseInsensitiveUTF8(Title, 'как ПРИВЕТ дела') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchCaseInsensitiveUTF8(Title, 'metrika') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchCaseInsensitiveUTF8(Title, 'mEtrica') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchCaseInsensitiveUTF8(Title, 'metriKS') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchCaseInsensitiveUTF8(Title, 'metrics') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchCaseInsensitiveUTF8(Title, 'BigMIR') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchCaseInsensitiveUTF8(Title, 'приВЕТ КАк ДеЛа КлИп - bigMir.Net') AS distance ASC,
    Title ASC;

SELECT round(1000 * ngramSearch(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearch(materialize('abc'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearch(materialize(''), 'abc'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearch(materialize('abcdefgh'), 'abcdefgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearch(materialize('abcdefgh'), 'abcdefg'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearch(materialize('abcdefgh'), 'defgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearch(materialize('abcdefgh'), 'aaaaaaaa'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearch(materialize(''), materialize(''))) = round(1000 * ngramSearch(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearch(materialize('abc'), materialize(''))) = round(1000 * ngramSearch(materialize('abc'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearch(materialize(''), materialize('abc'))) = round(1000 * ngramSearch(materialize(''), 'abc'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearch(materialize('abcdefgh'), materialize('abcdefgh'))) = round(1000 * ngramSearch(materialize('abcdefgh'), 'abcdefgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearch(materialize('abcdefgh'), materialize('abcdefg'))) = round(1000 * ngramSearch(materialize('abcdefgh'), 'abcdefg'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearch(materialize('abcdefgh'), materialize('defgh'))) = round(1000 * ngramSearch(materialize('abcdefgh'), 'defgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearch(materialize('abcdefgh'), materialize('aaaaaaaa'))) = round(1000 * ngramSearch(materialize('abcdefgh'), 'aaaaaaaa'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearch('', materialize(''))) = round(1000 * ngramSearch(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearch('abc', materialize(''))) = round(1000 * ngramSearch(materialize('abc'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearch('', materialize('abc'))) = round(1000 * ngramSearch(materialize(''), 'abc'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearch('abcdefgh', materialize('abcdefgh'))) = round(1000 * ngramSearch(materialize('abcdefgh'), 'abcdefgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearch('abcdefgh', materialize('abcdefg'))) = round(1000 * ngramSearch(materialize('abcdefgh'), 'abcdefg'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearch('abcdefgh', materialize('defgh'))) = round(1000 * ngramSearch(materialize('abcdefgh'), 'defgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearch('abcdefgh', materialize('aaaaaaaa'))) = round(1000 * ngramSearch(materialize('abcdefgh'), 'aaaaaaaa'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearch('', ''));

SELECT round(1000 * ngramSearch('abc', ''));

SELECT round(1000 * ngramSearch('', 'abc'));

SELECT round(1000 * ngramSearch('abcdefgh', 'abcdefgh'));

SELECT round(1000 * ngramSearch('abcdefgh', 'abcdefg'));

SELECT round(1000 * ngramSearch('abcdefgh', 'defgh'));

SELECT round(1000 * ngramSearch('abcdefghaaaaaaaaaa', 'aaaaaaaa'));

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearch(Title, 'привет как дела') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearch(Title, 'как привет дела') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearch(Title, 'metrika') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearch(Title, 'metrica') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearch(Title, 'metriks') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearch(Title, 'metrics') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearch(Title, 'bigmir') AS distance ASC,
    Title ASC;

SELECT round(1000 * ngramSearchCaseInsensitive(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitive(materialize('abc'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitive(materialize(''), 'abc'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitive(materialize('abCdefgH'), 'Abcdefgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitive(materialize('abcdefgh'), 'abcdeFG'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitive(materialize('AAAAbcdefgh'), 'defgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitive(materialize('ABCdefgH'), 'aaaaaaaa'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitive(materialize(''), materialize(''))) = round(1000 * ngramSearchCaseInsensitive(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitive(materialize('abc'), materialize(''))) = round(1000 * ngramSearchCaseInsensitive(materialize('abc'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitive(materialize(''), materialize('abc'))) = round(1000 * ngramSearchCaseInsensitive(materialize(''), 'abc'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitive(materialize('abCdefgH'), materialize('Abcdefgh'))) = round(1000 * ngramSearchCaseInsensitive(materialize('abCdefgH'), 'Abcdefgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitive(materialize('abcdefgh'), materialize('abcdeFG'))) = round(1000 * ngramSearchCaseInsensitive(materialize('abcdefgh'), 'abcdeFG'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitive(materialize('AAAAbcdefgh'), materialize('defgh'))) = round(1000 * ngramSearchCaseInsensitive(materialize('AAAAbcdefgh'), 'defgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitive(materialize('ABCdefgH'), materialize('aaaaaaaa'))) = round(1000 * ngramSearchCaseInsensitive(materialize('ABCdefgH'), 'aaaaaaaa'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitive('', materialize(''))) = round(1000 * ngramSearchCaseInsensitive(materialize(''), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitive('abc', materialize(''))) = round(1000 * ngramSearchCaseInsensitive(materialize('abc'), ''))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitive('', materialize('abc'))) = round(1000 * ngramSearchCaseInsensitive(materialize(''), 'abc'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitive('abCdefgH', materialize('Abcdefgh'))) = round(1000 * ngramSearchCaseInsensitive(materialize('abCdefgH'), 'Abcdefgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitive('abcdefgh', materialize('abcdeFG'))) = round(1000 * ngramSearchCaseInsensitive(materialize('abcdefgh'), 'abcdeFG'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitive('AAAAbcdefgh', materialize('defgh'))) = round(1000 * ngramSearchCaseInsensitive(materialize('AAAAbcdefgh'), 'defgh'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitive('ABCdefgH', materialize('aaaaaaaa'))) = round(1000 * ngramSearchCaseInsensitive(materialize('ABCdefgH'), 'aaaaaaaa'))
FROM `system`.numbers
LIMIT 5;

SELECT round(1000 * ngramSearchCaseInsensitive('', ''));

SELECT round(1000 * ngramSearchCaseInsensitive('abc', ''));

SELECT round(1000 * ngramSearchCaseInsensitive('', 'abc'));

SELECT round(1000 * ngramSearchCaseInsensitive('abCdefgH', 'Abcdefgh'));

SELECT round(1000 * ngramSearchCaseInsensitive('abcdefgh', 'abcdeFG'));

SELECT round(1000 * ngramSearchCaseInsensitive('AAAAbcdefgh', 'defgh'));

SELECT round(1000 * ngramSearchCaseInsensitive('ABCdefgHaAaaaAaaaAA', 'aaaaaaaa'));

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchCaseInsensitive(Title, 'ПрИвЕт кАК ДЕЛа') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchCaseInsensitive(Title, 'как ПРИВЕТ дела') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchCaseInsensitive(Title, 'metrika') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchCaseInsensitive(Title, 'mEtrica') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchCaseInsensitive(Title, 'metriKS') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchCaseInsensitive(Title, 'metrics') AS distance ASC,
    Title ASC;

SELECT
    Title,
    round(1000 * distance)
FROM test_entry_distance
ORDER BY
    ngramSearchCaseInsensitive(Title, 'BigMIR') AS distance ASC,
    Title ASC;