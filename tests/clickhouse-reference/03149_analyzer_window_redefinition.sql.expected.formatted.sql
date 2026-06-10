CREATE TABLE users
(
    uid Int16,
    name String,
    age Int16
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO users;

INSERT INTO users;

INSERT INTO users;

SELECT count(*) OVER w
FROM users
WINDOW
    w AS (ORDER BY uid ASC),
    w AS (ORDER BY name ASC); -- { serverError BAD_ARGUMENTS }