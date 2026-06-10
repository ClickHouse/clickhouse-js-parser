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

CREATE ROW POLICY a ON users USING arrayExists((a -> a = age), [uid]) TO ALL;

SELECT *
FROM users;