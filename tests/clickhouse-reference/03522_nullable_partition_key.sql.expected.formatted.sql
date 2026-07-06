CREATE TABLE t
(
    c0 Nullable(Int)
)
ENGINE = MergeTree()
ORDER BY c0
PARTITION BY c0
SETTINGS allow_nullable_key = '1';

INSERT INTO t (c0);

OPTIMIZE TABLE t FINAL;

SELECT
    c0,
    _part
FROM t
ORDER BY `ALL` ASC;

CREATE TABLE taggr
(
    c0 Nullable(Int)
)
ENGINE = AggregatingMergeTree()
ORDER BY c0
PARTITION BY c0
SETTINGS allow_nullable_key = '1';

INSERT INTO taggr (c0);

INSERT INTO taggr (c0);

SELECT
    c0,
    _part
FROM taggr FINAL
ORDER BY `ALL` ASC;