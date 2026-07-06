DROP TABLE IF EXISTS empty_summing;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE empty_summing
(
    d Date,
    k UInt64,
    v Int8
)
ENGINE = SummingMergeTree(d, k, 8192);

INSERT INTO empty_summing;

INSERT INTO empty_summing;

OPTIMIZE TABLE empty_summing;

SELECT *
FROM empty_summing;

INSERT INTO empty_summing;

INSERT INTO empty_summing;

INSERT INTO empty_summing;

DROP TABLE empty_summing;