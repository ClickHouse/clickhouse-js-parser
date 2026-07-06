DROP TABLE IF EXISTS users;

DROP TABLE IF EXISTS events;

CREATE TABLE users
(
    uid UInt64,
    name String,
    age UInt8
)
ENGINE = Join(`ALL`, `LEFT`, uid);

CREATE TABLE events
(
    uid UInt64,
    user_id UInt64,
    message String
)
ENGINE = Memory();

INSERT INTO users;

INSERT INTO events;

SELECT
    event.message,
    user.name,
    user.age
FROM
    events AS event
LEFT JOIN users AS user
    ON event.user_id = user.uid
WHERE user.uid > 0
ORDER BY user.age ASC;