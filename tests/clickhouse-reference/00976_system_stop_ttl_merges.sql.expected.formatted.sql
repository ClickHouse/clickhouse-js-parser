DROP TABLE IF EXISTS ttl;

CREATE TABLE ttl
(
    d Date,
    a Int
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY toDayOfMonth(d)
TTL d + toIntervalDay(1);

SYSTEM STOP TTL MERGES ttl;

INSERT INTO ttl;

INSERT INTO ttl;

SELECT sleep(1)
FORMAT Null; -- wait if very fast merge happen

OPTIMIZE TABLE ttl PARTITION 10 FINAL;

SELECT *
FROM ttl
ORDER BY
    d ASC,
    a ASC;

SYSTEM START TTL MERGES ttl;