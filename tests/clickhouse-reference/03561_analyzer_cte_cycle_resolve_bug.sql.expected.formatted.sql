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

SET enable_analyzer = '1';

WITH users AS (
    WITH t AS (
        SELECT *
        FROM users
    )

    SELECT *
    FROM t
)

SELECT *
FROM users
FORMAT Null;