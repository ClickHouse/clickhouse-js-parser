SET enable_analyzer = '1';

SET query_plan_join_swap_table = false;

SET enable_join_runtime_filters = '0';

DROP TABLE IF EXISTS users;

CREATE TABLE users
(
    uid Int16,
    name String,
    age Int16
)
ENGINE = MergeTree()
ORDER BY (uid, name);

INSERT INTO users;

INSERT INTO users;

INSERT INTO users;

DROP TABLE IF EXISTS users2;

CREATE TABLE users2
(
    uid Int16,
    name String,
    age2 Int16
)
ENGINE = MergeTree()
ORDER BY (uid, name);

INSERT INTO users2;

INSERT INTO users2;

INSERT INTO users2;

-- { echoOn }
EXPLAIN header = '1', indexes = '1'
SELECT name
FROM
    users
INNER JOIN users2
    USING (name)
WHERE users.name = 'Alice';

SELECT '--';

EXPLAIN header = '1', indexes = '1'
SELECT name
FROM
    users
LEFT JOIN users2
    USING (name)
WHERE users.name = 'Alice';

EXPLAIN header = '1', indexes = '1'
SELECT name
FROM
    users
RIGHT JOIN users2
    USING (name)
WHERE users2.name = 'Alice';

-- { echoOff }
DROP TABLE users;

DROP TABLE users2;