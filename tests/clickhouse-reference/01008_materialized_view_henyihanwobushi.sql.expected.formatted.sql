DROP TABLE IF EXISTS foo;

DROP TABLE IF EXISTS bar;

DROP TABLE IF EXISTS view_foo_bar;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE foo
(
    ddate Date,
    id Int64,
    n String
)
ENGINE = ReplacingMergeTree(ddate, id, 8192);

CREATE TABLE bar
(
    ddate Date,
    id Int64,
    n String,
    foo_id Int64
)
ENGINE = ReplacingMergeTree(ddate, id, 8192);

INSERT INTO bar (id, n, foo_id);

CREATE MATERIALIZED VIEW view_foo_bar
ENGINE = ReplacingMergeTree(ddate, bar_id, 8192)
AS
SELECT
    ddate,
    bar_id,
    bar_n,
    foo_id,
    foo_n
FROM
    (
        SELECT
            ddate,
            id AS bar_id,
            n AS bar_n,
            foo_id
        FROM bar
    ) AS js1
ANY LEFT JOIN (
        SELECT
            id AS foo_id,
            n AS foo_n
        FROM foo
    ) AS js2
    USING (foo_id);

SELECT *
FROM view_foo_bar;

DROP TABLE foo;

DROP TABLE bar;

DROP TABLE view_foo_bar;