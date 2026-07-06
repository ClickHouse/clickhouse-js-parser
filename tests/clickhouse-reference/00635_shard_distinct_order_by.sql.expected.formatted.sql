-- Tags: shard
DROP TABLE IF EXISTS data;

CREATE TABLE data
(
    s String,
    x Int8,
    y Int8
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO data;

SELECT DISTINCT s
FROM remote('127.0.0.{1,2}', currentDatabase(), data)
ORDER BY
    x + y ASC,
    s ASC;

DROP TABLE data;