SET enable_analyzer = '1';

SET allow_experimental_correlated_subqueries = '0';

WITH arrayMap((x -> x + 1), [0]) AS a

SELECT 1
WHERE 1 IN (
        SELECT arrayJoin(a)
    );

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

CREATE OR REPLACE FUNCTION oldest_before AS age_max -> (
    SELECT uid
    FROM users
    WHERE users.age < age_max
    ORDER BY users.age DESC
    LIMIT 1
);

SELECT
    *,
    oldest_before(users.age)
FROM users; -- { serverError UNSUPPORTED_METHOD }