DROP TABLE IF EXISTS unsorted;

CREATE TABLE unsorted
(
    x UInt32,
    y String
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS vertical_merge_algorithm_min_rows_to_activate = '0', vertical_merge_algorithm_min_columns_to_activate = '0';

INSERT INTO unsorted;

INSERT INTO unsorted;

INSERT INTO unsorted;

OPTIMIZE TABLE unsorted PARTITION tuple() FINAL;

SELECT *
FROM unsorted;

DROP TABLE unsorted;

DROP TABLE IF EXISTS unsorted_replacing;

CREATE TABLE unsorted_replacing
(
    x UInt32,
    s String,
    v UInt32
)
ENGINE = ReplacingMergeTree(v)
ORDER BY tuple();

INSERT INTO unsorted_replacing;

INSERT INTO unsorted_replacing;

INSERT INTO unsorted_replacing;

SELECT *
FROM unsorted_replacing FINAL;

SELECT '---';

OPTIMIZE TABLE unsorted_replacing PARTITION tuple() FINAL;

SELECT *
FROM unsorted_replacing;

DROP TABLE unsorted_replacing;

DROP TABLE IF EXISTS unsorted_collapsing;

CREATE TABLE unsorted_collapsing
(
    x UInt32,
    s String,
    sign Int8
)
ENGINE = CollapsingMergeTree(sign)
ORDER BY tuple();

INSERT INTO unsorted_collapsing;

INSERT INTO unsorted_collapsing;

INSERT INTO unsorted_collapsing;

SELECT *
FROM unsorted_collapsing FINAL;

OPTIMIZE TABLE unsorted_collapsing PARTITION tuple() FINAL;

SELECT *
FROM unsorted_collapsing;

DROP TABLE unsorted_collapsing;