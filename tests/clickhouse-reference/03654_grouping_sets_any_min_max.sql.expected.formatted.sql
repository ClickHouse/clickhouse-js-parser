SET enable_analyzer = '1';

SELECT
    grouping(num1),
    num1,
    any(num1),
    min(num1),
    max(num1),
    sum(num1),
    avg(num1),
    count(num1),
    any(num2),
    min(num2),
    max(num2),
    sum(num2),
    avg(num2),
    count(num2)
FROM (
        SELECT
            10 AS num1,
            20 AS num2
    )
GROUP BY GROUPING SETS ((num1), ())
ORDER BY grouping(num1) DESC;

DROP TABLE IF EXISTS users;

CREATE TABLE users
(
    uid Int16,
    name String,
    age Int16,
    ts DateTime
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO users;

INSERT INTO users;

INSERT INTO users;

INSERT INTO users;

INSERT INTO users;

INSERT INTO users;

SELECT arrayStringConcat(groupArray('-'))
FROM numbers(67);

-- Query A
SELECT
    uid,
    name,
    sum(age),
    count(),
    arrayUniq(groupArray(ts)),
    max(age),
    max(ts)
FROM users
GROUP BY GROUPING SETS ((*), ())
ORDER BY `ALL` ASC;

-- Query B
SELECT
    uid,
    name,
    sum(age),
    count(),
    arrayUniq(groupArray(ts)),
    max(age),
    max(ts)
FROM users
GROUP BY GROUPING SETS ((uid, name), ())
ORDER BY `ALL` ASC;

DROP TABLE users;