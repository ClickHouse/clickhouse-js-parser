DROP TABLE IF EXISTS local_table;

DROP TABLE IF EXISTS other_table;

CREATE TABLE local_table
(
    id Int32,
    name String,
    ts DateTime,
    oth_id Int32
)
ENGINE = MergeTree()
ORDER BY (ts, id)
PARTITION BY toMonday(ts);

CREATE TABLE other_table
(
    id Int32,
    name String,
    ts DateTime,
    trd_id Int32
)
ENGINE = MergeTree()
ORDER BY (ts, id)
PARTITION BY toMonday(ts);

INSERT INTO local_table;

INSERT INTO local_table;

INSERT INTO other_table;

INSERT INTO other_table;

SELECT t2.name
FROM
    remote('127.0.0.2', currentDatabase(), 'local_table') AS t1
LEFT JOIN CLICKHOUSE_DATABASE.other_table AS t2
    ON t1.oth_id = t2.id
ORDER BY t2.name ASC;

SELECT t2.name
FROM
    other_table AS t2
GLOBAL RIGHT JOIN remote('127.0.0.2', currentDatabase(), 'local_table') AS t1
    ON t1.oth_id = t2.id
ORDER BY t2.name ASC;

SELECT t2.name
FROM
    remote('127.0.0.2', currentDatabase(), 'local_table') AS t1
GLOBAL LEFT JOIN other_table AS t2
    ON t1.oth_id = t2.id
ORDER BY t2.name ASC;

SELECT other_table.name
FROM
    remote('127.0.0.2', currentDatabase(), 'local_table') AS t1
GLOBAL LEFT JOIN other_table
    ON t1.oth_id = other_table.id
ORDER BY other_table.name ASC;

SELECT other_table.name
FROM
    remote('127.0.0.2', currentDatabase(), 'local_table') AS t1
GLOBAL LEFT JOIN other_table AS t2
    ON t1.oth_id = other_table.id
ORDER BY other_table.name ASC;

DROP TABLE local_table;

DROP TABLE other_table;