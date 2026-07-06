-- Tags: shard
DROP TABLE IF EXISTS tlb;

CREATE TABLE tlb
(
    k UInt64
)
ENGINE = MergeTree()
ORDER BY k;

INSERT INTO tlb (k) SELECT 0
FROM numbers(100);

INSERT INTO tlb (k) SELECT 1;

-- { echoOn }
-- with limit
SELECT k
FROM remote('127.0.0.{2,3}', currentDatabase(), tlb)
ORDER BY k ASC
LIMIT 1 BY k
LIMIT 100;

-- w/o limit
SELECT k
FROM remote('127.0.0.{2,3}', currentDatabase(), tlb)
ORDER BY k ASC
LIMIT 1 BY k;

-- { echoOff }
DROP TABLE tlb;