DROP TABLE IF EXISTS users SYNC;

DROP TABLE IF EXISTS messages SYNC;

CREATE TABLE users
(
    id Int64,
    name String
)
ENGINE = ReplicatedMergeTree('/clickhouse/{database}/tables/03623_users', 'r1')
ORDER BY tuple();

CREATE TABLE messages
(
    id Int64,
    user_id Int64,
    text String
)
ENGINE = ReplicatedMergeTree('/clickhouse/{database}/tables/03623_messages', 'r1')
ORDER BY tuple();

INSERT INTO users SELECT
    number,
    concat('user_', toString(number))
FROM numbers(10);

INSERT INTO users SELECT
    11,
    concat('user_', toString(11));

INSERT INTO messages SELECT
    100 + number,
    number,
    concat('message_', toString(number))
FROM numbers(11);

SET enable_parallel_replicas = '1', max_parallel_replicas = '3', cluster_for_parallel_replicas = 'test_cluster_one_shard_three_replicas_localhost';

SELECT '-- subquery INNER JOIN table';

SELECT
    name,
    c
FROM
    (
        SELECT
            user_id,
            count() AS c
        FROM messages
        GROUP BY user_id
    ) AS messages
INNER JOIN users
    ON messages.user_id = users.id
ORDER BY
    user_id ASC,
    c ASC;

SELECT
    name,
    c
FROM
    users
INNER JOIN (
        SELECT
            user_id,
            count() AS c
        FROM messages
        GROUP BY user_id
    ) AS messages
    ON messages.user_id = users.id
ORDER BY
    user_id ASC,
    c ASC;

SELECT
    name,
    c
FROM
    (
        SELECT
            user_id,
            count() AS c
        FROM messages
        GROUP BY user_id
    ) AS messages
LEFT JOIN users
    ON messages.user_id = users.id
ORDER BY
    user_id ASC,
    c ASC;

SELECT
    name,
    c
FROM
    users
LEFT JOIN (
        SELECT
            user_id,
            count() AS c
        FROM messages
        GROUP BY user_id
    ) AS messages
    ON messages.user_id = users.id
ORDER BY
    user_id ASC,
    c ASC;

SELECT
    name,
    c
FROM
    (
        SELECT
            user_id,
            count() AS c
        FROM messages
        GROUP BY user_id
    ) AS messages
RIGHT JOIN users
    ON messages.user_id = users.id
ORDER BY
    user_id ASC,
    c ASC;

SELECT
    name,
    c
FROM
    users
RIGHT JOIN (
        SELECT
            user_id,
            count() AS c
        FROM messages
        GROUP BY user_id
    ) AS messages
    ON messages.user_id = users.id
ORDER BY
    user_id ASC,
    c ASC;

DROP TABLE users SYNC;

DROP TABLE messages SYNC;