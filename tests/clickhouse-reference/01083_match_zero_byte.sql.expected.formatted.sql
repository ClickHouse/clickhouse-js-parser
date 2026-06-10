-- Tags: no-fasttest
-- no-fasttest: Requires vectorscan
SELECT match('a key="v" ', 'key="(.*?)"');

SELECT match(materialize('a key="v" '), 'key="(.*?)"');

SELECT match('\0 key="v" ', 'key="(.*?)"');

SELECT match(materialize('\0 key="v" '), 'key="(.*?)"');

SELECT multiMatchAny('\0 key="v" ', ['key="(.*?)"']);

SELECT multiMatchAny(materialize('\0 key="v" '), ['key="(.*?)"']);

SELECT
    unhex('34') || ' key="v" ' AS haystack,
    length(haystack),
    extract(haystack, 'key="(.*?)"') AS needle;

-- works, result = v
SELECT
    unhex('00') || ' key="v" ' AS haystack,
    length(haystack),
    extract(haystack, 'key="(.*?)"') AS needle;

-- before fix: returns nothing (zero-byte in the begining of haystack)
SELECT
    number AS char_code,
    extract(char(char_code) || ' key="v" ' AS haystack, 'key="(.*?)"') AS needle
FROM numbers(256); -- every other chars codes (except of zero byte) works ok