-- Tags: no-async-insert
DROP TABLE IF EXISTS t_leading_zeroes;

DROP TABLE IF EXISTS t_leading_zeroes_f;

CREATE TABLE t_leading_zeroes
(
    id Int64,
    input String,
    val Int64,
    expected Int64,
    comment String
)
ENGINE = MergeTree()
ORDER BY id;

CREATE TABLE t_leading_zeroes_f
(
    id Int64,
    input String,
    val Float64,
    expected Float64,
    comment String
)
ENGINE = MergeTree()
ORDER BY id;

SET input_format_values_interpret_expressions = '0';

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

-- Floating point numbers go via readFloatTextFastImpl - so should not be affected
INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

-- Float negative zero is machine/context dependent
-- INSERT INTO t_leading_zeroes_f VALUES (2010, '-0', -0, 0, 'Single zero negative');
-- INSERT INTO t_leading_zeroes_f VALUES (2011, '-00', -00, 0, 'Double zero negative');
-- INSERT INTO t_leading_zeroes_f VALUES (2012, '-000000000000000', -000000000000000, 0, 'Mutliple redundant zeroes negative');
INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

-- Coincidentally, the following result in 9 rather than 9e9 because of readFloatTextFastImpl
-- using readUIntTextUpToNSignificantDigits<4>(exponent, in)
-- INSERT INTO t_leading_zeroes_f VALUES (2070, '00009e00009', 00009e00009, 9e9, '???');
-- Binary should not work with input_format_values_interpret_expressions = 0
INSERT INTO t_leading_zeroes_f; -- { error SYNTAX_ERROR }

INSERT INTO t_leading_zeroes_f; -- { error SYNTAX_ERROR }

INSERT INTO t_leading_zeroes_f; -- { error SYNTAX_ERROR }

INSERT INTO t_leading_zeroes; -- { error SYNTAX_ERROR }

INSERT INTO t_leading_zeroes; -- { error SYNTAX_ERROR }

INSERT INTO t_leading_zeroes; -- { error SYNTAX_ERROR }

SET input_format_values_interpret_expressions = '1';

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

INSERT INTO t_leading_zeroes;

-- Floating point numbers go via readFloatTextFastImpl - so should not be affected
INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

-- Float negative zero is machine/context dependent
-- INSERT INTO t_leading_zeroes_f VALUES (12010, '-0', -0, 0, 'Single zero negative');
-- INSERT INTO t_leading_zeroes_f VALUES (12011, '-00', -00, 0, 'Double zero negative');
-- INSERT INTO t_leading_zeroes_f VALUES (12012, '-000000000000000', -000000000000000, 0, 'Mutliple redundant zeroes negative');
INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

INSERT INTO t_leading_zeroes_f;

SELECT
    t.val = t.expected AS ok,
    *
FROM t_leading_zeroes AS t
ORDER BY id ASC;

SELECT
    t.val = t.expected AS ok,
    *
FROM t_leading_zeroes_f AS t
ORDER BY id ASC;