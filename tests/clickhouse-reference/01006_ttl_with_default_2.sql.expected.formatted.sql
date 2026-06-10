DROP TABLE IF EXISTS ttl_with_default;

CREATE TABLE ttl_with_default
(
    d DateTime,
    a Int DEFAULT 777 TTL d + toIntervalSecond(5)
)
ENGINE = MergeTree()
ORDER BY d;

INSERT INTO ttl_with_default;

SELECT sleep(0.7)
FORMAT Null; -- wait if very fast merge happen

OPTIMIZE TABLE ttl_with_default FINAL;

SELECT a
FROM ttl_with_default
ORDER BY a ASC;

DROP TABLE ttl_with_default;