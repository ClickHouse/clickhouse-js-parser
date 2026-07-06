-- Tags: shard, long
DROP TABLE IF EXISTS group_uniq_str;

CREATE TABLE group_uniq_str
ENGINE = Memory() AS
SELECT
    number % 10 AS id,
    toString(intDiv(number % 10000, 10)) AS v
FROM `system`.numbers
LIMIT 10000000;

INSERT INTO group_uniq_str SELECT
    2 AS id,
    toString(number % 100) AS v
FROM `system`.numbers
LIMIT 1000000;

INSERT INTO group_uniq_str SELECT
    5 AS id,
    toString(number % 100) AS v
FROM `system`.numbers
LIMIT 10000000;

-- Prevent remote replicas from skipping index analysis in Parallel Replicas. Otherwise, they may return full ranges and trigger max_rows_to_read validation failures.
SET parallel_replicas_index_analysis_only_on_coordinator = '0';

SELECT length(groupUniqArray(v))
FROM group_uniq_str
GROUP BY id
ORDER BY id ASC;

SELECT length(groupUniqArray(v))
FROM remote('127.0.0.{2,3,4,5}', currentDatabase(), 'group_uniq_str')
GROUP BY id
ORDER BY id ASC
SETTINGS max_rows_to_read = '100M';

SELECT length(groupUniqArray(10)(v))
FROM group_uniq_str
GROUP BY id
ORDER BY id ASC;

SELECT length(groupUniqArray(10000)(v))
FROM group_uniq_str
GROUP BY id
ORDER BY id ASC;