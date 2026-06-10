DROP TABLE IF EXISTS a;

DROP TABLE IF EXISTS j;

CREATE TABLE a
(
    id UInt32,
    val UInt32
)
ENGINE = Memory();

CREATE TABLE j
(
    id UInt32,
    val UInt8
)
ENGINE = Join(`ANY`, `LEFT`, id);

INSERT INTO a;

INSERT INTO j;

SELECT *
FROM
    a
ANY LEFT JOIN j
    USING (id)
ORDER BY
    a.id ASC,
    a.val ASC
SETTINGS enable_optimize_predicate_expression = '1';

SELECT *
FROM
    a
ANY LEFT JOIN j
    USING (id)
ORDER BY
    a.id ASC,
    a.val ASC
SETTINGS enable_optimize_predicate_expression = '0';

DROP TABLE a;

DROP TABLE j;

CREATE TABLE j
(
    id UInt8,
    val UInt8
)
ENGINE = Join(`ALL`, `INNER`, id);

SELECT *
FROM
    (
        SELECT
            0 AS id,
            1 AS val
    ) AS _
INNER JOIN j
    USING (id);