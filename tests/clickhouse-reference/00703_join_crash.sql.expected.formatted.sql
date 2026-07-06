DROP TABLE IF EXISTS tab1;

DROP TABLE IF EXISTS tab1_copy;

CREATE TABLE tab1
(
    a1 Int32,
    b1 Int32
)
ENGINE = MergeTree()
ORDER BY a1;

CREATE TABLE tab1_copy
(
    a1 Int32,
    b1 Int32
)
ENGINE = MergeTree()
ORDER BY a1;

INSERT INTO tab1;

INSERT INTO tab1_copy;

SELECT
    tab1.a1,
    tab1_copy.a1,
    tab1.b1
FROM
    tab1
ANY LEFT JOIN tab1_copy
    ON tab1.b1 + 3 = tab1_copy.b1 + 2;

DROP TABLE tab1;

DROP TABLE tab1_copy;