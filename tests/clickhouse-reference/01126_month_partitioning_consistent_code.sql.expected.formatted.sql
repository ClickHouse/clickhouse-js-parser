DROP TABLE IF EXISTS mt;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE mt
(
    d Date,
    x UInt8
)
ENGINE = MergeTree(d, x, 8192);

INSERT INTO mt;

DROP TABLE mt;