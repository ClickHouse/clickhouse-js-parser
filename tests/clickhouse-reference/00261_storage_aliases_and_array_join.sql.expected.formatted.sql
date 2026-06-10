DROP TABLE IF EXISTS aliases_test;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE aliases_test
(
    date Date,
    id UInt64,
    `array` DEFAULT ['zero', 'one', 'two'],
    d1 DEFAULT `array`,
    a1 ALIAS `array`,
    a2 ALIAS a1,
    a3 ALIAS a2,
    a4 ALIAS arrayMap((x -> toString(x)), range(3)),
    a5 ALIAS a4,
    a6 ALIAS a5,
    `struct.d1` DEFAULT `array`,
    `struct.a1` ALIAS `array`,
    `struct.a2` ALIAS `struct.a1`,
    `struct.a3` ALIAS `struct.a2`,
    `struct.a4` ALIAS arrayMap((x -> toString(x)), range(3)),
    `struct.a5` ALIAS `struct.a4`,
    `struct.a6` ALIAS `struct.a5`
)
ENGINE = MergeTree(date, id, 1);

INSERT INTO aliases_test (id);

SELECT '-- Ensure ALIAS columns are not selected by asterisk';

SELECT *
FROM aliases_test;

SELECT
    d1,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6
FROM aliases_test;

SELECT
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6
FROM aliases_test;

SELECT
    d1,
    a1
FROM
    aliases_test
ARRAY JOIN d1, a1;

SELECT
    d1,
    a1
FROM
    aliases_test
ARRAY JOIN d1, a1 AS a2;

SELECT
    d1,
    a1
FROM
    aliases_test
ARRAY JOIN d1 AS d2, a1;

SELECT
    d1,
    a1
FROM
    aliases_test
ARRAY JOIN d1 AS d2, a1 AS a2;

SELECT `array`
FROM
    aliases_test
ARRAY JOIN d1, a1;

SELECT `array`
FROM
    aliases_test
ARRAY JOIN d1 AS d2, a1 AS a1;

SELECT
    `array`,
    d1,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6
FROM
    aliases_test
ARRAY JOIN d1;

SELECT
    `array`,
    d1,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6
FROM
    aliases_test
ARRAY JOIN a1;

SELECT
    `array`,
    d1,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6
FROM
    aliases_test
ARRAY JOIN a2;

SELECT
    `array`,
    d1,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6
FROM
    aliases_test
ARRAY JOIN a3;

SELECT
    `array`,
    d1,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6
FROM
    aliases_test
ARRAY JOIN a4;

SELECT
    `array`,
    d1,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6
FROM
    aliases_test
ARRAY JOIN a5;

SELECT
    `array`,
    d1,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6
FROM
    aliases_test
ARRAY JOIN a6;

SELECT
    `array`,
    d1,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6
FROM
    aliases_test
ARRAY JOIN d1 AS d1;

SELECT
    `array`,
    d1,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6
FROM
    aliases_test
ARRAY JOIN a1 AS a1;

SELECT
    `array`,
    d1,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6
FROM
    aliases_test
ARRAY JOIN a2 AS a2;

SELECT
    `array`,
    d1,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6
FROM
    aliases_test
ARRAY JOIN a3 AS a3;

SELECT
    `array`,
    d1,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6
FROM
    aliases_test
ARRAY JOIN a4 AS a4;

SELECT
    `array`,
    d1,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6
FROM
    aliases_test
ARRAY JOIN a5 AS a5;

SELECT
    `array`,
    d1,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6
FROM
    aliases_test
ARRAY JOIN a6 AS a6;

SELECT
    `array`,
    d1,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6,
    joined
FROM
    aliases_test
ARRAY JOIN d1 AS joined;

SELECT
    `array`,
    d1,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6,
    joined
FROM
    aliases_test
ARRAY JOIN a1 AS joined;

SELECT
    `array`,
    d1,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6,
    joined
FROM
    aliases_test
ARRAY JOIN a2 AS joined;

SELECT
    `array`,
    d1,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6,
    joined
FROM
    aliases_test
ARRAY JOIN a3 AS joined;

SELECT
    `array`,
    d1,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6,
    joined
FROM
    aliases_test
ARRAY JOIN a4 AS joined;

SELECT
    `array`,
    d1,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6,
    joined
FROM
    aliases_test
ARRAY JOIN a5 AS joined;

SELECT
    `array`,
    d1,
    a1,
    a2,
    a3,
    a4,
    a5,
    a6,
    joined
FROM
    aliases_test
ARRAY JOIN a6 AS joined;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6
FROM
    aliases_test
ARRAY JOIN struct.d1;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6
FROM
    aliases_test
ARRAY JOIN struct.a1;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6
FROM
    aliases_test
ARRAY JOIN struct.a2;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6
FROM
    aliases_test
ARRAY JOIN struct.a3;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6
FROM
    aliases_test
ARRAY JOIN struct.a4;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6
FROM
    aliases_test
ARRAY JOIN struct.a5;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6
FROM
    aliases_test
ARRAY JOIN struct.a6;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6
FROM
    aliases_test
ARRAY JOIN struct.d1 AS `struct.d1`;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6
FROM
    aliases_test
ARRAY JOIN struct.a1 AS `struct.a1`;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6
FROM
    aliases_test
ARRAY JOIN struct.a2 AS `struct.a2`;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6
FROM
    aliases_test
ARRAY JOIN struct.a3 AS `struct.a3`;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6
FROM
    aliases_test
ARRAY JOIN struct.a4 AS `struct.a4`;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6
FROM
    aliases_test
ARRAY JOIN struct.a5 AS `struct.a5`;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6
FROM
    aliases_test
ARRAY JOIN struct.a6 AS `struct.a6`;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6,
    joined
FROM
    aliases_test
ARRAY JOIN struct.d1 AS joined;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6,
    joined
FROM
    aliases_test
ARRAY JOIN struct.a1 AS joined;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6,
    joined
FROM
    aliases_test
ARRAY JOIN struct.a2 AS joined;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6,
    joined
FROM
    aliases_test
ARRAY JOIN struct.a3 AS joined;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6,
    joined
FROM
    aliases_test
ARRAY JOIN struct.a4 AS joined;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6,
    joined
FROM
    aliases_test
ARRAY JOIN struct.a5 AS joined;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6,
    joined
FROM
    aliases_test
ARRAY JOIN struct.a6 AS joined;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6
FROM
    aliases_test
ARRAY JOIN struct;

SELECT `array`
FROM
    aliases_test
ARRAY JOIN struct;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6
FROM
    aliases_test
ARRAY JOIN struct AS struct;

SELECT `array`
FROM
    aliases_test
ARRAY JOIN struct AS struct;

SELECT
    `array`,
    class.d1,
    class.a1,
    class.a2,
    class.a3,
    class.a4,
    class.a5,
    class.a6
FROM
    aliases_test
ARRAY JOIN struct AS class;

SELECT `array`
FROM
    aliases_test
ARRAY JOIN struct AS class;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6
FROM
    aliases_test
ARRAY JOIN struct AS class;

SELECT
    `array`,
    struct.d1,
    struct.a1,
    struct.a2,
    struct.a3,
    struct.a4,
    struct.a5,
    struct.a6,
    class.d1,
    class.a1,
    class.a2,
    class.a3,
    class.a4,
    class.a5,
    class.a6
FROM
    aliases_test
ARRAY JOIN struct AS class;

DROP TABLE aliases_test;