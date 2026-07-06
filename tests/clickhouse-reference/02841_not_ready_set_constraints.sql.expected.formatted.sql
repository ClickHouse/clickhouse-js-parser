DROP TABLE IF EXISTS t1;

DROP TABLE IF EXISTS t2;

CREATE TABLE t1
(
    id UInt64
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO t1 (id);

CREATE TABLE t2
(
    conversation UInt64,
    CONSTRAINT constraint_conversation CHECK conversation IN (
        SELECT id
        FROM t1
    )
)
ENGINE = MergeTree()
ORDER BY conversation;

INSERT INTO t2 (conversation);

SELECT *
FROM t2;

DROP TABLE t1;

DROP TABLE t2;