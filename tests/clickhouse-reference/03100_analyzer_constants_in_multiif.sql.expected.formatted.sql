-- https://github.com/ClickHouse/ClickHouse/issues/59101
SET enable_analyzer = '1';

CREATE TABLE users
(
    name String,
    age Int16
)
ENGINE = Memory();

INSERT INTO users;

INSERT INTO users;

INSERT INTO users;

SELECT
    multiIf(age > 30
    OR true, '1', '2') AS a,
    max(name)
FROM users
GROUP BY a;