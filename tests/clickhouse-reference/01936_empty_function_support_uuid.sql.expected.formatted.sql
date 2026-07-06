SELECT empty(toUUID('00000000-0000-0000-0000-000000000000'));

SELECT notEmpty(toUUID('00000000-0000-0000-0000-000000000000'));

SELECT
    uniqIf(uuid, empty(uuid)),
    uniqIf(uuid, notEmpty(uuid))
FROM (
        SELECT toUUID('00000000-0000-0000-0000-000000000002') AS uuid
        UNION ALL
        SELECT toUUID('00000000-0000-0000-0000-000000000000') AS uuid
        UNION ALL
        SELECT toUUID('00000000-0000-0000-0000-000000000001') AS uuid
    );

DROP TABLE IF EXISTS users;

DROP TABLE IF EXISTS orders;

CREATE TABLE users
(
    user_id UUID
)
ENGINE = Memory();

CREATE TABLE orders
(
    order_id UUID,
    user_id UUID
)
ENGINE = Memory();

INSERT INTO users;

INSERT INTO users;

INSERT INTO orders;

SELECT
    uniq(user_id) AS users,
    uniqIf(order_id, notEmpty(order_id)) AS orders
FROM
    (
        SELECT *
        FROM users
    ) AS t1
ALL LEFT JOIN (
        SELECT *
        FROM orders
    ) AS t2
    USING (user_id);

DROP TABLE users;

DROP TABLE orders;