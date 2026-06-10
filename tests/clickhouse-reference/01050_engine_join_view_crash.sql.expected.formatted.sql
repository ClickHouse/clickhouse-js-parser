DROP TABLE IF EXISTS a;

DROP TABLE IF EXISTS b;

DROP TABLE IF EXISTS id1;

DROP TABLE IF EXISTS id2;

CREATE TABLE a
(
    id1 UInt32,
    id2 UInt32,
    valA UInt32
)
ENGINE = TinyLog();

CREATE TABLE id1
(
    id1 UInt32,
    val1 UInt8
)
ENGINE = Join(`ANY`, `LEFT`, id1);

CREATE TABLE id2
(
    id2 UInt32,
    val2 UInt8
)
ENGINE = Join(`ANY`, `LEFT`, id2);

INSERT INTO a;

INSERT INTO id1;

INSERT INTO id2;

SELECT *
FROM
    (
        SELECT *
        FROM
            a
        ANY LEFT JOIN id1
            USING (id1)
    ) AS js1
ANY LEFT JOIN id2
    USING (id2);

CREATE VIEW b
AS
SELECT *
FROM
    (
        SELECT *
        FROM
            a
        ANY LEFT JOIN id1
            USING (id1)
    ) AS js1
ANY LEFT JOIN id2
    USING (id2);

SELECT *
FROM b;

DROP TABLE a;

DROP TABLE b;

DROP TABLE id1;

DROP TABLE id2;