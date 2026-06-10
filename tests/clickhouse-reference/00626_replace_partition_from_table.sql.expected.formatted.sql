DROP TABLE IF EXISTS src;

DROP TABLE IF EXISTS dst;

CREATE TABLE src
(
    p UInt64,
    k String,
    d UInt64
)
ENGINE = MergeTree()
ORDER BY k
PARTITION BY p;

CREATE TABLE dst
(
    p UInt64,
    k String,
    d UInt64
)
ENGINE = MergeTree()
ORDER BY k
PARTITION BY p
SETTINGS merge_selector_base = '1000';

INSERT INTO src;

INSERT INTO src;

INSERT INTO src;

INSERT INTO src;

INSERT INTO dst;

INSERT INTO dst;

INSERT INTO dst;

SELECT
    count(),
    sum(d)
FROM src;

SELECT
    count(),
    sum(d)
FROM dst;

ALTER TABLE dst REPLACE PARTITION 1 FROM src;

ALTER TABLE src DROP PARTITION 1;

ALTER TABLE dst DROP PARTITION 1;

CREATE TEMPORARY TABLE test_block_numbers
(
    m UInt64
);

INSERT INTO test_block_numbers SELECT max(max_block_number) AS m
FROM `system`.parts
WHERE database = currentDatabase()
    AND table = 'dst'
    AND active
    AND name LIKE '1_%';

ALTER TABLE dst REPLACE PARTITION 1 FROM dst;

SELECT max(m) - min(m) > 1 AS new_block_is_generated
FROM test_block_numbers;

DROP TEMPORARY TABLE test_block_numbers;

DROP TABLE src;

INSERT INTO src;

INSERT INTO src;

SYSTEM STOP MERGES dst;

INSERT INTO dst;

ALTER TABLE dst ATTACH PARTITION 1 FROM src;

ALTER TABLE dst ATTACH PARTITION ALL FROM src;

SELECT
    count(),
    sum(d),
    uniqExact(_part)
FROM dst;

SYSTEM START MERGES dst;

SET optimize_throw_if_noop = '1';

OPTIMIZE TABLE dst;

DETACH TABLE dst;

ATTACH TABLE dst;

ALTER TABLE dst DETACH PARTITION 0;

ALTER TABLE dst DETACH PARTITION 1;

ALTER TABLE dst DETACH PARTITION 2;

ALTER TABLE dst ATTACH PARTITION 1;