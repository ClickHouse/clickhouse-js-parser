DROP TABLE IF EXISTS table1;

DROP TABLE IF EXISTS table2;

CREATE TABLE table1
(
    id1 UInt64,
    id2 UInt8
)
ENGINE = MergeTree()
ORDER BY id1 AS
SELECT
    1,
    1;

CREATE TABLE table2
(
    id1 UInt64,
    id2 UInt8
)
ENGINE = Memory() AS
SELECT
    1,
    1;

SELECT *
FROM table1
WHERE (id1, id2) IN (
        SELECT tuple(id1, id2)
        FROM table2
    );

DROP TABLE table1;

DROP TABLE table2;