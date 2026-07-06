-- Must accept one to three arguments
SELECT tokens(); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT tokens('a', 'b', 'c', 'd'); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

-- 1st arg must be String or FixedString
SELECT tokens(1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

-- 2nd arg (if given) must be const String
SELECT tokens('a', 1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT tokens('a', toFixedString('b', 1)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT tokens('a', materialize('b')); -- { serverError ILLEGAL_COLUMN }

-- 2nd arg (if given) must be a supported tokenizer
SELECT tokens('a', 'unsupported_tokenizer'); -- { serverError BAD_ARGUMENTS }

-- 3rd arg (if given) must be
--    const UInt8 (for "ngram")
SELECT tokens('a', 'ngrams', 'c'); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT tokens('a', 'ngrams', toInt8(-1)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT tokens('a', 'ngrams', toFixedString('c', 1)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT tokens('a', 'ngrams', materialize(1)); -- { serverError ILLEGAL_COLUMN }

-- If 2nd arg is "ngram", then the 3rd arg must be larger than 0
SELECT tokens('a', 'ngrams', 0); -- { serverError BAD_ARGUMENTS}

SELECT tokens('a', 'ngrams', -1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT tokens('a', 'ngrams', 18446744073709552000.); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

--    const Array (for "split")
SELECT tokens('a', 'splitByString', 'c'); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT tokens('a', 'splitByString', toInt8(-1)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT tokens('a', 'splitByString', toFixedString('c', 1)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT tokens('a', 'splitByString', materialize(['c'])); -- { serverError ILLEGAL_COLUMN }

SELECT tokens('a', 'splitByString', [1, 2]); -- { serverError BAD_ARGUMENTS }

SELECT tokens('  a  bc d', 'splitByString', []); -- { serverError BAD_ARGUMENTS }

SELECT
    tokens('') AS tokenized,
    toTypeName(tokenized),
    isConstant(tokenized);

SELECT
    tokens('abc+ def- foo! bar? baz= code; hello: world/ xäöüx') AS tokenized,
    toTypeName(tokenized),
    isConstant(tokenized);

SELECT
    tokens('', 'ngrams') AS tokenized,
    toTypeName(tokenized),
    isConstant(tokenized);

SELECT
    tokens('abc def', 'ngrams') AS tokenized,
    toTypeName(tokenized),
    isConstant(tokenized);

SELECT
    tokens('abc def', 'ngrams', 3) AS tokenized,
    toTypeName(tokenized),
    isConstant(tokenized);

SELECT
    tokens('abc def', 'ngrams', 8) AS tokenized,
    toTypeName(tokenized),
    isConstant(tokenized);

SELECT
    tokens('', 'splitByString') AS tokenized,
    toTypeName(tokenized),
    isConstant(tokenized);

SELECT
    tokens('  a  bc d', 'splitByString', [' ']) AS tokenized,
    toTypeName(tokenized),
    isConstant(tokenized);

SELECT
    tokens('()()a()bc()d', 'splitByString', ['()']) AS tokenized,
    toTypeName(tokenized),
    isConstant(tokenized);

SELECT
    tokens(',()a(),bc,(),d,', 'splitByString', ['()', ',']) AS tokenized,
    toTypeName(tokenized),
    isConstant(tokenized);

SELECT
    tokens('\\a\n\\bc\\d\n', 'splitByString', ['\n', '\\']) AS tokenized,
    toTypeName(tokenized),
    isConstant(tokenized);

SELECT
    tokens('', 'array') AS tokenized,
    toTypeName(tokenized),
    isConstant(tokenized);

SELECT
    tokens('abc def', 'array') AS tokenized,
    toTypeName(tokenized),
    isConstant(tokenized);

SELECT '-- FixedString inputs';

SELECT
    tokens(toFixedString('abc+ def- foo! bar? baz= code; hello: world/', 44)) AS tokenized,
    toTypeName(tokenized),
    isConstant(tokenized);

SELECT
    tokens(materialize('abc+ def- foo! bar? baz= code; hello: world/')) AS tokenized,
    toTypeName(tokenized),
    isConstant(tokenized);

CREATE TABLE tab
(
    id Int64,
    str String
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO tab (id, str);

SELECT
    tokens(str, 'splitByNonAlpha') AS tokenized,
    toTypeName(tokenized),
    isConstant(tokenized)
FROM tab;

DROP TABLE tab;

INSERT INTO tab (id, str);

SELECT
    tokens(str, 'ngrams', 3) AS tokenized,
    toTypeName(tokenized),
    isConstant(tokenized)
FROM tab;

INSERT INTO tab (id, str);

SELECT
    tokens(str, 'splitByString', ['()', ',']) AS tokenized,
    toTypeName(tokenized),
    isConstant(tokenized)
FROM tab;

INSERT INTO tab (id, str);

SELECT
    tokens(str, 'array') AS tokenized,
    toTypeName(tokenized),
    isConstant(tokenized)
FROM tab;

SELECT tokens('', 'sparseGrams') AS tokenized;

SELECT tokens('abc def cba', 'sparseGrams') AS tokenized;

SELECT tokens('abc def cba', 'sparseGrams', 4, 10) AS tokenized;

SELECT tokens('abc def cba', 'sparseGrams', 4, 10, 6) AS tokenized;