SET allow_deprecated_syntax_for_merge_tree = '1';

DROP TABLE IF EXISTS array_pk;

CREATE TABLE array_pk
(
    key Array(UInt8),
    s String,
    n UInt64,
    d Date MATERIALIZED '2000-01-01'
)
ENGINE = MergeTree(d, (key, s, n), 1);

INSERT INTO array_pk;

INSERT INTO array_pk;

INSERT INTO array_pk;

INSERT INTO array_pk;

INSERT INTO array_pk;

INSERT INTO array_pk;

SELECT *
FROM array_pk
ORDER BY n ASC;

DETACH TABLE array_pk;

ATTACH TABLE array_pk;

DROP TABLE array_pk;