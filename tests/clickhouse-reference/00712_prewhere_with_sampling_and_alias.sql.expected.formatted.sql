DROP TABLE IF EXISTS t_00712_2;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE t_00712_2
(
    date Date,
    counter UInt64,
    sampler UInt64,
    alias_col ALIAS date + 1
)
ENGINE = MergeTree(date, intHash32(sampler), (counter, date, intHash32(sampler)), 8192);

INSERT INTO t_00712_2;

SELECT alias_col
FROM t_00712_2 SAMPLE 1/2
WHERE date = '2018-01-01'
    AND counter = 1
    AND sampler = 1;