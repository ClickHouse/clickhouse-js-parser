-- Tags: no-parallel-replicas, no-azure-blob-storage
-- Tests that text indexes can be build on and used with Array columns.
SET enable_analyzer = '1';

SET enable_full_text_index = '1';

DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    id UInt32,
    arr Array(String),
    arr_fixed Array(FixedString(3)),
    INDEX array_idx arr TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000,
    INDEX array_fixed_idx arr_fixed TYPE text(tokenizer = 'splitByNonAlpha') GRANULARITY 100000000
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS index_granularity = '1';

INSERT INTO tab SELECT
    number,
    ['abc'],
    ['abc']
FROM numbers(512);

INSERT INTO tab SELECT
    number,
    ['foo'],
    ['foo']
FROM numbers(512);

INSERT INTO tab SELECT
    number,
    ['bar'],
    ['bar']
FROM numbers(512);

INSERT INTO tab SELECT
    number,
    ['foo', 'bar'],
    ['foo', 'bar']
FROM numbers(512);

INSERT INTO tab SELECT
    number,
    ['foo', 'baz'],
    ['foo', 'baz']
FROM numbers(512);

INSERT INTO tab SELECT
    number,
    ['bar', 'baz'],
    ['bar', 'baz']
FROM numbers(512);

SELECT '-- with String';

SELECT count()
FROM tab
WHERE has(arr, 'foo');

SELECT count()
FROM tab
WHERE has(arr, 'bar');

SELECT count()
FROM tab
WHERE has(arr, 'baz');

SELECT count()
FROM tab
WHERE has(arr, 'def');

SELECT count()
FROM tab
WHERE has(arr_fixed, toFixedString('foo', 3));

SELECT count()
FROM tab
WHERE has(arr_fixed, toFixedString('bar', 3));

SELECT count()
FROM tab
WHERE has(arr_fixed, toFixedString('baz', 3));

SELECT count()
FROM tab
WHERE has(arr_fixed, toFixedString('def', 3));

DROP VIEW IF EXISTS explain_index_has;

CREATE VIEW explain_index_has
AS
SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT count()
                FROM tab
                WHERE multiIf(0 = 1, has(arr_fixed, 'placeholder'), has(arr, 'placeholder'))
            ))
    )
WHERE `explain` LIKE '%Description:%'
    OR `explain` LIKE '%Granules:%'
LIMIT 2
OFFSET 1;

SELECT *
FROM explain_index_has(use_idx_fixed = 0, filter = 'abc');

SELECT *
FROM explain_index_has(use_idx_fixed = 0, filter = 'baz');

SELECT *
FROM explain_index_has(use_idx_fixed = 0, filter = 'foo');

SELECT *
FROM explain_index_has(use_idx_fixed = 0, filter = 'bar');

SELECT *
FROM explain_index_has(use_idx_fixed = 0, filter = 'def');

SELECT *
FROM explain_index_has(use_idx_fixed = 1, filter = toFixedString('abc', 3));

SELECT *
FROM explain_index_has(use_idx_fixed = 1, filter = toFixedString('baz', 3));

SELECT *
FROM explain_index_has(use_idx_fixed = 1, filter = toFixedString('foo', 3));

SELECT *
FROM explain_index_has(use_idx_fixed = 1, filter = toFixedString('bar', 3));

SELECT *
FROM explain_index_has(use_idx_fixed = 1, filter = toFixedString('def', 3));

SELECT count()
FROM tab
WHERE hasAnyTokens(arr, 'foo');

SELECT count()
FROM tab
WHERE hasAnyTokens(arr, 'bar');

SELECT count()
FROM tab
WHERE hasAnyTokens(arr, 'foo bar');

SELECT count()
FROM tab
WHERE hasAnyTokens(arr_fixed, 'foo');

SELECT count()
FROM tab
WHERE hasAnyTokens(arr_fixed, 'bar');

SELECT count()
FROM tab
WHERE hasAnyTokens(arr_fixed, 'foo bar');

DROP VIEW IF EXISTS explain_index_has_any_tokens;

CREATE VIEW explain_index_has_any_tokens
AS
SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT count()
                FROM tab
                WHERE multiIf(0 = 1, hasAnyTokens(arr_fixed, 'placeholder'), hasAnyTokens(arr, 'placeholder'))
            ))
    )
WHERE `explain` LIKE '%Description:%'
    OR `explain` LIKE '%Granules:%'
LIMIT 2
OFFSET 1;

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 0, filter = 'abc');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 0, filter = 'baz');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 0, filter = 'foo');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 0, filter = 'foo bar');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 0, filter = 'def');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 1, filter = 'abc');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 1, filter = 'baz');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 1, filter = 'foo');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 1, filter = 'foo bar');

SELECT *
FROM explain_index_has_any_tokens(use_idx_fixed = 1, filter = 'def');

SELECT count()
FROM tab
WHERE hasAllTokens(arr, 'foo');

SELECT count()
FROM tab
WHERE hasAllTokens(arr, 'bar');

SELECT count()
FROM tab
WHERE hasAllTokens(arr, 'foo bar');

SELECT count()
FROM tab
WHERE hasAllTokens(arr_fixed, 'foo');

SELECT count()
FROM tab
WHERE hasAllTokens(arr_fixed, 'bar');

SELECT count()
FROM tab
WHERE hasAllTokens(arr_fixed, 'foo bar');

DROP VIEW IF EXISTS explain_index_has_all_tokens;

CREATE VIEW explain_index_has_all_tokens
AS
SELECT trimLeft(`explain`) AS `explain`
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', 'indexes = 1', (
                SELECT count()
                FROM tab
                WHERE multiIf(0 = 1, hasAllTokens(arr_fixed, 'placeholder'), hasAllTokens(arr, 'placeholder'))
            ))
    )
WHERE `explain` LIKE '%Description:%'
    OR `explain` LIKE '%Granules:%'
LIMIT 2
OFFSET 1;

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 0, filter = 'abc');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 0, filter = 'baz');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 0, filter = 'foo');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 0, filter = 'foo bar');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 0, filter = 'def');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 1, filter = 'abc');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 1, filter = 'baz');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 1, filter = 'foo');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 1, filter = 'foo bar');

SELECT *
FROM explain_index_has_all_tokens(use_idx_fixed = 1, filter = 'def');

DROP VIEW explain_index_has;

DROP VIEW explain_index_has_any_tokens;

DROP VIEW explain_index_has_all_tokens;

DROP TABLE tab;