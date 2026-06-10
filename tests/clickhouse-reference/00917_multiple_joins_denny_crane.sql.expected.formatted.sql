SET joined_subquery_requires_alias = '0';

DROP TABLE IF EXISTS ANIMAL;

CREATE TABLE ANIMAL
(
    ANIMAL Nullable(String)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO ANIMAL (ANIMAL);

SELECT *
FROM (
        SELECT
            x.b AS x,
            countDistinct(x.c) AS ANIMAL
        FROM (
                SELECT
                    a.ANIMAL AS a,
                    'CAT' AS b,
                    c.ANIMAL AS c,
                    d.ANIMAL AS d
                FROM
                    ANIMAL AS a
                INNER JOIN ANIMAL AS b
                    ON a.ANIMAL = b.ANIMAL
                LEFT JOIN ANIMAL AS c
                    ON b.ANIMAL = c.ANIMAL
                RIGHT JOIN (
                        SELECT *
                        FROM ANIMAL
                        UNION ALL
                        SELECT *
                        FROM ANIMAL
                        UNION ALL
                        SELECT *
                        FROM ANIMAL
                    ) AS d
                    ON a.ANIMAL = d.ANIMAL
                WHERE d.ANIMAL != 'CAT'
                    AND c.ANIMAL != 'DOG'
                    AND b.ANIMAL != 'FISH'
            ) AS x
        WHERE x.b >= 'CAT'
        GROUP BY x.b
        HAVING ANIMAL >= 0
    ) AS ANIMAL
WHERE ANIMAL.ANIMAL >= 0;

DROP TABLE ANIMAL;