DROP TABLE IF EXISTS default_join1;

DROP TABLE IF EXISTS default_join2;

CREATE TABLE default_join1
(
    a Int64,
    b Int64
)
ENGINE = Memory();

CREATE TABLE default_join2
(
    a Int64,
    b Int64
)
ENGINE = Memory();

INSERT INTO default_join1;

INSERT INTO default_join2;

SELECT
    a,
    b
FROM
    default_join1
INNER JOIN (
        SELECT
            a,
            b
        FROM default_join2
    ) AS js2
    USING (a)
ORDER BY b ASC
SETTINGS join_default_strictness = 'ANY';

DROP TABLE default_join1;

DROP TABLE default_join2;