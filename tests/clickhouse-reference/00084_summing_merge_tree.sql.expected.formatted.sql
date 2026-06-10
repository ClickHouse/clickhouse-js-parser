DROP TABLE IF EXISTS summing_merge_tree;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE summing_merge_tree
(
    d Date,
    a String,
    x UInt32,
    y UInt64,
    z Float64
)
ENGINE = SummingMergeTree(d, a, 8192);

INSERT INTO summing_merge_tree;

INSERT INTO summing_merge_tree;

INSERT INTO summing_merge_tree;

OPTIMIZE TABLE summing_merge_tree;

SELECT *
FROM summing_merge_tree
ORDER BY
    d ASC,
    a ASC,
    x ASC,
    y ASC,
    z ASC;

DROP TABLE summing_merge_tree;

CREATE TABLE summing_merge_tree
(
    d Date,
    a String,
    x UInt32,
    y UInt64,
    z Float64
)
ENGINE = SummingMergeTree(d, a, 8192, (y, z));

--
DROP TABLE IF EXISTS summing;

CREATE TABLE summing
(
    p Date,
    k UInt64,
    s UInt64
)
ENGINE = SummingMergeTree(p, k, 1);

INSERT INTO summing (k, s);

INSERT INTO summing (k, s);

OPTIMIZE TABLE summing PARTITION 197001;

SELECT
    k,
    s
FROM summing
ORDER BY k ASC;

DROP TABLE summing;