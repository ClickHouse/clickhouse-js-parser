DROP TABLE IF EXISTS foo;

CREATE TABLE foo
(
    bar String,
    PROJECTION p (SELECT * APPLY(groupUniqArray(100)))
)
ENGINE = MergeTree()
ORDER BY bar;

SHOW CREATE TABLE foo;

DETACH TABLE foo;

ATTACH TABLE foo;

DROP TABLE foo;