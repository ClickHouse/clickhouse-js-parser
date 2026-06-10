DROP TABLE IF EXISTS tab_00650;

CREATE TABLE tab_00650
(
    val UInt32,
    n Nested(x UInt8, y String)
)
ENGINE = Memory();

INSERT INTO tab_00650;

SELECT arrayEnumerateUniq(n.x)
FROM tab_00650;

SELECT arrayEnumerateUniq(n.y)
FROM tab_00650;

SELECT arrayEnumerateUniq(n.x, n.y)
FROM tab_00650;

SELECT arrayEnumerateUniq(arrayMap(((a, b) -> (a, b)), n.x, n.y))
FROM tab_00650;

SELECT arrayEnumerateUniq(arrayMap(((a, b) -> (a, b)), n.x, n.y), n.x)
FROM tab_00650;

SELECT arrayEnumerateUniq(arrayMap(((a, b) -> (a, b)), n.x, n.y), arrayMap(((a, b) -> (b, a)), n.x, n.y))
FROM tab_00650;

DROP TABLE tab_00650;

CREATE TABLE tab_00650
(
    val UInt32,
    n Nested(x Nullable(UInt8), y String)
)
ENGINE = Memory();

INSERT INTO tab_00650;