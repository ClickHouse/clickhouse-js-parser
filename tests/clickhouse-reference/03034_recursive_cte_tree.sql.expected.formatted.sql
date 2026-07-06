SET enable_analyzer = '1';

DROP TABLE IF EXISTS tree;

CREATE TABLE tree
(
    id UInt64,
    link Nullable(UInt64),
    data String
)
ENGINE = TinyLog();

INSERT INTO tree;

WITH RECURSIVE search_tree AS (
    SELECT
        id,
        link,
        data
    FROM tree AS t
    WHERE t.id = 0
    UNION ALL
    SELECT
        t.id,
        t.link,
        t.data
    FROM
        tree AS t,
        search_tree AS st
    WHERE t.link = st.id
)

SELECT *
FROM search_tree;

SELECT '--';

WITH RECURSIVE search_tree AS (
    SELECT
        id,
        link,
        data,
        [t.id] AS path
    FROM tree AS t
    WHERE t.id = 0
    UNION ALL
    SELECT
        t.id,
        t.link,
        t.data,
        arrayConcat(path, [t.id])
    FROM
        tree AS t,
        search_tree AS st
    WHERE t.link = st.id
)

SELECT *
FROM search_tree;

DROP TABLE tree;