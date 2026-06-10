-- Tags: shard
DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    val UInt8
)
ENGINE = MergeTree()
ORDER BY val;

INSERT INTO FUNCTION remote('127.0.0.2', currentDatabase(), tab);

INSERT INTO FUNCTION remote('127.0.0.{2|3}', currentDatabase(), tab);

INSERT INTO FUNCTION remote('127.0.0.{2|3|4}', currentDatabase(), tab);

SELECT *
FROM tab
ORDER BY val ASC;

DROP TABLE tab;