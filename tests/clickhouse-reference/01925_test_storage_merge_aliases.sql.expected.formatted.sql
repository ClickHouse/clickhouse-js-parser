-- Tags: no-parallel
DROP TABLE IF EXISTS merge;

CREATE TABLE merge
(
    dt Date,
    colAlias0 Int32,
    colAlias1 Int32,
    col2 Int32,
    colAlias2 UInt32,
    col3 Int32,
    colAlias3 UInt32
)
ENGINE = Merge(currentDatabase(), '^alias_');

DROP TABLE IF EXISTS alias_1;

DROP TABLE IF EXISTS alias_2;

CREATE TABLE alias_1
(
    dt Date,
    col Int32,
    colAlias0 UInt32 ALIAS col,
    colAlias1 UInt32 ALIAS col3 + colAlias0,
    col2 Int32,
    colAlias2 Int32 ALIAS colAlias1 + col2 + 10,
    col3 Int32,
    colAlias3 Int32 ALIAS colAlias2 + colAlias1 + col3
)
ENGINE = MergeTree()
ORDER BY dt;

INSERT INTO alias_1 (dt, col, col2, col3);

SELECT
    colAlias0,
    colAlias1,
    colAlias2,
    colAlias3
FROM alias_1;

SELECT
    colAlias3,
    colAlias2,
    colAlias1,
    colAlias0
FROM merge;

SELECT *
FROM merge;

CREATE TABLE alias_2
(
    dt Date,
    col Int32,
    col2 Int32,
    colAlias0 UInt32 ALIAS col,
    colAlias3 Int32 ALIAS col3 + colAlias0,
    colAlias1 UInt32 ALIAS colAlias0 + col2,
    colAlias2 Int32 ALIAS colAlias0 + colAlias1,
    col3 Int32
)
ENGINE = MergeTree()
ORDER BY dt;

INSERT INTO alias_2 (dt, col, col2, col3);

SELECT
    colAlias0,
    colAlias1,
    colAlias2,
    colAlias3
FROM alias_2;

SELECT
    colAlias3,
    colAlias2,
    colAlias1,
    colAlias0
FROM merge
ORDER BY dt ASC;

SELECT *
FROM merge
ORDER BY dt ASC;