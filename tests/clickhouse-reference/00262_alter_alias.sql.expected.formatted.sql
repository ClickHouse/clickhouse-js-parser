DROP TABLE IF EXISTS aliases_test;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE aliases_test
(
    date DEFAULT today(),
    id DEFAULT rand(),
    `array` DEFAULT [0, 1, 2]
)
ENGINE = MergeTree(date, id, 1);

INSERT INTO aliases_test (id);

SELECT `array`
FROM aliases_test;

ALTER TABLE aliases_test MODIFY COLUMN `array` ALIAS [0, 1, 2];

ALTER TABLE aliases_test MODIFY COLUMN `array` DEFAULT [0, 1, 2];

ALTER TABLE aliases_test ADD COLUMN `struct.key` Array(UInt8) DEFAULT [0, 1, 2], ADD COLUMN `struct.value` Array(UInt8) DEFAULT `array`;

SELECT
    struct.key,
    struct.value
FROM aliases_test;

ALTER TABLE aliases_test MODIFY COLUMN `struct.value` ALIAS `array`;

SELECT
    struct.key,
    struct.value
FROM
    aliases_test
ARRAY JOIN struct;

SELECT
    struct.key,
    struct.value
FROM
    aliases_test
ARRAY JOIN struct AS struct;

SELECT
    class.key,
    class.value
FROM
    aliases_test
ARRAY JOIN struct AS class;

DROP TABLE aliases_test;