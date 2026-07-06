-- Test for case-insensitive prefix and suffix matching functions, (starts|endswith)(UTF8)?CaseInsensitive
SELECT '-- Test startsWithCaseInsensitive ASCII';

SELECT
    startsWithCaseInsensitive('Marta', 'mA'),
    startsWithCaseInsensitive('match_me_not', 'Na');

SELECT
    startsWithCaseInsensitive('Bär', 'bä'),
    startsWithCaseInsensitive('Bär', 'BÄ');

SELECT
    startsWithCaseInsensitive('中国', '中'),
    startsWithCaseInsensitive('中国', '国');

SELECT
    startsWithCaseInsensitiveUTF8('Marta', 'mA'),
    startsWithCaseInsensitiveUTF8('match_me_not', 'Na');

SELECT
    startsWithCaseInsensitiveUTF8('Bär', 'bä'),
    startsWithCaseInsensitiveUTF8('Bär', 'BÄ');

SELECT
    startsWithCaseInsensitiveUTF8('中国', '中'),
    startsWithCaseInsensitiveUTF8('Hello中国', '中');

SELECT
    endsWithCaseInsensitive('Marta', 'tA'),
    endsWithCaseInsensitive('match_me_not', 'Na');

SELECT
    endsWithCaseInsensitive('Bär', 'äR'),
    endsWithCaseInsensitive('Bär', 'ÄR');

SELECT
    endsWithCaseInsensitive('中国', '国'),
    endsWithCaseInsensitive('中国', '中');

SELECT
    endsWithCaseInsensitiveUTF8('Marta', 'tA'),
    endsWithCaseInsensitiveUTF8('match_me_not', 'Na');

SELECT
    endsWithCaseInsensitiveUTF8('Bär', 'äR'),
    endsWithCaseInsensitiveUTF8('Bär', 'ÄR');

SELECT
    endsWithCaseInsensitiveUTF8('中国', '国'),
    endsWithCaseInsensitiveUTF8('中国', '中');

SELECT
    startsWithCaseInsensitive('中国', '�'),
    startsWithCaseInsensitiveUTF8('中国', '�');

SELECT
    endsWithCaseInsensitive('中国', '�'),
    endsWithCaseInsensitiveUTF8('中国', '�');

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    S1 String,
    S2 String,
    S3 FixedString(4)
)
ENGINE = Memory();

INSERT INTO tab;

SELECT COUNT()
FROM tab
WHERE startsWithCaseInsensitive(S1, '1');

SELECT COUNT()
FROM tab
WHERE startsWithCaseInsensitive(S2, '中');

SELECT COUNT()
FROM tab
WHERE startsWithCaseInsensitive(S3, '国');

SELECT COUNT()
FROM tab
WHERE startsWithCaseInsensitiveUTF8(S1, '1');

SELECT COUNT()
FROM tab
WHERE startsWithCaseInsensitiveUTF8(S2, '中');

SELECT COUNT()
FROM tab
WHERE endsWithCaseInsensitive(S1, '2');

SELECT COUNT()
FROM tab
WHERE endsWithCaseInsensitive(S2, '中');

SELECT COUNT()
FROM tab
WHERE endsWithCaseInsensitive(S3, '国\0');

SELECT COUNT()
FROM tab
WHERE endsWithCaseInsensitiveUTF8(S1, '2');

SELECT COUNT()
FROM tab
WHERE endsWithCaseInsensitiveUTF8(S2, '中');

SELECT COUNT()
FROM tab
WHERE startsWithCaseInsensitive(S1, S1);

SELECT COUNT()
FROM tab
WHERE startsWithCaseInsensitive(S1, S2);

SELECT COUNT()
FROM tab
WHERE startsWithCaseInsensitive(S2, S3);

SELECT COUNT()
FROM tab
WHERE startsWithCaseInsensitiveUTF8(S1, S1);

SELECT COUNT()
FROM tab
WHERE startsWithCaseInsensitiveUTF8(S1, S2);

SELECT COUNT()
FROM tab
WHERE endsWithCaseInsensitive(S1, S1);

SELECT COUNT()
FROM tab
WHERE endsWithCaseInsensitive(S1, S2);

SELECT COUNT()
FROM tab
WHERE endsWithCaseInsensitive(S2, S3);

SELECT COUNT()
FROM tab
WHERE endsWithCaseInsensitiveUTF8(S1, S1);

SELECT COUNT()
FROM tab
WHERE endsWithCaseInsensitiveUTF8(S1, S2);

-- endsWithCaseCaseInsensitiveUTF8 does not support FixedString
DROP TABLE tab;