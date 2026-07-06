CREATE TABLE users
(
    uid Int16,
    name Nullable(String),
    age Int16
)
ENGINE = Memory();

INSERT INTO users;

INSERT INTO users;

INSERT INTO users;

SELECT countIf(name, uid > 2000)
FROM users;

SELECT countIf(name, uid > 2000)
FROM users;

SELECT countIf(uid > 2000)
FROM users;

SELECT countIf(uid > 2000)
FROM users;

DROP TABLE users;