DROP TABLE IF EXISTS alter_00394;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE alter_00394
(
    d Date,
    k UInt64,
    i32 Int32,
    n Nested(ui8 UInt8, s String)
)
ENGINE = MergeTree(d, k, 8192);

INSERT INTO alter_00394;

INSERT INTO alter_00394;

INSERT INTO alter_00394;

ALTER TABLE alter_00394 ADD COLUMN `n.i8` Array(Int8) AFTER i32;

SELECT
    `n.i8`,
    `n.ui8`,
    `n.s`
FROM alter_00394
ORDER BY k ASC;

SELECT `n.i8`
FROM alter_00394
ORDER BY k ASC;

OPTIMIZE TABLE alter_00394;