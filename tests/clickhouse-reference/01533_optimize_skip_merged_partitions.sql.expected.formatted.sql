DROP TABLE IF EXISTS optimize_final;

SET optimize_skip_merged_partitions = '1';

CREATE TABLE optimize_final
(
    t DateTime,
    x Int32
)
ENGINE = MergeTree()
ORDER BY x
PARTITION BY toYYYYMM(t);

INSERT INTO optimize_final SELECT
    toDate('2020-01-01'),
    number
FROM numbers(5);

INSERT INTO optimize_final SELECT
    toDate('2020-01-01'),
    number + 5
FROM numbers(5);

OPTIMIZE TABLE optimize_final FINAL;

INSERT INTO optimize_final SELECT
    toDate('2000-01-01'),
    number
FROM numbers(5);

INSERT INTO optimize_final SELECT
    toDate('2000-01-01'),
    number + 5
FROM numbers(5);

SELECT
    table,
    `partition`,
    active,
    level
FROM `system`.parts
WHERE table = 'optimize_final'
    AND database = currentDatabase()
    AND active = 1;

DROP TABLE optimize_final;