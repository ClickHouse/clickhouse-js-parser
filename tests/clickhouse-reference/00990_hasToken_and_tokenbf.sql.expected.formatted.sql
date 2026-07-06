DROP TABLE IF EXISTS bloom_filter;

CREATE TABLE bloom_filter
(
    id UInt64,
    s String,
    INDEX tok_bf (s, lower(s)) TYPE tokenbf_v1(512, 3, 0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '8', index_granularity_bytes = '10Mi';

INSERT INTO bloom_filter SELECT
    number,
    'yyy,uuu'
FROM numbers(1024);

INSERT INTO bloom_filter SELECT
    number + 2000,
    'abc,def,zzz'
FROM numbers(8);

INSERT INTO bloom_filter SELECT
    number + 3000,
    'yyy,uuu'
FROM numbers(1024);

INSERT INTO bloom_filter SELECT
    number + 3000,
    'abcdefzzz'
FROM numbers(1024);

SELECT max(id)
FROM bloom_filter
WHERE hasToken(s, 'abc,def,zzz'); -- { serverError BAD_ARGUMENTS }

SELECT max(id)
FROM bloom_filter
WHERE hasTokenCaseInsensitive(s, 'abc,def,zzz'); -- { serverError BAD_ARGUMENTS }

SELECT max(id)
FROM bloom_filter
WHERE hasTokenOrNull(s, 'abc,def,zzz');

SELECT max(id)
FROM bloom_filter
WHERE hasTokenCaseInsensitiveOrNull(s, 'abc,def,zzz');

-- as table "bloom_filter" but w/o index_granularity_bytes
DROP TABLE IF EXISTS bloom_filter2;

CREATE TABLE bloom_filter2
(
    id UInt64,
    s String,
    INDEX tok_bf3 (s, lower(s)) TYPE tokenbf_v1(512, 3, 0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '8';

INSERT INTO bloom_filter2 SELECT
    number,
    'yyy,uuu'
FROM numbers(1024);

INSERT INTO bloom_filter2 SELECT
    number + 2000,
    'ABC,def,zzz'
FROM numbers(8);

INSERT INTO bloom_filter2 SELECT
    number + 3000,
    'yyy,uuu'
FROM numbers(1024);

INSERT INTO bloom_filter2 SELECT
    number + 3000,
    'abcdefzzz'
FROM numbers(1024);

SET max_rows_to_read = '16';

SELECT max(id)
FROM bloom_filter
WHERE hasToken(s, 'abc');

SELECT max(id)
FROM bloom_filter
WHERE hasTokenOrNull(s, 'abc');

SELECT max(id)
FROM bloom_filter
WHERE hasTokenCaseInsensitive(s, 'ABC');

SELECT max(id)
FROM bloom_filter
WHERE hasTokenCaseInsensitiveOrNull(s, 'ABC');

SELECT max(id)
FROM bloom_filter
WHERE hasToken(s, 'def');

SELECT max(id)
FROM bloom_filter
WHERE hasToken(s, 'zzz');

SELECT max(id)
FROM bloom_filter
WHERE hasTokenCaseInsensitive(s, 'zZz');

SELECT max(id)
FROM bloom_filter2
WHERE hasToken(s, 'ABC');

SELECT max(id)
FROM bloom_filter2
WHERE hasTokenCaseInsensitive(s, 'abc');

-- invert result
-- this does not work as expected, reading more rows that it should
-- SELECT max(id) FROM bloom_filter WHERE NOT hasToken(s, 'yyy');
-- accessing to many rows
SELECT max(id)
FROM bloom_filter
WHERE hasToken(s, 'yyy'); -- { serverError TOO_MANY_ROWS }

-- this syntax is not supported by tokenbf
SELECT max(id)
FROM bloom_filter
WHERE hasToken(s, 'zzz') = 1; -- { serverError TOO_MANY_ROWS }

DROP TABLE bloom_filter;

-- AST fuzzer crash, issue #54541
CREATE TABLE tab
(
    row_id UInt32,
    str String,
    INDEX idx str TYPE tokenbf_v1(256, 2, 0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY row_id;

INSERT INTO tab;

SELECT *
FROM tab
WHERE str = 'else'
    AND 1.;

DROP TABLE tab;