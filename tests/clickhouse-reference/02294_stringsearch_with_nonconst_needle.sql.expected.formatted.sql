-- tests of "(not) (i)like" functions
DROP TABLE IF EXISTS non_const_needle;

CREATE TABLE non_const_needle
(
    id UInt32,
    haystack String,
    needle String
)
ENGINE = MergeTree()
ORDER BY id;

-- 1 - 33: LIKE-syntax, 34-37: re2-syntax
INSERT INTO non_const_needle;

SELECT
    id,
    haystack,
    needle,
    like(haystack, needle)
FROM non_const_needle
ORDER BY id ASC;

SELECT
    id,
    haystack,
    needle,
    NOT like(haystack, needle)
FROM non_const_needle
ORDER BY id ASC;

SELECT
    id,
    haystack,
    needle,
    ilike(haystack, needle)
FROM non_const_needle
ORDER BY id ASC;

SELECT
    id,
    haystack,
    needle,
    NOT ilike(haystack, needle)
FROM non_const_needle
ORDER BY id ASC;

SELECT
    id,
    haystack,
    needle,
    match(haystack, needle)
FROM non_const_needle
ORDER BY id ASC;

SELECT multiSearchAny(materialize('Hello World'), materialize([])); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT 0 = multiSearchAny('Hello World', CAST([] AS Array(String)));

SELECT 1 = multiSearchAny(materialize('Hello World'), materialize(['orld']));

SELECT 0 = multiSearchAny(materialize('Hello World'), materialize(['Hallo', 'Welt']));

SELECT 1 = multiSearchAny(materialize('Hello World'), materialize(['Hallo', 'orld']));

SELECT 1 = multiSearchAnyCaseInsensitive(materialize('Hello World'), materialize(['WORLD']));

SELECT 1 = multiSearchAnyUTF8(materialize('Hello World £'), materialize(['WORLD', '£']));

SELECT 1 = multiSearchAnyCaseInsensitiveUTF8(materialize('Hello World £'), materialize(['WORLD']));

SELECT multiSearchFirstIndex(materialize('Hello World'), materialize([])); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT 0 = multiSearchFirstIndex('Hello World', CAST([] AS Array(String)));

SELECT 1 = multiSearchFirstIndex(materialize('Hello World'), materialize(['orld']));

SELECT 0 = multiSearchFirstIndex(materialize('Hello World'), materialize(['Hallo', 'Welt']));

SELECT 2 = multiSearchFirstIndex(materialize('Hello World'), materialize(['Hallo', 'orld']));

SELECT 1 = multiSearchFirstIndexCaseInsensitive(materialize('Hello World'), materialize(['WORLD']));

SELECT 2 = multiSearchFirstIndexUTF8(materialize('Hello World £'), materialize(['WORLD', '£']));

SELECT 1 = multiSearchFirstIndexCaseInsensitiveUTF8(materialize('Hello World £'), materialize(['WORLD']));

SELECT multiSearchFirstPosition(materialize('Hello World'), materialize([])); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT 0 = multiSearchFirstPosition('Hello World', CAST([] AS Array(String)));

SELECT 8 = multiSearchFirstPosition(materialize('Hello World'), materialize(['orld']));

SELECT 0 = multiSearchFirstPosition(materialize('Hello World'), materialize(['Hallo', 'Welt']));

SELECT 8 = multiSearchFirstPosition(materialize('Hello World'), materialize(['Hallo', 'orld']));

SELECT 7 = multiSearchFirstPositionCaseInsensitive(materialize('Hello World'), materialize(['WORLD']));

SELECT 13 = multiSearchFirstPositionUTF8(materialize('Hello World £'), materialize(['WORLD', '£']));

SELECT 7 = multiSearchFirstPositionCaseInsensitiveUTF8(materialize('Hello World £'), materialize(['WORLD']));