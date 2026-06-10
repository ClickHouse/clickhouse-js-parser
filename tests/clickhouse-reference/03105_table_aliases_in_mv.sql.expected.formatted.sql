-- https://github.com/ClickHouse/ClickHouse/issues/10894
DROP TABLE IF EXISTS event;

DROP TABLE IF EXISTS user;

DROP TABLE IF EXISTS mv;

CREATE TABLE event
(
    event_time DateTime,
    event_name String,
    user_id String
)
ENGINE = MergeTree()
ORDER BY (event_time, event_name);

CREATE TABLE user
(
    user_id String,
    user_type String
)
ENGINE = MergeTree()
ORDER BY user_id;

INSERT INTO event;

INSERT INTO user;

CREATE MATERIALIZED VIEW mv
(
    event_time DateTime,
    event_name String,
    user_id String,
    user_type String
)
ENGINE = MergeTree()
ORDER BY (event_time, event_name)
POPULATE
AS
SELECT
    e.event_time,
    e.event_name,
    e.user_id,
    u.user_type
FROM
    event AS e
INNER JOIN user AS u
    ON u.user_id = e.user_id;