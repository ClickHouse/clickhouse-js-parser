DROP TABLE IF EXISTS trepl;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE trepl
(
    d Date,
    a Int32,
    b Int32
)
ENGINE = ReplacingMergeTree(d, (a, b), 8192);

INSERT INTO trepl;

SELECT b
FROM trepl FINAL
PREWHERE a < 1000;

DROP TABLE trepl;

DROP TABLE IF EXISTS versioned_collapsing;

CREATE TABLE versioned_collapsing
(
    d Date,
    x UInt32,
    sign Int8,
    version UInt32
)
ENGINE = VersionedCollapsingMergeTree(d, x, 8192, sign, version);

INSERT INTO versioned_collapsing;

SELECT x
FROM versioned_collapsing FINAL
PREWHERE version < 1000;

DROP TABLE versioned_collapsing;