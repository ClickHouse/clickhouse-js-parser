-- Tags: shard
DROP TABLE IF EXISTS storage;

CREATE TABLE storage
(
    UserID UInt64
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO storage (UserID);

SELECT sum(UserID GLOBAL IN (
        SELECT UserID
        FROM remote('127.0.0.{2,3}', currentDatabase(), storage)
    ))
FROM remote('127.0.0.{2,3}', currentDatabase(), storage);

SELECT sum(UserID GLOBAL IN (
        SELECT UserID
        FROM storage
    ))
FROM remote('127.0.0.{2,3}', currentDatabase(), storage);

DROP TABLE storage;