-- https://github.com/ClickHouse/ClickHouse/issues/56466
SET enable_analyzer = '1';

DROP TABLE IF EXISTS users;

CREATE TABLE users
(
    uid Int16,
    name String,
    age Int16
)
ENGINE = Memory();

INSERT INTO users;

INSERT INTO users;

INSERT INTO users;

-- The query works when using a single SELECT *
SELECT *
FROM (
        SELECT
            name,
            age
        FROM users
    )
GROUP BY
    1,
    2
ORDER BY `ALL` ASC;

-- It doesn't when the GROUP BY is nested deeper
SELECT *
FROM (
        SELECT *
        FROM (
                SELECT
                    name,
                    age
                FROM users
            )
        GROUP BY
            1,
            2
    )
ORDER BY `ALL` ASC;